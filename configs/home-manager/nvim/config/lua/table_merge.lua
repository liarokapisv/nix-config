function table_merge(into, from)
    for k,v in pairs(from) do
        if type(v) == "table" then
            if type(into[k] or false) == "table" then
                into[k] = tableMerge(into[k] or {}, from[k] or {})
            else
                into[k] = v
            end
        else
            into[k] = v
        end
    end
    return into
end
