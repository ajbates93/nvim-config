-- return {
-- 	"catppuccin/nvim",
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		vim.cmd([[colorscheme catppuccin]])
-- 	end,
-- }
--
return {
	"diegoulloao/neofusion.nvim",
	priority = 1000,
	opts = ...,
	config = function()
		require("neofusion").setup({
			transparent_mode = true,
		})
		vim.cmd([[colorscheme neofusion]])
	end,
}
