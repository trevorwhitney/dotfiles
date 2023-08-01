{ config, pkgs, ... }:
let
  json = pkgs.formats.json { };
  pipewireRnnoiseConfig = {
    "context.modules" = [
      {
        "name" = "libpipewire-module-filter-chain";
        "args" = {
          "node.description" = "Noise Canceling (Amazon Mini Mic)";
          "media.name" = "Noise Canceling Source (Amazon Mini Mic)";
          "filter.graph" = {
            "nodes" = [
              {
                "type" = "ladspa";
                "name" = "rnnoise";
                "plugin" = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                "label" = "noise_suppressor_mono";
                "control" = {
                  "VAD Threshold (%)" = 50.0;
                };
              }
            ];
          };

          "audio.position" = [ "MONO" ];
          "capture.props" = {
            "node.name" = "effect_input.rnnoise";
            "node.passive" = true;

            # found using pw-dump
            "node.target" = "alsa_input.usb-FongLun_AmazonBasics_Desktop_Mini_Mic_201802-00.mono-fallback";
            "audio.position" = [ "MONO" ];
          };

          "playback.props" = {
            "node.name" = "effect_output.rnnoise";
            "media.class" = "Audio/Source";
            "audio.position" = [ "MONO" ];
          };
        };
      }
    ];
  };
in
{
  # Enable sound with pipewire.
  # sound.enable = false;
  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
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

  environment.etc."pipewire/pipewire.conf.d/99-input-denoising.conf" = {
    source = json.generate "99-input-denoising.conf" pipewireRnnoiseConfig;
  };
}
