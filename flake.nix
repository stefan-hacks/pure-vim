{
  description = "pure-vim — A single vimrc. Optional modules. Zero plugins. Maximum capability.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pure-vim = pkgs.stdenvNoCC.mkDerivation {
          pname = "pure-vim";
          version = "unstable-${self.shortRev or "dirty"}";
          src = self;

          installPhase = ''
            mkdir -p $out/share/pure-vim
            cp -r vimrc core ftplugin install.sh $out/share/pure-vim/
          '';

          meta = with pkgs.lib; {
            description = "Zero-plugin Vim configuration with modular language support";
            homepage = "https://github.com/stefan-hacks/pure-vim";
            license = licenses.mit;
            platforms = platforms.linux;
          };
        };
      in
      {
        packages.default = pure-vim;
        packages.pure-vim = pure-vim;

        # nix run github:stefan-hacks/pure-vim
        # Launches vim with pure-vim config for testing
        apps.default = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "pure-vim" ''
            export VIMRUNTIME=${pkgs.vim}/share/vim/vim91
            exec ${pkgs.vim}/bin/vim -u ${pure-vim}/share/pure-vim/vimrc "$@"
          '';
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            vim
            # Optional but recommended tooling
            fzf
            bat
            ripgrep
            # Language tools
            shellcheck
            shfmt
            nixfmt-rfc-style
            alejandra
            nixpkgs-fmt
            yamllint
            taplo
            ruff
            black
            go
            gopls
            rustc
            cargo
            rustfmt
            clang-tools
            nodejs
            prettier
            stylua
            jq
          ];
        };
      })
    // {
      # Home Manager module
      homeManagerModules.default = { config, lib, pkgs, ... }:
        let
          cfg = config.programs.pure-vim;
        in
        {
          options.programs.pure-vim = {
            enable = lib.mkEnableOption "pure-vim — zero-plugin Vim configuration";

            package = lib.mkOption {
              type = lib.types.package;
              default = self.packages.${pkgs.system}.default;
              description = "The pure-vim package to use.";
            };

            extraRuntimepaths = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
              example = lib.literalExpression ''
                [ "''${config.home.homeDirectory}/.vim/custom" ]
              '';
              description = "Additional directories to prepend to Vim's runtimepath.";
            };

            enableLanguageTools = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Whether to install recommended language tooling (fzf, bat, ripgrep, linters, formatters).";
            };
          };

          config = lib.mkIf cfg.enable {
            programs.vim = {
              enable = true;
              extraConfig = ''
                " pure-vim — injected by home-manager
                let g:pure_vim_root = '${cfg.package}/share/pure-vim'
                source ${cfg.package}/share/pure-vim/vimrc
              '';
            };

            home.packages = lib.mkIf cfg.enableLanguageTools (with pkgs; [
              fzf
              bat
              ripgrep
              # Shell
              shellcheck
              shfmt
              # Nix
              nixfmt-rfc-style
              alejandra
              nixpkgs-fmt
              # YAML / Ansible
              yamllint
              # TOML
              taplo
              # Python
              ruff
              black
              # Go
              go
              gopls
              # Rust
              rustfmt
              # C / C++
              clang-tools
              # JS / TS
              nodejs
              prettier
              # Lua
              stylua
              # JSON
              jq
            ]);

            # Symlink core/ and ftplugin/ so the loader can find them
            home.file.".vim/core" = {
              source = "${cfg.package}/share/pure-vim/core";
              recursive = true;
            };
            home.file.".vim/ftplugin" = {
              source = "${cfg.package}/share/pure-vim/ftplugin";
              recursive = true;
            };
          };
        };
    };
}
