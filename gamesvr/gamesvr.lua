local skynet = require "skynet"
local socketdriver = require "socketdriver"
local crypt = require "crypt"
local cjson = require "cjson"

local gamedb = assert(tonumber(...))
skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,
    pack = function(m) tostring(m) end,
    unpack = skynet.tostring
}

local users = {}  -- usrid --> user info: {usrid, clisession, svrid}

local MSG = {}

skynet.start(function()
    skynet.dispatch("client", function(session, source, clisession, msg, ...)
        local ok, msgdata = pcall(cjson.decode, msg)
        if ok then
            local m = msgdata.__m
            if m and type(m) == "string" then
                local f = MSG[m]
                if not f then skynet.error("Unregisted client message: "..m) else f(clisession, msgdata) end
            end
        else
            skynet.error("Parse client message error. fd: "..clisession.fd)
        end
    end)
end)