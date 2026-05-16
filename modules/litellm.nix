{
  flake.modules.homeManager.litellm =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.services.litellm;

      configFile = pkgs.writeText "litellm-config.yaml" (
        builtins.toJSON {
          litellm_settings = {
            drop_params = true;
            additional_drop_params = [ "context_management" ];
          };
          model_list = [
            {
              model_name = "claude-sonnet-4-6";
              litellm_params.model = "github_copilot/claude-sonnet-4.6";
            }
            {
              model_name = "claude-opus-4-6";
              litellm_params.model = "github_copilot/claude-opus-4.6";
            }
            {
              model_name = "claude-haiku-4-5-20251001";
              litellm_params.model = "github_copilot/claude-haiku-4.5";
            }
          ];
        }
      );
    in
    {
      options.services.litellm = {
        enable = lib.mkEnableOption "LiteLLM proxy for GitHub Copilot";

        port = lib.mkOption {
          type = lib.types.port;
          default = 4000;
          description = "Port for the LiteLLM proxy server.";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.litellm;
          defaultText = lib.literalExpression "pkgs.litellm";
          description = "The LiteLLM package to use.";
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [
          (pkgs.writeShellScriptBin "litellm-auth" ''
            echo "Starting LiteLLM to trigger GitHub Copilot device flow..."
            echo "Complete the authentication in your browser, then press Ctrl+C."
            echo ""
            exec ${lib.getExe cfg.package} --config ${configFile} --port ${toString cfg.port}
          '')
        ];

        systemd.user.services.litellm = {
          Unit = {
            Description = "LiteLLM proxy for GitHub Copilot";
            After = [ "network-online.target" ];
          };
          Service = {
            ExecStart = "${lib.getExe cfg.package} --config ${configFile} --port ${toString cfg.port}";
            Restart = "on-failure";
            RestartSec = 5;
          };
          Install.WantedBy = [ "default.target" ];
        };
      };
    };
}
