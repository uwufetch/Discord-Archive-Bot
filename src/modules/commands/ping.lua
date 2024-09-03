return function (tokens)
    local channel =  tokens[1].channel
    channel:send("Pong!")
end