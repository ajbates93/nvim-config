return {
	"nvim-lua/plenary.nvim", -- lua functions that many plugins use
	"christoomey/vim-tmux-navigator", -- tmux & split window navigation

	vim.filetype.add({
		extension = {
			html = function(path, bufnr)
				if vim.fn.search("{%.*%}", "nw", 50) ~= 0 then
					return "jinja2"
				end
				return "html"
			end,
		},
	}),
}
