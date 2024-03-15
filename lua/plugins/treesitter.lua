return {
  "nvim-treesitter/nvim-treesitter",
  config = function(_, opts)
		-- Manually merge ensure_installed as the config function isn't merged by lazyvim
    if type(opts.ensure_installed) == "table" then
      ---@type table<string, boolean>
      local added = {}
      opts.ensure_installed = vim.tbl_filter(function(lang)
        if added[lang] then
          return false
        end
        added[lang] = true
        return true
      end, opts.ensure_installed)
    end

		-- Add support for parser_config
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    if type(opts.parser_configs) == "table" then
      for key, config in pairs(opts.parser_configs) do
        parser_config[key] = config
      end
    end

    require("nvim-treesitter.configs").setup(opts)
  end,
}
