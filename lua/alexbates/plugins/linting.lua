-- Check to see if an eslint or a package.json exists within whatever project i'm working in
local eslint_config_exists = function(path)
	local eslintrc = vim.fn.glob(path .. "./.eslintrc*", 0, 1)
	if not vim.tbl_isempty(eslintrc) then
		return true
	end

	local package_json = path .. "/package.json"
	if vim.fn.filereadable(package_json) then
		-- use pcall (protected call) to check the results of vim.fn.readfile to see if we've got package.json available
		local ok, package_json_contents = pcall(vim.fn.readfile, package_json)
		if ok and package_json_contents then
			local pkg_data = vim.fn.json_decode(table.concat(package_json_contents, "\n"))
			if pkg_data and pkg_data["eslintConfig"] then
				return true
			end
		end
	end

	return false
end

return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint" },
			typescript = { "eslint" },
			javascriptreact = { "eslint" },
			typescriptreact = { "eslint" },
			svelte = { "eslint" },
			vue = { "eslint" },
			python = { "pylint" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- sepearated out the projects that make use of eslint
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.svelte", "*.vue" },
			callback = function()
				local config_path = vim.fn.getcwd()
				if eslint_config_exists(config_path) then
					lint.try_lint()
				end
			end,
		})

		-- no need for eslint check in python projects
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			pattern = { "*.py" },
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		vim.keymap.set("n", "<leader>le", function()
			vim.diagnostic.open_float({ focusable = false, scope = "cursor" })
		end, { desc = "Open hover panel for lint error" })
	end,
}
