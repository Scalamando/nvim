{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    "plugins-obsidian-nvim" = {
      url = "github:obsidian-nvim/obsidian.nvim";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    nixCats,
    ...
  } @ inputs: let
    inherit (nixCats) utils;
    luaPath = "${./.}";
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    extra_pkg_config = {
      allowUnfree = true;
    };

    dependencyOverlays = [
      (utils.standardPluginOverlay inputs)
    ];

    categoryDefinitions = {pkgs, ...}: {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          fd
          fzf
          nix-doc
          ripgrep
          stdenv.cc.cc
          universal-ctags
          xclip
          # lsps
          gopls
          intelephense
          lua-language-server
          marksman
          nixd
          tailwindcss-language-server
          tinymist
          vtsls
          vue-language-server
          websocat
          # formatters and linters
          alejandra
          clang-tools
          gofumpt
          gomodifytags
          gotools
          impl
          just
          nodejs_20
          nodePackages.prettier
          vscode-langservers-extracted
          php84Packages.php-codesniffer
          php84Packages.php-cs-fixer
          rubyfmt
          stylua
          # tools
          lazygit
          # for snacks.image
          imagemagick
          mermaid-cli
        ];
      };

      startupPlugins = {
        general = with pkgs.vimPlugins; [
          blink-cmp
          blink-compat
          catppuccin-nvim
          codecompanion-nvim
          conform-nvim
          friendly-snippets
          fugitive
          gitsigns-nvim
          grug-far-nvim
          lazy-nvim
          lazydev-nvim
          luasnip
          markdown-preview-nvim
          mini-ai
          mini-icons
          mini-nvim
          mini-pairs
          mini-statusline
          mini-surround
          neo-tree-nvim
          noice-nvim
          nui-nvim
          nvim-lint
          nvim-lspconfig
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          nvim-ts-autotag
          nvim-web-devicons
          outline-nvim
          plenary-nvim
          refactoring-nvim
          render-markdown-nvim
          snacks-nvim
          toggleterm-nvim
          trouble-nvim
          ts-comments-nvim
          typst-preview-nvim
          vim-sleuth
          which-key-nvim
        ];
        gitPlugins = with pkgs.neovimPlugins; [
          {
            name = "obsidian.nvim";
            plugin = obsidian-nvim;
          }
        ];
      };

      environmentVariables = {};

      extraWrapperArgs = {};

      extraPython3Packages = {};

      extraLuaPackages = {};
    };

    packageDefinitions = {
      nvim = {...}: {
        settings = {
          wrapRc = true;
          aliases = ["vim"];
        };
        categories = {
          general = true;
          gitPlugins = true;
          customPlugins = true;
        };
      };
    };
    defaultPackageName = "nvim";
  in
    # see :help nixCats.flake.outputs.exports
    forEachSystem (system: let
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions;
      defaultPackage = nixCatsBuilder defaultPackageName;
      pkgs = import nixpkgs {inherit system;};
    in {
      packages = utils.mkAllWithDefault defaultPackage;
      devShells = {
        default = pkgs.mkShell {
          name = defaultPackageName;
          packages = [defaultPackage];
          inputsFrom = [];
          shellHook = '''';
        };
      };
    })
    // (let
      # we also export a nixos module to allow reconfiguration from configuration.nix
      nixosModule = utils.mkNixosModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
      # and the same for home manager
      homeModule = utils.mkHomeModules {
        inherit
          defaultPackageName
          dependencyOverlays
          luaPath
          categoryDefinitions
          packageDefinitions
          extra_pkg_config
          nixpkgs
          ;
      };
    in {
      overlays =
        utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        }
        categoryDefinitions
        packageDefinitions
        defaultPackageName;

      nixosModules.default = nixosModule;
      homeModules.default = homeModule;

      inherit utils nixosModule homeModule;
      inherit (utils) templates;
    });
}
