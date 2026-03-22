local LOADSTRING =
    loadstring
    or getgenv().loadstring
    or load

local function loadModule(url,name)

    local ok,code = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        warn(name.." download failed")
        return nil
    end

    local chunk,err = LOADSTRING(code)

    if not chunk then
        warn(name.." compile error:",err)
        return nil
    end

    local success,mod = pcall(chunk)

    if not success then
        warn(name.." runtime error:",mod)
        return nil
    end

    if type(mod) ~= "table" then
        warn(name.." not module")
        return nil
    end

    print("✅ "..name.." loaded")

    return mod

end

return {
    loadModule = loadModule
}
