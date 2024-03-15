return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.parser_configs = opts.parser_configs or {}

      if type(opts.parser_configs) == "table" then
        opts.parser_configs.blade = {
          install_info = {
            url = "https://github.com/EmranMR/tree-sitter-blade",
            files = { "src/parser.c" },
            branch = "main",
          },
          filetype = "blade",
        }
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        blade = { "prettier" },
      },
    },
  },
}
