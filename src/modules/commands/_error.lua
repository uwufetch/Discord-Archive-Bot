return function (Tokens, Message)
    local Channel =  Tokens[1].channel
    Channel:send('An error occured: '..Message)
end