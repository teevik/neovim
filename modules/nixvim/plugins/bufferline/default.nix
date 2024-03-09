{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.plugins.bufferline;
in
{
  config = mkIf cfg.enable {
    keymaps = [
      {
        mode = "n";
        key = "gb";
        action = "<cmd>:BufferLinePick<cr>";
        options = {
          silent = true;
          desc = "Go to buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>:bd<cr>";
        options = {
          silent = true;
          desc = "Delete buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bn";
        action = "<cmd>:bnext<cr>";
        options = {
          silent = true;
          desc = "Next buffer";
        };
      }
      {
        mode = "n";
        key = "<leader>bp";
        action = "<cmd>:bprevious<cr>";
        options = {
          silent = true;
          desc = "Previous buffer";
        };
      }
    ];

    plugins.which-key.registrations = {
      "<leader>b" = "+Buffer";
    };

    plugins.bufferline = {
      offsets = [
        {
          filetype = "NvimTree";
          text = "NvimTree";
          highlight = "Directory";
          textAlign = "left";
        }
      ];
    };
  };
}
