{ config, pkgs, ... }:
let
  tailscaleInf = "tailscale0";
in
{
  services = {
    # Enable CUPS to print documents.
    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable Tailscale
    tailscale = {
      enable = true;
      interfaceName = tailscaleInf;
    };

    # Needed for tailscale
    resolved.enable = true;

    # Ship journald logs to loki
    promtail = {
      enable = true;
      configuration = {
        clients =
          [
            {
              url = "https://logs-prod-us-central1.grafana.net/loki/api/v1/push";
              basic_auth = {
                username = "62022";
                password_file = with pkgs; "${secrets}/grafana/grafana_cloud_publisher.key";
              };
            }
          ];
        server = {
          http_listen_port = 9080;
        };
        scrape_configs = [
          {
            job_name = "systemd-journal";
            journal = {
              path = "/var/log/journal";
              max_age = "2h";
            };
            relabel_configs = [
              {
                source_labels = [ "__journal__systemd_unit" ];
                target_label = "unit";
              }
              {
                source_labels = [ "__journal__hostname" ];
                target_label = "host";
              }
              {
                source_labels = [ "__journal__hostname" "__journal__systemd_unit" ];
                target_label = "job";
                separator = "/";
              }
            ];
          }
        ];
      };
    };

    prometheus = {
      enable = true;
      remoteWrite = [
        {
          url = "https://prometheus-blocks-prod-us-central1.grafana.net/api/prom/push";
          basic_auth = {
            username = "126099";
            password_file = with pkgs; "${secrets}/grafana/grafana_cloud_publisher.key";
          };
        }
      ];
      globalConfig = {
        external_labels = {
          host = "cerebral";
        };
      };
      scrapeConfigs = [
        {
          job_name = "node-exporter";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = [ "localhost:9100" ];
            }
          ];
        }
        {
          job_name = "process-exporter";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = [ "localhost:9256" ];
            }
          ];
        }
      ];
      exporters = {
        node = {
          enable = true;
        };
        process = {
          enable = true;
          settings.process_names = [
            # Remove nix store path from process name
            {
              name = "{{.Matches.Wrapped}} {{ .Matches.Args }}";
              cmdline = [ "^/nix/store[^ ]*/(?P<Wrapped>[^ /]*) (?P<Args>.*)" ];
            }
          ];
        };
      };
    };

    nginx = {
      enable = true;
      virtualHosts."plex.trevorwhitney.net" = {
        useACMEHost = "plex.trevorwhitney.net";
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass = "http://127.0.0.1:32400/web/";
          };
          "/web" = {
            proxyPass = "http://127.0.0.1:32400/web";
          };
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "trevorjwhitney@gmail.com";
    certs."plex.trevorwhitney.net" = {
      group = "nginx";
      dnsProvider = "dnsimple";
      credentialsFile = "${pkgs.writeText "lets-encrypyt-creds" ''
    DNSIMPLE_OAUTH_TOKEN_FILE=${pkgs.secrets}/dnsimple/oauth_token
    ''}";
    };
  };
}
