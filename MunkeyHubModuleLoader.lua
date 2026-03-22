local Loader = {}

Loader.Modules = {}
Loader.LoadedUrls = {}

local function safeHttp(url,name)

    local ok,code = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        warn("[MunkeyHub] "..name.." download failed")
        return nil
    end

    return code

end

local function safeRuntime(code,name)

    local ok,mod = pcall(function()
        return loadstring(code)()
    end)

    if not ok then
        warn("[MunkeyHub] "..name.." runtime error:",mod)
        return nil
    end

    return mod

end

local function validateModule(mod,name)

    if type(mod) ~= "table" then
        warn("[MunkeyHub] "..name.." not module table")
        return false
    end

    if not mod.meta then
        warn("[MunkeyHub] "..name.." missing meta")
        return false
    end

    return true

end

function Loader.load(url,name)

    if Loader.LoadedUrls[url] then
        warn("[MunkeyHub] "..name.." already loaded")
        return Loader.LoadedUrls[url]
    end

    local code = safeHttp(url,name)
    if not code then return nil end

    local mod = safeRuntime(code,name)
    if not mod then return nil end

    if not validateModule(mod,name) then
        return nil
    end

    Loader.LoadedUrls[url] = mod
    table.insert(Loader.Modules,mod)

    print("✅ "..name.." module loaded")

    return mod

end

function Loader.sort()

    table.sort(Loader.Modules,function(a,b)
        return (a.meta.priority or 100) < (b.meta.priority or 100)
    end)

end

function Loader.initAll(ctxProvider)

    for _,mod in ipairs(Loader.Modules) do

        local ctx = ctxProvider(mod)

        if mod.init then
            pcall(function()
                mod.init(ctx)
            end)
        end

    end

end

function Loader.enableAll()

    for _,mod in ipairs(Loader.Modules) do
        if mod.enable then
            pcall(mod.enable)
        end
    end

end

return Loader
