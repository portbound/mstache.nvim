# Tacks Nvim 
Tacks was designed to make working with marks in neovim more ergonomic for me to use. There are a lot of other plugins that do the same thing, but they all kind of just did too much for what I needed. 

I just wanted an ergonomic way to temporarily pin (or tack) hot parts of my code and interface with them via a picker.  

- Only uses global marks from A-Z
- Adds a gutter icon to show what lines have active mark(s)
- add/remove a mark using simple keybinds

<img width="1914" height="929" alt="image" src="https://github.com/user-attachments/assets/14c5a26b-342b-43fc-b25c-0079cd90d87d" />
<img width="1914" height="1088" alt="image" src="https://github.com/user-attachments/assets/8478a9e7-aab6-4d99-8555-0828439d423d" />

## Installation 
Using vim.pack 
```lua
vim.pack.add({ "https://github.com/portbound/tacks.nvim" })
require("tacks").setup()
```

## Configuration 
Tacks does not require any config. Here are the defaults: 
```lua
defaults = {
	icon = " ", -- the default icon is a pin
	color = "#aa759f",
	mappings = {
		set_next = "mk",
		delete_line = "dmk"
	},
}
```

## Example Setup 
Here is an example setup using FzfLua, my picker of choice, with Tacks:
```lua
vim.pack.add({
	"https://github.com/ibhagwan/fzf-lua",
	"https://github.com/portbound/tacks.nvim"
 })
require("tacks").setup()
local fz = require("fzf-lua")
fz.setup({
	marks = {
		marks = "^%a$" -- optional, omit special marks from the picker 
	}
})

vim.keymap.set("n", "<leader>sm", function()
	fz.marks()
end, { desc = "search marks" })
```
