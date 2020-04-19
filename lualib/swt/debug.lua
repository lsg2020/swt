local skynet    = require "skynet"
local debug     = require "skynet.debug"
local inject    = require "skynet.inject"

local function debug_run(source, filename, ...)
    local args = table.pack(...)
    local ok, output = inject(skynet, source, filename, args, skynet.dispatch_message, skynet.register_protocol)
    skynet.ret(skynet.pack(ok, table.concat(output, "\n")))
end
debug.reg_debugcmd("SWT_RUN", debug_run)
