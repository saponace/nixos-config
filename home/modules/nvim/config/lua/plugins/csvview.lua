return {
	{
		"hat0uma/csvview.nvim",
		ft = { "csv" }, -- load only for csv files
		config = function()
			require("csvview").setup({
				parser = {
					comments = { "#" },
				},
				view = {
					display_mode = "border",
				},
			})
		end,
	},
}
