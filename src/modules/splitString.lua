return function (inputstr, sep)
    if sep == nil then
        sep = "%s" -- def speerator is whitespace
    end
    
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    
    return t
end
