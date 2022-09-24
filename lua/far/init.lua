local M = {}

-- Keybindigs
local map = vim.api.nvim_set_keymap
local opts = {noremap = true, silent = true}

-- find_input and replace
-- :substitute
-- :s/find_input/replace
-- s = line, %s = whole buffer
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

M.findAndReplace = function(mode)
    
    local find = vim.call("expand", "<cword>")
    local replace = nil

    local replaceInput = Input({
        
        position = "50%",
        size = {width = 40},
        border = {
            style = "rounded",
            text = {
                top = ' Replace "'..find..'" with? ',
                top_align  = "center",
            }
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
    }, {
        prompt = "",
        on_close = function()

        end,
        on_submit = function (value)
           
            replace = value

            if(mode == "file") then
                vim.cmd("%s/"..find.."/"..replace.."/g")
                vim.cmd("match Search /"..replace.."/")
            else
                vim.cmd([[%s/\%V]]..find.."/"..replace.."/g")
                vim.cmd([[match Search /\%V]]..replace.."/")
            end

            vim.cmd('let @/ = ""')

        end
    }) 

    replaceInput:mount()

    replaceInput:on(event.BufLeave, function()
        replaceInput:unmount()
    end)

    replaceInput:map("n", "<Esc>", function()
        replaceInput:unmount()
    end, { noremap = true })

end

M.setup = function(opts)

    map("n", "<leader>frr", ":lua require'far'.findAndReplace('file')<CR>", opts)
    map("v", "<leader>fr", ":lua require'far'.findAndReplace('selection')<CR>", opts)

end

return M

