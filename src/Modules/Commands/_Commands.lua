local Commands = {}

Commands.help = {
    Command = 'help',
    Usage = 'Outputs a message detailing the usage of commands.',
    Arguments = {
        ErrorOnMismatch = false,
        ExpectedArguments = 0
    },
}

Commands._error = {
    Command = '_error',
    Usage = 'To output an error.',
    Arguments = {
        ErrorOnMismatch = true,
        ExpectedArguments = 1
    },
}

Commands.ping = {
    Command = 'ping',
    Usage = 'To say pong.',
    Arguments = {
        ErrorOnMismatch = true,
        ExpectedArguments = 0
    },
}

Commands.archive = {
    Command = 'archive',
    Usage = 'Archive a whole text channel.',
    Arguments = {
        ErrorOnMismatch = false,
        ExpectedArguments = 0
    },
}

return function ()
    for _, Command in pairs(Commands) do
        local M = {
            __call = function (Self, ...)
                local Function = require('./'..Command.Command)
                Function(...)
            end
        }
        setmetatable(Command, M)
    end
    return Commands
end