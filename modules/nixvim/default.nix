{ pkgs, ... }:
{
  config = {

    # Neovim nightly
    package = pkgs.neovim-unwrapped.overrideAttrs (old: {
      version = "0.10.0-dev";
      src = pkgs.fetchFromGitHub {
        owner = "neovim";
        repo = "neovim";
        rev = "a69c72063994f8e9064b6d9c9f280120423897b8";
        hash = "sha256-S24CAQvkeivCFM6tK4D10AEyjsMgE07XVgLIkrh6Ljc=";
      };
    });

    colorschemes.catppuccin = {
      enable = true;

      settings.flavour = "mocha";
    };

    opts = {
      cursorline = true;
      number = true;
      relativenumber = true;

      timeout = true;
      timeoutlen = 300;

      signcolumn = "yes";
      expandtab = true;
      shiftwidth = 2;

      undofile = true;
    };

    globals = {
      mapleader = " ";
    };

    keymaps = [
      {
        mode = "v";
        key = "<";
        action = "<gv";
        options = {
          silent = true;
        };
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "U";
        action = ":redo<CR>";
        options = {
          silent = true;
        };
      }
      {
        mode = "n";
        key = "W";
        action = "b";
        options = {
          silent = true;
        };
      }
      {
        mode = "i";
        key = "<S-Tab>";
        action = "<C-d>";
      }
    ];

    languages = {
      nix.enable = true;
      rust.enable = true;
      bash.enable = true;
      cpp.enable = true;
      go.enable = true;
      web.enable = true;
      lua.enable = true;
      python.enable = true;
      haskell.enable = true;
    };

    extraPlugins = with pkgs.vimPlugins; [
      dressing-nvim

      (pkgs.vimUtils.buildVimPlugin {
        name = "hawtkeys";
        src = pkgs.fetchFromGitHub {
          owner = "tris203";
          repo = "hawtkeys.nvim";
          rev = "ce2a3f96852a2e5cc59b780f8839a0b5a31c2878";
          hash = "sha256-NT5sGW3+aZkFoNcf5Grx3tGkIb868CPPEFOUdJooehI=";
        };
      })
    ];

    extraConfigLua = /* lua */ ''
      require("hawtkeys").setup({})
    '';

    plugins = {
      # Coding
      treesitter.enable = true;
      twilight.enable = false;
      vim-visual-multi.enable = true;
      todo-comments.enable = true;
      telescope.enable = true;
      surround = {
        # ys<motion>

        enable = true;
      };

      # LSP
      lsp.enable = true;
      lsp-format.enable = true; # Format on save
      lsp-lines.enable = true;
      cmp.enable = true;
      lspkind.enable = true;
      otter.enable = true;

      # UI
      which-key.enable = true;
      notify.enable = true;
      noice.enable = true;
      nvim-colorizer.enable = true;
      lualine.enable = true;
      indent-blankline.enable = true;
      alpha.enable = false; # TODO
      bufferline.enable = true;

      nvim-tree = {
        # <C-n> to toggle
        # e to rename
        # a to create file
        # d to delete

        enable = true;
      };

      # Mini
      mini = {
        enable = true;

        animate = true;
        comment = true;
        pairs = true;
        indentscope = true;
      };
    };
  };
}
