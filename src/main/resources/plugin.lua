local BasePlugin = require( "kong.plugins.base_plugin")

local CustomPlugin = BasePlugin:extend()

function CustomPlugin:new()
  CustomPlugin.super.new(self, "custom-plugin")
end

function CustomPlugin:access(plugin_conf)
  -- Logic to fetch data from Redis using Lua Redis library
  local redis = require "resty.redis"
  local red = redis:new()

  local ok, err = red:connect("127.0.0.1", 6379)
  if not ok then
    ngx.log(ngx.ERR, "failed to connect to Redis: ", err)
    return ngx.exit(500)
  end

  local value, err = red:get(plugin_conf.redis_key)
  if not value then
    ngx.log(ngx.ERR, "failed to get value from Redis: ", err)
  else
    -- Attach fetched value to header
    ngx.req.set_header(plugin_conf.header_name, value)
  end

  red:set_keepalive(10000, 100)
end

return CustomPlugin
