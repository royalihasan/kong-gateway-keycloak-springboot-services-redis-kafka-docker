-- Import required Lua libraries
local redis = require "resty.redis"
local http = require "resty.http"
local cjson = require "cjson"
local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

-- Define the handler for the plugin
local redis_rpt_handler = {
    VERSION = "1.0.0",
    PRIORITY = 1000,

}
-- Define the function for handling Redis RPT (Requesting Party Token)
function redis_rpt_handler:access(config)
    -- Get the apiKey from the request URL parameters
    local uri_args = ngx.req.get_uri_args()
    local api_key = uri_args["apiKey"]
    -- log the apiKey
    print("\nINFO:API_KEY: ", api_key)
    if not api_key then
        ngx.log(ngx.ERR, "apiKey not found in request URL")
        return ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
    -- Connect to Redis
    local red = redis:new()
    red:set_timeout(config.redis_timeout)
    local ok, err = red:connect(config.redis_host, config.redis_port)
    if not ok then
        ngx.log(ngx.ERR, "Failed to connect to Redis: ", err)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end
    if config.redis_password then
        local ok, err = red:auth(config.redis_password)
        if not ok then
            ngx.log(ngx.ERR, "Failed to authenticate to Redis: ", err)
            return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
        end
    end
    -- Retrieve token from Redis based on apiKey
    local token, err = red:get(api_key)
    print("\nINFO:JWT_TOKEN: ", token)

    --verify token
    local jwt, err = jwt_decoder:new(token)
    if err then
        ngx.log(ngx.ERR, "Failed to decode token: ", err)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end
    local claims = jwt.claims
    print("\nINFO:CLAIMS: ", cjson.encode(claims))

    if err then
        ngx.log(ngx.ERR, "Failed to retrieve token from Redis: ", err)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end
    if token == ngx.null then
        ngx.log(ngx.ERR, "No token found for apiKey: ", api_key)
        return ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end

    --Now get the RPT token from keycloak server
    local httpc = http:new()
    local concat_token_with_bearer = { "Bearer", token }
    local bearer_token = table.concat(concat_token_with_bearer, " ")
    print("\nINFO:BEARER_TOKEN ", bearer_token)
    local res, err = httpc:request_uri(config.rpt_endpoint, {
        method = "POST",
        ssl_verify = false,
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["Cache-Control"] = "no-cache",
            ["Accept"] = "*/*",
            ["Host"] = "localhost:8080",
            ["Authorization"] = "Bearer " .. token,

        },
        body = ngx.encode_args({
            grant_type = "urn:ietf:params:oauth:grant-type:uma-ticket",
            audience = "client_service_alpha"
        }),
    })
    --print response
    print("\nINFO:RPT_RESPONSE: ", res.body)
    if not res then
        ngx.log(ngx.ERR, "Failed to request RPT token: ", err)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    -- Check if the response is successful
    if res.status < 200 or res.status >= 300 then
        ngx.log(ngx.ERR, "Failed to get RPT token: ", res.status, " ", res.reason)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    -- get the access token from the response
    local response_data = cjson.decode(res.body)
    local rpt_token = response_data and response_data.access_token
    if not rpt_token then
        ngx.log(ngx.ERR, "Failed to parse RPT token from response")
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    print("\nINFO:RPT_TOKEN: ", rpt_token)
    if rpt_token == ngx.null then
        ngx.log(ngx.ERR, "No RPT token found for apiKey: ", api_key)
        -- Add RPT token to request header
    end
    --Set Authorization header as RPT token
    ngx.req.set_header("Authorization", "Bearer " .. rpt_token)
    -- Close Redis connection
    red:close()
end
return redis_rpt_handler
