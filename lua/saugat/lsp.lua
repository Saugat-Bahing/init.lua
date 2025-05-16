-- Lua {{{
vim.lsp.config.lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".git", vim.uv.cwd() },
    settings = {
        Lua = {
            telemetry = {
                enable = false,
            },
            diagnostics = {
                globals = { "vim" },
            }
        },
    },
}
vim.lsp.enable("lua_ls")
--}}}

-- TSServer {{{
vim.lsp.config.ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },

    init_options = {
        hostInfo = "neovim",
    },
}
-- }}}

-- CSSls {{{
vim.lsp.config.cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss" },
    root_markers = { "package.json", ".git" },
    init_options = {
        provideFormatter = true,
    },
}
-- }}}

-- HTML {{{
vim.lsp.config.htmlls = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    root_markers = { "package.json" },

    init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
            css = true,
            javascript = true,
        },
        provideFormatter = true,
    },
}
-- }}}
vim.lsp.enable({ "ts_ls", "cssls", "htmlls" })

-- Ruby LSP (Shopify) {{{
vim.lsp.config.ruby_ls = {
    cmd = { "ruby-lsp" },
    filetypes = { "ruby" },
    root_markers = { "Gemfile", ".git", "." },

    init_options = {
        enabledFeatures = {
            documentHighlights = true,
            documentSymbols = true,
            foldingRanges = true,
            formatting = true,
            hover = true,
            inlayHint = true,
            diagnostics = true,
            codeActions = true,
            completion = true,
            definition = true,
            semanticHighlighting = true,
        },
    },
}
vim.lsp.enable({ "ruby_ls" })

-- }}}


vim.diagnostic.config({
    float = {
        focousable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

-- Start, Stop, Restart, Log commands {{{
vim.api.nvim_create_user_command("LspStart", function()
    vim.cmd.e()
end, { desc = "Starts LSP clients in the current buffer" })

vim.api.nvim_create_user_command("LspStop", function(opts)
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if opts.args == "" or opts.args == client.name then
            client:stop(true)
            vim.notify(client.name .. ": stopped")
        end
    end
end, {
    desc = "Stop all LSP clients or a specific client attached to the current buffer.",
    nargs = "?",
    complete = function(_, _, _)
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local client_names = {}
        for _, client in ipairs(clients) do
            table.insert(client_names, client.name)
        end
        return client_names
    end,
})

vim.api.nvim_create_user_command("LspRestart", function()
    local detach_clients = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        client:stop(true)
        if vim.tbl_count(client.attached_buffers) > 0 then
            detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
        end
    end
    local timer = vim.uv.new_timer()
    if not timer then
        return vim.notify("Servers are stopped but havent been restarted")
    end
    timer:start(
        100,
        50,
        vim.schedule_wrap(function()
            for name, client in pairs(detach_clients) do
                local client_id = vim.lsp.start(client[1].config, { attach = false })
                if client_id then
                    for _, buf in ipairs(client[2]) do
                        vim.lsp.buf_attach_client(buf, client_id)
                    end
                    vim.notify(name .. ": restarted")
                end
                detach_clients[name] = nil
            end
            if next(detach_clients) == nil and not timer:is_closing() then
                timer:close()
            end
        end)
    )
end, {
    desc = "Restart all the language client(s) attached to the current buffer",
})

vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd.vsplit(vim.lsp.log.get_filename())
end, {
    desc = "Get all the lsp logs",
})

vim.api.nvim_create_user_command("LspInfo", function()
    vim.cmd("silent checkhealth vim.lsp")
end, {
    desc = "Get all the information about all LSP attached",
})
-- }}}
