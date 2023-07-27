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
        extraConfig = ''
          gzip on;
          gzip_vary on;
          gzip_min_length 1000;
          gzip_proxied any;
          gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
          gzip_disable "MSIE [1-6]\.";

          # Forward real ip and host to Plex
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          #When using ngx_http_realip_module change $proxy_add_x_forwarded_for to '$http_x_forwarded_for,$realip_remote_addr'
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Sec-WebSocket-Extensions $http_sec_websocket_extensions;
          proxy_set_header Sec-WebSocket-Key $http_sec_websocket_key;
          proxy_set_header Sec-WebSocket-Version $http_sec_websocket_version;

          # Websockets
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "Upgrade";

          # Buffering off send to the client as soon as the data is received from Plex.
          proxy_redirect off;
          proxy_buffering off;
        '';
        locations = {
          "/" = {
            proxyPass = "https://127.0.0.1:32400";
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
