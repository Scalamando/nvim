# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{inputs}: final: prev:
with final.pkgs.lib; let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin = src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.lastModifiedDate;
    };

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
  };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    # plugins from nixpkgs go in here.
    # https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=vimPlugins
    nvim-treesitter.withAllGrammars
    # completion
    luasnip
    friendly-snippets
    blink-cmp
    blink-compat
    SchemaStore-nvim
    # git integration plugins
    #diffview-nvim # https://github.com/sindrets/diffview.nvim/
    #neogit # https://github.com/TimUntersberger/neogit/
    gitsigns-nvim # https://github.com/lewis6991/gitsigns.nvim/
    #vim-fugitive # https://github.com/tpope/vim-fugitive/
    # ^ git integration plugins
    # UI
    snacks-nvim
    smear-cursor-nvim
    trouble-nvim
    catppuccin-nvim
    mini-icons
    mini-statusline
    noice-nvim
    render-markdown-nvim
    nvim-treesitter-context # nvim-treesitter-context
    # ^ UI
    # language support
    nvim-lspconfig
    lazydev-nvim
    conform-nvim
    typst-preview-nvim
    # ^ language support
    # navigation/editing enhancement plugins
    grug-far-nvim
    toggleterm-nvim
    neo-tree-nvim
    comment-nvim
    #vim-unimpaired # predefined ] and [ navigation keymaps | https://github.com/tpope/vim-unimpaired/
    #eyeliner-nvim # Highlights unique characters for f/F and t/T motions | https://github.com/jinh0/eyeliner.nvim
    nvim-treesitter-textobjects # https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
    nvim-ts-context-commentstring # https://github.com/joosepalviste/nvim-ts-context-commentstring/
    # ^ navigation/editing enhancement plugins
    # Useful utilities
    #nvim-unception # Prevent nested neovim sessions | nvim-unception
    mini-ai
    mini-pairs
    mini-surround
    vim-sleuth
    # ^ Useful utilities
    # libraries that other plugins depend on
    sqlite-lua
    plenary-nvim
    nui-nvim
    vim-repeat
    # ^ libraries that other plugins depend on
    # bleeding-edge plugins from flake inputs
    # (mkNvimPlugin inputs.wf-nvim "wf.nvim") # (example) keymap hints | https://github.com/Cassin01/wf.nvim
    # ^ bleeding-edge plugins from flake inputs
    which-key-nvim
  ];

  extraPackages = with pkgs; [
    # language servers
    astro-language-server
    basedpyright
    docker-compose-language-service
    dockerfile-language-server
    emmet-language-server
    gopls
    intelephense
    lua-language-server
    marksman
    nixd
    tailwindcss-language-server
    tinymist
    vtsls
    vue-language-server
    # formatters
    alejandra
    gofumpt
    gotools
    nodePackages.prettier
    php84Packages.php-codesniffer
    rubyfmt
    ruff
    ruff
    sqruff
    stylua
    vscode-langservers-extracted
    # cli dependencies
    fd
    fzf
    ripgrep
    websocat # typst preview
    # tools
    lazygit
  ];
in {
  vue-language-server = final.callPackage (inputs.nixpkgs-vue-language-server + "/pkgs/by-name/vu/vue-language-server/package.nix") {};

  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
