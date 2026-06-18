local M = {}
local config = require("tacks.config")

local function update_global_mark_signs()
	local bufnr = vim.api.nvim_get_current_buf()
	vim.fn.sign_unplace("GlobalMarkSignsGroup", { buffer = bufnr })

	local marks = vim.fn.getmarklist()
	for _, mark_info in ipairs(marks) do
		local name = mark_info.mark:sub(2, 2)
		if name:match("[A-Z]") and mark_info.pos[1] == bufnr then
			local lnum = mark_info.pos[2]

			vim.fn.sign_place(
				0,
				"GlobalMarkSignsGroup",
				"GlobalMarkSign",
				bufnr,
				{ lnum = lnum, priority = 10 }
			)
		end
	end
end

local global_marks_group = vim.api.nvim_create_augroup("GlobalMarkSigns", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	group = global_marks_group,
	callback = update_global_mark_signs,
})

function M.set_next_mark()
	local available_marks = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	local placed_marks = {}

	for _, mark_info in ipairs(vim.fn.getmarklist()) do
		local name = mark_info.mark:sub(2, 2)
		if name:match("[A-Z]") then
			placed_marks[name] = true
		end
	end

	local next_mark = nil
	for i = 1, #available_marks do
		local char = available_marks:sub(i, i)
		if not placed_marks[char] then
			next_mark = char
			break
		end
	end

	if next_mark then
		vim.cmd("normal! m" .. next_mark)
		update_global_mark_signs()
	else
		vim.notify("All global marks (A-Z) are in use.", vim.log.levels.WARN)
	end
end

function M.delete_line_marks()
	local bufnr = vim.api.nvim_get_current_buf()
	local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
	local marks = vim.fn.getmarklist()
	local deleted_any = false

	for _, mark_info in ipairs(marks) do
		local name = mark_info.mark:sub(2, 2)
		if name:match("[A-Z]") and mark_info.pos[1] == bufnr and mark_info.pos[2] == cursor_row then
			vim.cmd("delmarks " .. name)
			deleted_any = true
		end
	end

	if deleted_any then
		if type(update_global_mark_signs) == "function" then
			update_global_mark_signs()
		end
	else
		vim.notify("No global marks found on this line.", vim.log.levels.WARN)
	end
end

function M.setup(opts)
	config.setup(opts)
	local cfg = config.options

	vim.api.nvim_set_hl(0, "GlobalMarkSign", { fg = cfg.color })

	vim.fn.sign_define("GlobalMarkSign", {
		text = cfg.icon,
		texthl = "GlobalMarkSign",
		linehl = "",
		numhl = ""
	})

	local group = vim.api.nvim_create_augroup("GlobalMarkSigns", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
		group = group,
		callback = update_global_mark_signs,
	})

	if cfg.mappings then
		if cfg.mappings.set_next then
			vim.keymap.set("n", cfg.mappings.set_next, M.set_next_mark,
				{ desc = "Set next available global mark" })
		end
		if cfg.mappings.delete_line then
			vim.keymap.set("n", cfg.mappings.delete_line, M.delete_line_marks,
				{ desc = "Delete global marks on line" })
		end
	end
end

return M
