local skynet = require "skynet"

skynet.start(function()
    skynet.error("start loginsvr ...")
    skynet.uniqueservice("gated", skynet.newservice("logind", "master"))
    skynet.exit()
end)