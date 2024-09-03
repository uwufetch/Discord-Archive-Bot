--libraries, modules, settings
local discordia = require('discordia')
local settings = require('../settings.lua')
local commandHandler = require('./modules/commandHandler.lua')

--after-loading variables and whatnot
local client = discordia.Client()
if not settings.BotToken then error('No BotToken provided.') return end

-- discord client handling


client:on('ready', function()
    print('Logged in as ' .. client.user.username)
end)

client:on('messageCreate', function(message)
    if message.author.bot then return end
    print(message.author, message.content)
    print(message.content)
    
    if message.content:sub(1, 1) == settings['Prefix'] then
        print("parsing!!")
        commandHandler.parseMessage(message)
    else
        print("no prefix")
    end
end)

client:on('slashCommand', function(interaction)
    local message = {}
    message.content = '$'..interaction.options.text

    local channelId = interaction.channel_id
    local channel = client:getChannel(channelId)
    message.channel = channel

    if message.content:sub(1, 1) == settings['Prefix'] then
        print("parsing slash")
        commandHandler.parseMessage(message)
    else
        print("no prefix slash")
    end
end)


client:run('Bot ' .. settings['BotToken'])
return client