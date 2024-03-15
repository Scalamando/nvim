return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.parser_configs = opts.parser_configs or {}

    if type(opts.parser_configs) == "table" then
      opts.parser_configs.bruno = {
        install_info = {
          url = "https://github.com/scalamando/tree-sitter-bruno",
          files = { "src/parser.c", "src/scanner.c" },
					branch = "main",
        },
        filetype = "bruno",
      }
    end
  end,
}
