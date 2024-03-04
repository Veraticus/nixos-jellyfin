{
  config,
  lib,
  ...
}: let
  inherit (lib) boolToString mdDocs mkIf mkOption types;
  inherit (builtins) isNull toFile;

  cfg = config.services.jellyfin;
in {
  options.services.jellyfin = {
    settings = mkOption {
      default = null;
      type = with types;
        nullOr (submodule {
          options = {
            general = {
              branding = {
                loginDisclaimer = mkOption {
                  type = with types; nullOr str;
                  default = null;
                  description = mdDocs "A message that will be displayed at the bottom of the login page.";
                };

                customCss = mkOption {
                  type = types.lines;
                  default = "";
                  description = mdDocs "Apply your custom CSS code for theming/branding on the web interface.";
                };

                splashscreenEnabled = mkOption {
                  type = types.bool;
                  default = false;
                  description = mdDocs "Enable the splash screen";
                };
              };
            };
          };
        });
    };
  };

  config = mkIf (cfg.enable && cfg.settings != null) {
    systemd.services."jellyfin-conf" = let
      jellyConfig = config.systemd.services.jellyfin.serviceConfig;
      configDir = "${jellyConfig.WorkingDirectory}/config";

      mkEmptyDefault = opt: name:
        if isNull opt
        then "<${name} />"
        else "<${name}>${opt}</${name}>";

      mkBool = opt: name:
        "<${name}>${boolToString opt}</${name}>";

      importXML = file: cfg:
        toFile "${file}.xml" (import ./templates/${file}.nix {
          inherit cfg lib mkEmptyDefault mkBool;
        });

      brandingFile = importXML "branding" cfg.settings.general.branding;
    in {
      wantedBy = ["multi-user.target"];
      before = ["jellyfin.service"];
      requiredBy = ["jellyfin.service"];

      serviceConfig.WorkingDirectory = configDir;

      script = ''
        backupFile() {
            if [ -w "$1" ]; then
                if [ -h "$1" ]; then
                    rm "$1"
                else
                    rm -f "$1.bak"
                    mv "$1" "$1.bak"
                fi
            fi
        }

        backupFile "${configDir}/branding.xml"
        ln -sf ${brandingFile} "${configDir}/branding.xml"

        /run/current-system/systemd/bin/systemctl restart jellyfin.service
      '';
    };
  };
}
