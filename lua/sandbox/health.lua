local M = {}

local health = vim.health
local is_win = vim.api.nvim_call_function("has", { "win32" }) == 1

local binary_dependencies = {
    {
        name = "git"
    },
}

local function have_binary_installed(package)
    local binary = package.name
    local found = vim.fn.executable(binary) == 1
    if not found or is_win then
        binary = binary .. ".exe"
        found = vim.fn.executable(binary) == 1
    end
    if found then
        local handle = io.popen(binary .. " --version")
        local version = vim.trim(handle:read("*a"))
        handle:close()
        version = version:gsub("^%s*" .. vim.pesc(binary) .. "%s*", "")
        return true, version
    end
    return false
end

M.check = function ()
    health.start("Checking binary dependencies")

    for _, dep in ipairs(binary_dependencies) do
        local installed, version = have_binary_installed(dep)
        if not installed then
            health.warn(("Sandbox will not work without %s installed."):format(dep.name))
        else
            health.ok(("{%s} `%s`"):format(dep.name, version))
        end
    end
end

return M
