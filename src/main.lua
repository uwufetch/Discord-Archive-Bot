-- Modules, Libraries & Dependencies
local Discordia = require('discordia')
local Settings = require('../Settings')
local CommandHandler = require('./modules/CommandHandler')


-- Variables, basic checks, and setting up libraries
local Client = Discordia.Client()
if not Settings.BotToken then
    error('No BotToken provided.')
    return
end


-- Discordia Client Handling
Client:on('ready', function()
    print('Bot logged in as ' .. Client.user.username)
end)

Client:on('messageCreate', function(Message)
    if not Message.author.bot then
        if Message.content:sub(1, 1) == Settings.Prefix then
            CommandHandler(Message)
        end
    end
end)

-- Run the Bot
Client:run('Bot ' .. Settings.BotToken)
return Client -- Incase any commands or modules need to access the client object