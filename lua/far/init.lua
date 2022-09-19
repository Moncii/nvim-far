local M = {}

-- Keybindigs
local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap
local opts = {noremap = true, silent = true}

-- find_input and replace
-- :substitute
-- :s/find_input/replace
-- s = line, %s = whole buffer
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

M.findText = function(mode)

    local replaceMode = mode
    local find = vim.call("expand", "<cword>")

    if(find ~= "") then

        local replaceInput = Input({
    
            position = "50%",
            size = {width = 40},

            border = {
                style = "rounded",
                text = {
                    top = '[ Replace "'..find..'" with? ]',
                    top_align = "center",
                }
            },

            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:Normal",
            },
    
        }, {

            prompt = "> ",
        -- on_close = function()
        --     print("Input Closed!")
        -- end,
            on_submit = function(value)
                if(replaceMode == "file") then
                    vim.cmd("%s/"..find.."/"..value)
                elseif(replaceMode == "line") then
                    vim.cmd("s/"..find.."/"..value)
                end

                vim.cmd('let @/ = ""')

            end,

        })

        replaceInput:map("n", "<Esc>", function()
            replaceInput:unmount()
        end, {noremap = true})

        replaceInput:mount()

        replaceInput:on(event.BufLeave, function()
            replaceInput:unmount()
        end)

    end

    print("Place cursor over the word you would like to replace.")

end

-- M.replaceText = function()

-- end

M.findAndReplace = function(mode)

    M.findText(mode)
    -- vim.cmd("%s/"..find.."/"..replace)

end

M.setup = function(opts)

    -- local bind = opts.map or "<leader>r"

    map("n", "<leader>fr", ":lua require'far'.findAndReplace('file')<CR>", opts)
    map("n", "<leader>lr", ":lua require'far'.findAndReplace('line')<CR>", opts)
    -- map("n", "<leader>fr", ":lua print'Hey!'", opts)

end

return M

