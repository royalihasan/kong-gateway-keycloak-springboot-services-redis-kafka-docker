local typedefs = require "kong.db.schema.typedefs"

return {
    name = "redis-rpt",
    fields = {
        { consumer = typedefs.no_consumer },
        { protocols = typedefs.protocols_http },
        { config = {
            type = "record",
            fields = {
                { redis_host = { type = "string", required = true, default = "host.docker.internal" } },
                { redis_port = { type = "number", required = true, default = 6379 } },
                { redis_password = { type = "string" } },
                { rpt_endpoint = { type = "string", required = true } },
                { required_permissions = { type = "string" } },
                { token_header = { type = "string", default = "Authorization" } },
            },
        },
        },
    },
}
