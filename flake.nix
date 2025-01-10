{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    "plugins-doing-nvim" = {
      url = "github:Hashino/doing.nvim";
      flake = false;
    };
    "plugins-snacks-nvim" = {
      url = "github:folke/snacks.nvim?ref=refs/tags/stable";
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
      # allowUnfree = true;
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
          nixd
          tailwindcss-language-server
          vtsls
          vue-language-server
          # formatters and linters
          alejandra
          gofumpt
          gomodifytags
          gotools
          impl
          just
          nodePackages.prettier
          nodePackages.eslint
          php84Packages.php-codesniffer
          php84Packages.php-cs-fixer
          rubyfmt
          stylua
        ];
      };

      startupPlugins = {
        general = with pkgs.vimPlugins; [
          blink-cmp
          catppuccin-nvim
          conform-nvim
          fidget-nvim
          friendly-snippets
          fugitive
          gitsigns-nvim
          lazy-nvim
          lazydev-nvim
          lazygit-nvim
          luasnip
          mini-ai
          mini-nvim
          mini-pairs
          mini-statusline
          mini-icons
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
          plenary-nvim
          snacks-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          telescope-ui-select-nvim
          trouble-nvim
          ts-comments-nvim
          vim-sleuth
          vim-sleuth
          which-key-nvim
        ];
        gitPlugins = with pkgs.neovimPlugins; [
          doing-nvim
          (snacks-nvim.overrideAttrs
            {
              nvimRequireCheck = "snacks";
            })
        ];
      };

      environmentVariables = {};

      extraWrapperArgs = {};

      extraPython3Packages = {};

      extraLuaPackages = {
      };
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
          neonixdev = true;
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
          shellHook = ''
          '';
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
