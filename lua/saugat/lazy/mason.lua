return {
    "mason-org/mason.nvim",
    config = function()
        local mason = require("mason")
        mason.setup({
            max_concurrent_installers = 8,
            log_level = vim.log.levels.INFO,
        })
    end

}
