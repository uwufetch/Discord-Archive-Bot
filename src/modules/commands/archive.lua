local function formatTimestamp(timestamp)
    if string.match(timestamp, "T") then
        local year, month, day, hour, min, sec = string.match(timestamp, "(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
        return string.format("%04d-%02d-%02d %02d:%02d", tonumber(year), tonumber(month), tonumber(day), tonumber(hour), tonumber(min))
    else
        local numericTimestamp = tonumber(timestamp)
        if not numericTimestamp then
            print("Error: Timestamp is not a valid number.")
            return "Invalid Timestamp"
        end

        local date = os.date("*t", numericTimestamp / 1000)
        return string.format("%04d-%02d-%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
    end
end

return function (tokens)
    print("Archiving...")

    local channel = tokens[1].channel
    local lastFetchedId = nil
    local fetchedMessages = {}
    local lastBatchSize = 0

    while true do
        local messages = channel:getMessages(100, lastFetchedId)
        
        if #messages == 0 or #messages == lastBatchSize then break end
        
        for id, message in pairs(messages) do
            table.insert(fetchedMessages, message)
            lastFetchedId = id
        end

        lastBatchSize = #messages
        print("Fetched " .. #fetchedMessages .. " messages so far...")
    end

    table.sort(fetchedMessages, function(a, b)
        return a.id < b.id
    end)

    local fileName = "archived_messages.txt"
    local file = io.open(fileName, "w")

    if not file then
        print("Error: Couldnt open file for writing.")
        return
    end

    for _, message in ipairs(fetchedMessages) do
        local formattedTimestamp = formatTimestamp(message.timestamp)
        file:write(string.format("%s %s %s: %s\n", formattedTimestamp, message.id, message.author.username, message.content))
    end

    file:close()

    print("Messages written to " .. fileName)
    local user = tokens[1].author
    local attachment = { fileName }

    local success, err = pcall(function()
        user:send({
            content = "Here are the archived messages:",
            files = attachment
        })
    end)

    if not success then
        print("Error sending file: " .. err)
    end
end
