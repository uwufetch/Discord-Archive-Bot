local function FormatTimestamp(Timestamp)
    if string.match(Timestamp, "T") then
        local Year, Month, Day, Hour, Min, Sec = string.match(Timestamp, "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
        return string.format("%04d-%02d-%02d %02d:%02d", tonumber(Year), tonumber(Month), tonumber(Day), tonumber(Hour), tonumber(Min))
    else
        local NumericTimestamp = tonumber(Timestamp)
        if not NumericTimestamp then
            return "Invalid Timestamp"
        end

        local Date = os.date("*t", NumericTimestamp / 1000)
        return string.format("%04d-%02d-%02d %02d:%02d", Date.year, Date.month, Date.day, Date.hour, Date.min)
    end
end

return function (Tokens)
    local Channel = Tokens[1].channel
    local LastFetchedId = nil
    local FetchedMessages = {}
    local LastBatchSize = 0

    while true do
        local Messages = Channel:getMessages(100, LastFetchedId)
        
        if #Messages == 0 or #Messages == LastBatchSize then break end
        
        for Id, Message in pairs(Messages) do
            table.insert(FetchedMessages, Message)
            LastFetchedId = Id
        end

        LastBatchSize = #Messages
        print("Fetched " .. #FetchedMessages .. " messages so far...")
    end

    table.sort(FetchedMessages, function(a, b)
        return a.id < b.id
    end)

    local FileName = "archived_messages.txt"
    local File = io.open(FileName, "w")

    if not File then
        print("Error: Couldnt open file for writing.")
        return
    end

    for _, Message in ipairs(FetchedMessages) do
        local FormattedTimestamp = FormatTimestamp(Message.timestamp)
        File:write(string.format("%s %s %s: %s\n", FormattedTimestamp, Message.id, Message.author.username, Message.content))
    end

    File:close()

    print("Messages written to " .. FileName)
    local User = Tokens[1].author
    local Attachment = { FileName }

    local Success, Err = pcall(function()
        User:send({
            content = "Here are the archived messages:",
            files = Attachment
        })
    end)

    if not Success then
        print("Error sending file: " .. Err)
    end
end
