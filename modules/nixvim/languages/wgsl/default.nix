{ inputs, pkgs, lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.plugins.lsp;
in
{
  config = mkIf cfg.enable {
    extraPackages = [
      inputs.wgsl-analyzer.packages.${pkgs.system}.default
    ];

    extraConfigLua = /* lua */ ''
      vim.filetype.add({
        extension = {
          wgsl = function(path, bufnr) 
            vim.api.nvim_buf_set_option(bufnr, "commentstring", "// %s")  

            return "wgsl" 
          end,
        },
      })

      require("lspconfig").wgsl_analyzer.setup({
        settings = {
          ["wgsl-analyzer"] = {},
        },
        handlers = {
          ["wgsl-analyzer/requestConfiguration"] = function()
            return {
              success = true,
              customImports = { _dummy_ = "dummy" },
              shaderDefs = {},
              trace = {
                extension = false,
                server = false,
              },
              inlayHints = {
                enabled = false,
                typeHints = false,
                parameterHints = false,
                structLayoutHints = false,
                typeVerbosity = "inner",
              },
              diagnostics = {
                typeErrors = true,
                nagaParsingErrors = true,
                nagaValidationErrors = true,
                nagaVersion = "main",
              },
            }
          end,
        },
      })
    '';
  };
}
