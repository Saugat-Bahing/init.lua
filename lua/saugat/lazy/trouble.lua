return {
    {
        "floke/trouble.nvim",
        url = "https://github.com/folke/trouble.nvim.git",
        config = function()
            local trouble = require("trouble")
            trouble.setup({
                icons = false,
            })

            vim.keymap.set("n", "<leader>tt", function()
                trouble.toggle()
            end)

            vim.keymap.set("n", "<leader>[t", function()
                trouble.next({skip_groups = true, jump = true})
            end)

            vim.keymap.set("n", "<leader>]t", function()
                trouble.previous({skip_groups = true, jump = true})
            end)

        end
    },
}
