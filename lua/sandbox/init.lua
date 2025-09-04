local M = {}

function M.setup(opts)
	opts = opts or {}
	local config = require("sandbox.config")
	M.config = vim.tbl_deep_extend("force", config, opts)
	vim.fn.mkdir(M.config.install_path, "p")
end

function M.try(plugin)
	-- TODO: check format - 'author/plugin-name'
	local core = require("sandbox.core")
	core.load(plugin)
end

function M.clean()
	local core = require("sandbox.core")
	core.clean()
end

function M.list()
	local plugins = require("sandbox.core").plugins
	local lines = { "Sandboxed plugins: " }

	if vim.tbl_count(plugins) == 0 then
		vim.notify("No sandboxed plugins.")
		return
	end

	for name, info in pairs(plugins) do
		table.insert(lines, string.format(" - %s (%s)", name, info.repo))
	end
	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Clean on leaving nvim
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		M.clean()
	end,
})

-- TODO: create a "Sandbox" command that shows a UI that allows adding and removing plugins

vim.api.nvim_create_user_command("SandboxTry", function(opts)
	M.try(opts.args)
end, { nargs = 1 })

vim.api.nvim_create_user_command("SandboxList", function()
	M.list()
end, { nargs = 0 })

vim.api.nvim_create_user_command("SandboxClean", function()
	M.clean()
end, { nargs = "*" })

return M
