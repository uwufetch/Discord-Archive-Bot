local Commands = require('./_Commands')

local function generateDescription(Command)
    local Name = Command.Command
    local Usage = Command.Usage

    local ErrorOnMismatch = Command.Arguments.ErrorOnMismatch
    local ExpectedArguments = Command.Arguments.ExpectedArguments

    local Description = ''

    if ErrorOnMismatch == true then
        Description = string.format(
        [[**%s**:
            > **Usage:** %s
            > **Arguments:** Takes %s argument(s), will error if more/less arguments provided.
            ]], Name, Usage, ExpectedArguments)
    else
        Description = string.format(
            [[**%s**:
            > **Usage:** %s
            > **Arguments:** Takes %s argument(s), will not error if more/less arguments provided.
            ]], Name, Usage, ExpectedArguments)
    end

    return Description
end

return function (Tokens)
    local Help = ''

    for _, Command in pairs( Commands() ) do
        if string.sub(Command["Command"],1,1) ~= "_" then
            Help = Help .. generateDescription(Command) .. '\n'
        end
    end

    local Channel = Tokens[1].channel
    local SendSuccess, SendErr = pcall(function()
         Channel:send(Help)
    end)
    if not SendSuccess and SendErr then print(SendErr) end
end