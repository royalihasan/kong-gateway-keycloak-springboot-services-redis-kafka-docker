local typedefs = require "kong.db.schema.typedefs"
return {
    name = "kong-redis-jwt",
    fields = {
        { consumer = typedefs.no_consumer },
        { protocols = typedefs.protocols_http },
        {
            config = {
                type = "record",
                fields = {
                    { redis_host = { type = "string", required = true, default = "redis" } },
                    { redis_port = { type = "number", default = 6379 } },
                    { redis_password = { type = "string" } },
                    { redis_timeout = { type = "number", default = 2000 } },
                    { token_header = { type = "string", default = "Authorization" } },
                },
            },
        },
    },
}

-- Path: handler.lua
