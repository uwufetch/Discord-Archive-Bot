-- Arguments[1] is amount of arguments it takes, Arguments[2] is whether the command will fail if provided arguments ~= Arguments[1]
return function ()
    return {
        ['help'] = {
            ["Command"] = 'help',
            ["Usage"] = "Outputs a message detailing the usage of commands.",
            ["Arguments"] = {0,false},
            ["Function"] = require('./help.lua')
        },

        ['_error'] = {
            ["Command"] = '_error',
            ["Usage"] = "To output an error.",
            ["Arguments"] = {0,false},
            ["Function"] = require('./error.lua')
        },

        ['ping'] = {
            ["Command"] = 'ping',
            ["Usage"] = "Say pong.",
            ["Arguments"] = {0,false},
            ["Function"] = require('./ping.lua')
        },

        ['archive'] = {
            ["Command"] = 'archive',
            ["Usage"] = "Archive a whole text channel.",
            ["Arguments"] = {0,false},
            ["Function"] = require('./archive.lua')
        }
    }
end