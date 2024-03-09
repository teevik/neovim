{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.plugins.cmp;
in
{
  config = mkIf cfg.enable {
    options = {
      completeopt = "menu,menuone,noinsert";
    };

    extraConfigLua = /* lua */ ''
      local which_key = require("which-key")

      local is_toggled = true

      local toggle = function()
        is_toggled = not is_toggled

        if is_toggled then
          vim.cmd('Copilot enable')
        else
          vim.cmd('Copilot disable')
        end
      end

      require('which-key').register({
        t = {
          name = "Toggle",
          c = { toggle, "Toggle Copilot" },
        },
      }, { mode = "n", prefix = "<leader>", silent = true })
    '';

    keymaps = [
      {
        mode = "n";
        key = "<leader>tc";
        action = "<cmd>:lua require('copilot.suggestion').toggle_auto_trigger()<cr>";
        options = {
          silent = true;
          desc = "Toggle Copilot";
        };
      }
    ];

    plugins = {
      luasnip.enable = true;

      copilot-lua = {
        enable = true;

        suggestion = {
          enabled = false;
          autoTrigger = false;
        };
        panel = {
          enabled = false;
        };

        # filetypes = {
        #   # Disable by default
        #   "*" = false;
        # };
      };

      cmp.settings = {
        snippet.expand = "luasnip";

        mappingPresets = [ "insert" ];

        experimental = {
          ghost_text = true;
        };

        mapping = {
          "<C-e>" = "cmp.mapping.abort()";
          "<CR>" = "cmp.mapping.confirm({ select = true })"; # Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

          "<Tab>" = /* lua */ ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")

              local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
              end

              if cmp.visible() and has_words_before() then
                -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
                cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
              -- this way you will only jump inside the snippet region
              elseif luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          "<S-Tab>" = /* lua */ ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")

              local has_words_before = function()
                if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
              end

              if cmp.visible() and has_words_before() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';
        };

        sources = [
          { name = "otter"; }
          {
            name = "copilot";
            groupIndex = 1;
            priority = 4;
          }
          {
            name = "nvim_lsp";
            groupIndex = 1;
            priority = 3;
          }
          {
            name = "luasnip";
            option = {
              show_autosnippets = true;
            };
            groupIndex = 1;
            priority = 5;
          }
          {
            name = "path";
            groupIndex = 1;
          }
          {
            name = "buffer";
            groupIndex = 2;
            priority = 2;
          }
        ];
      };
    };
  };
}
