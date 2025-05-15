return {
  "L3MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" }, -- optional
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load() -- loads default snippets
  end,
}

