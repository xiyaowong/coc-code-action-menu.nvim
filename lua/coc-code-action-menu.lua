local M = {}

local CocActionAsync = vim.fn.CocActionAsync

local actions = {}

local function open_code_action_menu()
	require("code_action_menu").open_code_action_menu()
end

-- code_action_menu/lsp_objects/actions/code_action.lua
do
	require("code_action_menu.lsp_objects.actions.code_action").execute = function(self)
		CocActionAsync("doCodeAction", self.server_data)
	end
end

-- code_action_menu/lsp_objects/actions/command.lua
do
	require("code_action_menu.lsp_objects.actions.command").execute = function(self)
		CocActionAsync("doCodeAction", self.server_data)
	end
end

-- code_action_menu/utility_functions/actions.lua
do
	require("code_action_menu.utility_functions.actions").request_actions_from_all_servers = function()
		return actions
	end
end

function _G.open_coc_code_action_menu(mode)
	if vim.g.coc_service_initialized ~= 1 then
		print("Coc is not ready!")
		return
	end
	CocActionAsync("codeActions", mode or "cursor", function(err, res)
		if err == vim.NIL then
			local CodeAction = require("code_action_menu.lsp_objects.actions.code_action")
			local Command = require("code_action_menu.lsp_objects.actions.command")

			actions = {}
			for _, data in ipairs(res) do
				local action
				if type(data.edit) == "table" or type(data.command) == "table" then
					action = CodeAction:new(data)
				else
					action = Command:new(data)
				end
				table.insert(actions, action)
			end

			open_code_action_menu()
		end
	end)
end

function M.override_keymaps()
	vim.cmd([[
    vnoremap <Plug>(coc-codeaction-selected)   <CMD>call luaeval("open_coc_code_action_menu(_A)", visualmode())<CR>
    nnoremap <Plug>(coc-codeaction-selected)   <CMD>set  operatorfunc=v:lua.open_coc_code_action_menu<CR>g@
    nnoremap <Plug>(coc-codeaction)            <CMD>lua  open_coc_code_action_menu('')<CR>
    nnoremap <Plug>(coc-codeaction-line)       <CMD>lua  open_coc_code_action_menu('line')<CR>
    nnoremap <Plug>(coc-codeaction-cursor)     <CMD>lua  open_coc_code_action_menu('cursor')<CR>
  ]])
end

do
	vim.cmd([[ command! CodeActionMenu lua open_coc_code_action_menu() ]])

	if vim.g.did_coc_loaded == 1 then
		M.override_keymaps()
	else
		vim.cmd([[autocmd User CocNvimInit ++once lua require'coc-code-action-menu'.override_keymaps()]])
	end
end

return M
