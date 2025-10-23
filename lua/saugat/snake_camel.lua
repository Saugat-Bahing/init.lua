-- camelCase / PascalCase → snake_case
local function camel_to_snake(str)
	local s = str
	-- Split boundaries between ALLCAPS -> Capital+lower (e.g., HTTPRequest -> HTTP_Request)
	s = s:gsub("([A-Z]+)([A-Z][a-z])", "%1_%2")
	-- Split boundaries between lower/digit -> Upper (e.g., myVar -> my_Var, v2X -> v2_X)
	s = s:gsub("([a-z%d])([A-Z])", "%1_%2")
	-- Split boundaries between letters and digits both ways (e.g., var1 -> var_1, v2alpha -> v_2alpha)
	s = s:gsub("([A-Za-z])(%d)", "%1_%2")
	s = s:gsub("(%d)([A-Za-z])", "%1_%2")
	-- Lowercase everything
	s = s:lower()
	return s
end

-- snake_case → camelCase (removes underscore; uppercases letter; keeps digits as-is)
local function snake_to_camel(str)
	return str:gsub("_(%w)", function(c)
		if c:match("%d") then
			return c -- underscore before digit: drop underscore, keep digit
		else
			return c:upper() -- underscore before letter: drop underscore, uppercase letter
		end
	end)
end

-- Toggle word under cursor
local function toggle_camel_snake()
	local word = vim.fn.expand("<cword>")
	local as_snake = camel_to_snake(word)

	if word ~= as_snake then
		-- It was camel/Pascal (or mixed) → snake_case
		vim.cmd("normal! ciw" .. as_snake)
	else
		-- It was snake_case → camelCase
		vim.cmd("normal! ciw" .. snake_to_camel(word))
	end
end

-- Keybinding: <leader>sc
vim.keymap.set("n", "<leader>sc", toggle_camel_snake, { noremap = true, silent = true })
