local redis = require("resty.redis")
local cjson = require("cjson")

local RedisTokenHandler = {
    VERSION = "1.0.0",
    PRIORITY = 10,
}

function RedisTokenHandler:access(config)
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
    if err then
        ngx.log(ngx.ERR, "Failed to retrieve token from Redis: ", err)
        return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
    end

    if token == ngx.null then
        ngx.log(ngx.ERR, "No token found for apiKey: ", api_key)
        return ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end

    -- Add token to request header
    --ngx.req.set_header(config.token_header, token)
    ngx.req.set_header(config.token_header, "Bearer " .. token)

    -- Close Redis connection
    red:close()
end

return RedisTokenHandler
