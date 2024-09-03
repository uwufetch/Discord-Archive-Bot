local commands = require('./commandsIndex.lua')

local function generateBlockOfText(command)
    print("Generating block of text")
    local name = command["Command"]
    local usage = command["Usage"]
    local args = command["Arguments"]

    local block = ''
    if args[2] == false then
        block = '**' .. name .. ':**\nUsage:\n> ' .. usage .. '\nArguments:\n> Takes ' .. tostring(args[1]) .. ' argument(s), will not error if more/less arguments provided.'
    elseif args[2] == true then
        block = '**' .. name .. ':**\nUsage:\n> ' .. usage .. '\nArguments:\n> Takes ' .. tostring(args[1]) .. ' argument(s), will error if more/less arguments provided.'
    else
        block = '**' .. name .. ':**\nUsage:\n> ' .. usage .. '\nArguments:\n> Takes ' .. tostring(args[1]) .. ' argument(s).'
    end

    return block
end

return function (tokens)
    local help = ''
    print(#commands())
    for index, command in pairs(commands()) do
        if string.sub(command["Command"],1,1) ~= "_" then
            help = help .. generateBlockOfText(command) .. '\n\n'
        end
    end

    local channel = tokens[1].channel
    local sendSuccess, sendErr = pcall(function()
         channel:send(help)
    end)
    if not sendSuccess and sendErr then print(sendErr) end
end

