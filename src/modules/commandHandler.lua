local Commands = require('./Commands/_Commands')

local function SplitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    
    return t
end

local CommandHandler = {
    TokenizeMessage = function (Message)
        local Tokens = {}
        table.insert(Tokens, Message)

        local Content = Message.content

        table.insert(Tokens, (Content:sub(1,1)))
        Content = Content:sub(2)

        for QuotedToken in string.gmatch(Content, '"[^"]*"') do
            table.insert(Tokens, QuotedToken)
            Content = Content:gsub(QuotedToken, "")
        end

        local RemainingTokens = SplitString(Content)
        if RemainingTokens then
            for _, Token in ipairs(RemainingTokens) do
                if Token ~= "" then
                    table.insert(Tokens, Token)
                end
            end
        end

        return Tokens
    end,


    ExecuteCommand = function (Tokens)
        local FetchedCommand = Commands()[Tokens[3]] or nil

        if FetchedCommand then
            local ErrorOnMismatch = FetchedCommand.Arguments.ErrorOnMismatch
            local ExpectedArguments = FetchedCommand.Arguments.ExpectedArguments

            if ErrorOnMismatch == true then
                if (#Tokens - 3) > ExpectedArguments then
                    Commands()._error(Tokens, "Too many arguments.")
                    return
                elseif (#Tokens - 3) < ExpectedArguments then
                    Commands()._error(Tokens, "Too little arguments.")
                    return
                end
            end
            Commands()[Tokens[3]](Tokens)
        end
    end
}

return function (Message)
    local Success, Err = pcall(function ()
        local Tokens = CommandHandler.TokenizeMessage(Message)
        CommandHandler.ExecuteCommand(Tokens)
    end)
    if Err and not Success then print(Err) end
end