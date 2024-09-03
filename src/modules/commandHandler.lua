local splitString = require('./splitString.lua')
local commands = require('./commands/commandsIndex.lua')

local commandHandler = {}


-- mental note of token table consists of the following:
--[[
    message     token[1] = message
    prefix      token[2] = $
    command     token[3] = echo
    arg1        token[4] = lol wtf
    arg2        token[5] = some
    arg3        token[6] = other
    arg4        token[7] = args
    and so on
]]
commandHandler.tokenizeMessage = function (message)
    local content = message.content
    print("tokenize")
    local tokens = {}

    table.insert(tokens, message)

    local prefix = content:sub(1, 1)
    table.insert(tokens, prefix)

    content = content:sub(2)


    for quotedToken in string.gmatch(content, '"[^"]*"') do
        local cleanToken = quotedToken:gsub('^"', ''):gsub('"$', '')
        table.insert(tokens, cleanToken)
        content = content:gsub(quotedToken, "")
    end


    -- splti remaining tokens
    local remainingTokens = splitString(content)
    if remainingTokens then
        for _, token in ipairs(remainingTokens) do
            if token ~= "" then
                table.insert(tokens, token)
            end
        end
    else
        print("Error: splitString returned nil")
    end

    return tokens
end

commandHandler.executeCommand = function (tokens)
    print("execute")
    local success, err = pcall(function ()
        print(1)
        local commandName = string.lower(tokens[3])
        local foundCommand = commands()[commandName]
        print(2)
        if foundCommand then
            if foundCommand["Arguments"][2] == true then
                print(3)
                if ((#tokens - 3 ) > foundCommand["Arguments"][1]) or ((#tokens - 3 ) < foundCommand["Arguments"][1]) then
                    commands['error']['Function'](tokens, "too many or too little arguments bud")
                    return
                end
                foundCommand.Function(tokens)
                print(4)
            else
                print(5)
                foundCommand.Function(tokens)
            end
        end
    end)

    if err and not success then print(err) end
end

commandHandler.parseMessage = function (message)
    print("parse")
    local success, err = pcall(function ()
        commandHandler.executeCommand(commandHandler.tokenizeMessage(message))
    end)
    if err and not success then print(err) end
end


return commandHandler
