local commands = {}

-- Arguments[1] is amount of arguments it takes, Arguments[2] is whether the command will fail if provided arguments ~= Arguments[1]

commands.error = {
    ["Command"] = 'error',
    ["Usage"] = "Replies with an error message.",
    ["Arguments"] = {0,false},
    ["Function"] = require('./error.lua')
}

commands.ping = {
    ["Command"] = 'ping',
    ["Usage"] = "Say pong.",
    ["Arguments"] = {0,false},
    ["Function"] = require('./ping.lua')
}

commands.ping2 = {
    ["Command"] = 'ping2',
    ["Usage"] = "Say pong.",
    ["Arguments"] = {0,true},
    ["Function"] = require('./ping.lua')
}

return commands