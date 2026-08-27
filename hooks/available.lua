--- Return all available versions provided by this plugin
--- @param ctx table Empty table used as context, for future extension
--- @return table Descriptions of available versions and accompanying tool descriptions

local http = require("http")
local URL = "https://releases.rs/"

function PLUGIN:Available(ctx)

    --- fetch from https://releases.rs/
    local resp, err = http.get({
        url = URL
    })
    if err ~= nil then
        error("Failed to fetch rust release info: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to fetch rust release info: status_code => " .. resp.status_code)
    end

    --- Current stable release, from the "Rust Versions" section:
    ---   Stable: <a href=/docs/1.98.0>1.98.0</a>
    local stable = resp.body:match("Stable:%s*<a href=/docs/([%d%.]+)>")
    if stable == nil then
        error("Failed to parse stable rust version from " .. URL)
    end

    --- Sidebar links look like: <a href=/docs/1.98.0/>1.98.0</a>
    --- The list is newest-first but includes beta/nightly above stable;
    --- skip everything until the stable release so pre-releases (which
    --- have no tarball on static.rust-lang.org/dist) are never offered.
    local versions = {}
    local found_stable = false
    for version in resp.body:gmatch("/docs/([%w%.%-]+)/") do
        if version == stable then
            found_stable = true
        end
        if found_stable and version:match("^1%.%d+%.%d+$") then
            local note = (version == stable) and "latest" or ""
            table.insert(versions, {version = version, note = note, addition = {}})
        end
    end

    if #versions == 0 then
        error("Failed to parse rust versions from " .. URL)
    end

    return versions
end
