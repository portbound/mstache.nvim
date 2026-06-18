local M = {}


M.defaults = {
	icon = " ",
	color = "#aa759f",
	mappings = {
		set_next = "mk",
		delete_line = "dmk"
	},
}

M.options = {}

function M.setup(user_opts)
	M.options = vim.tbl_deep_extend("force", M.defaults, user_opts or {})
end

return M
