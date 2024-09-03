return function (Tokens)
    local Channel =  Tokens[1].channel
    Channel:send("Pong!")
end