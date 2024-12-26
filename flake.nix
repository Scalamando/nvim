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
      url = "github:folke/snacks.nvim";
      flake = false;
    };
  };

  outputs = {
    self,
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

    categoryDefinitions = {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkNvimPlugin,
      ...
    } @ packageDef: {
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
          lua-language-server
          nixd
          vtsls
          vue-language-server
          # formatters
          alejandra
          just
          nodePackages.prettier
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
          snacks-nvim
        ];
      };

      optionalPlugins = {
        gitPlugins = with pkgs.neovimPlugins; [];
        general = with pkgs.vimPlugins; [];
      };

      sharedLibraries = {
        general = with pkgs; [];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
        # test = {
        #   CATTESTVAR = "It worked!";
        # };
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
        # test = [
        #   '' --set CATTESTVAR2 "It worked again!"''
        # ];
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      extraPython3Packages = {
        test = _: [];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        test = [(_: [])];
      };
    };

    # And then build a package with specific categories from above here:
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      nvim = {pkgs, ...}: {
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
