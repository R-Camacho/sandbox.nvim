local M = {}

M.config = {}

local function clone(plugin, plugin_path)
	local plugin_repo = "https://github.com/" .. plugin
	local out = vim.fn.system({ "git", "clone", "--depth=1", plugin_repo, plugin_path })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone " .. plugin .. ":\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		return false
	end
	return true
end

M.plugins = {}

-- Clone and load plugin
function M.load(plugin)
	local config = M.config
	vim.fn.mkdir(config.install_path, "p")

	local plugin_name = plugin:match(".*/(.*)")
	local plugin_path = config.install_path .. "/" .. plugin_name

	if vim.fn.isdirectory(plugin_path) == 0 then
		vim.notify("Cloning " .. plugin .. " into sandbox...")
		local ok = clone(plugin, plugin_path)
		if not ok then
			return
		end
	end

	vim.opt.rtp:prepend(plugin_path)

	-- TODO: this does not work on all cases
	local modname = plugin_name:gsub("%.nvim$", ""):gsub("%.lua$", ""):gsub("%-", "_")

	local ok, mod = pcall(require, modname)
	if ok and type(mod.setup) == "function" then
		mod.setup()
	else
		vim.cmd("runtime! plugin/**/*.vim")
		vim.cmd("runtime! plugin/**/*.lua")
	end

	M.plugins[plugin_name] = {
		repo = plugin,
		dir = plugin_path,
		loaded = true,
	}

	vim.notify("Sandboxed plugin loaded: " .. plugin)
end

-- Clean all of the plugins installed on the sandbox
function M.clean(cmd)
    cmd = cmd or false -- called from the user command
	local config = M.config

	if vim.tbl_isempty(M.plugins) then
        if config.debug or cmd then
		    vim.notify("No sandboxed plugins to clean.")
        end
		return
	end

	M.plugins = {}
	vim.fn.delete(config.install_path, "rf")
    if config.debug or cmd then
	    vim.notify("Sandbox cleaned " .. config.install_path)
    end
end

return M
