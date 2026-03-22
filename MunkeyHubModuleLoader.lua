local LOADSTRING =
    loadstring
    or (getgenv and getgenv().loadstring)
    or load

local function safeGet(url,name)

    local ok,res = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok or not res or #res < 5 then
        warn("❌ "..name.." download failed")
        return nil
    end

    return res
end

local function compile(code,name)

    local chunk,err = LOADSTRING(code)

    if not chunk then
        warn("❌ "..name.." compile error:",err)
        return nil
    end

    return chunk
end

local function run(chunk,name)

    local ok,mod = pcall(chunk)

    if not ok then
        warn("❌ "..name.." runtime error:",mod)
        return nil
    end

    if type(mod) ~= "table" then
        warn("❌ "..name.." did not return module table")
        return nil
    end

    mod.meta = mod.meta or {}
    mod.meta.name = mod.meta.name or name

    print("✅ "..name.." module ready")

    return mod
end

local function loadModule(url,name)

    if not url or not name then
        warn("❌ loadModule missing args")
        return nil
    end

    local code = safeGet(url,name)
    if not code then return nil end

    local chunk = compile(code,name)
    if not chunk then return nil end

    return run(chunk,name)
end

return {
    loadModule = loadModule
}
