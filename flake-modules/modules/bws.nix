{
  flake.modules.nixos.bws =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.services.bws;

      baseDir = "/var/lib/bws";
      secretsDir = "${baseDir}/secrets";
      stateDir = "${baseDir}/state";

      configFile = pkgs.writeText "bws-config.json" (
        builtins.toJSON {
          state_dir = stateDir;
        }
      );

      fetchScript = pkgs.writeShellScript "bws-fetch.sh" ''
        set -euo pipefail
        shopt -s nullglob

        tmp_files=()
        cleanup() {
          [ "''${#tmp_files[@]}" -gt 0 ] && rm -f "''${tmp_files[@]}"
        }
        trap cleanup EXIT

        # Declare a set of allowed secret paths
        declare -A allowed_secrets=(
          ${lib.optionalString (cfg.secrets != { }) (
            lib.concatMapStringsSep "\n          " (
              name:
              let
                secret = cfg.secrets.${name};
              in
              "[${lib.escapeShellArg secret.path}]=1"
            ) (builtins.attrNames cfg.secrets)
          )}
        )

        ${lib.concatMapStringsSep "\n" (
          name:
          let
            secret = cfg.secrets.${name};
          in
          ''
            if ! json=$(BWS_CONFIG_FILE=${configFile} ${lib.getExe cfg.package} secret get ${lib.escapeShellArg secret.id}); then
              echo "error: failed to fetch secret ${lib.escapeShellArg secret.id}" >&2
              exit 1
            fi

            if ! value=$(echo "$json" | ${lib.getExe pkgs.jq} -r '.value'); then
              echo "error: failed to parse secret ${lib.escapeShellArg secret.id}" >&2
              exit 1
            fi

            tmp=$(mktemp -p "${baseDir}")
            tmp_files+=("$tmp")
            printf '%s' "$value" > "$tmp"
            chmod ${secret.mode} "$tmp"
            chown ${secret.owner}:${secret.group} "$tmp" || {
              echo "error: failed to chown ${lib.escapeShellArg secret.path} to ${secret.owner}:${secret.group}" >&2
              echo "       ensure user and group exist" >&2
              exit 1
            }
            mv "$tmp" ${lib.escapeShellArg secret.path}
          ''
        ) (builtins.attrNames cfg.secrets)}

        # Clean up any secrets not declared in the configuration
        if [ -d "${secretsDir}" ]; then
          for secret_file in "${secretsDir}"/*; do
            if [[ ! ''${allowed_secrets[$secret_file]} ]]; then
              echo "Removing undeclared secret: $secret_file"
              rm -f "$secret_file"
            fi
          done
        fi
      '';
    in
    {
      options.services.bws = {
        enable = lib.mkEnableOption "Bitwarden Secrets Manager";

        secrets = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule (
              { name, ... }:
              {
                options = {
                  id = lib.mkOption {
                    type = lib.types.str;
                    description = lib.mdDoc "Secret ID from Bitwarden Secrets Manager.";
                  };

                  path = lib.mkOption {
                    type = lib.types.str;
                    default = "${secretsDir}/${name}";
                    defaultText = lib.literalExpression ''"''${secretsDir}/''${name}"'';
                    readOnly = true;
                    description = lib.mdDoc "Path where the secret is written.";
                  };

                  mode = lib.mkOption {
                    type = lib.types.strMatching "(0[0-7]{3}|[0-7]{3})";
                    default = "0400";
                    description = lib.mdDoc "File mode for the secret file.";
                  };

                  owner = lib.mkOption {
                    type = lib.types.str;
                    default = "root";
                    description = lib.mdDoc "File owner for the secret file.";
                  };

                  group = lib.mkOption {
                    type = lib.types.str;
                    default = "root";
                    description = lib.mdDoc "File group for the secret file.";
                  };
                };
              }
            )
          );
          default = { };
          description = lib.mdDoc "Secrets to fetch from Bitwarden Secrets Manager.";
        };

        package = lib.mkOption {
          type = lib.types.package;
          default = pkgs.bws;
          defaultText = lib.literalExpression "pkgs.bws";
          description = lib.mdDoc "The bws package to use.";
        };

        auth = {
          envFile = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/bws/auth/auth.env";
            description = lib.mdDoc "Path to environment file containing BWS_ACCESS_TOKEN.";
          };
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = lib.all (name: !(lib.hasInfix "/" name)) (builtins.attrNames cfg.secrets);
            message = "services.bws.secrets: secret names cannot contain '/'";
          }
          {
            assertion = lib.all (
              name:
              !(lib.any (c: lib.hasInfix c name) [
                "*"
                "?"
                "["
                "]"
              ])
            ) (builtins.attrNames cfg.secrets);
            message = "services.bws.secrets: secret names cannot contain shell glob characters: * ? [ ]";
          }
        ];

        environment.systemPackages = [ cfg.package ];

        systemd.services.bws = {
          description = "Fetch Bitwarden Secrets";
          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = fetchScript;
            EnvironmentFile = "-${cfg.auth.envFile}";
            StateDirectory = "bws bws/secrets bws/auth bws/state";
            StateDirectoryMode = "0700";
            WorkingDirectory = baseDir;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ProtectHome = true;
          };
        };
      };
    };
}
