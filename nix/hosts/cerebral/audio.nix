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
                "label" = "noise_suppressor_stereo";
                "control" = {
                  "VAD Threshold (%)" = 50.0;
                };
              }
            ];
          };

          "capture.props" = {
            "node.name" = "effect_input.rnnoise";
            "node.passive" = true;

            # found using pw-dump
            "node.target" = "alsa_input.usb-FongLun_AmazonBasics_Desktop_Mini_Mic_201802-00.pro-input-0";
            "audio.position" = [ "AUX0" ];
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
  sound.enable = true;
  # hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  environment.etc."pipewire/pipewire.conf.d/99-input-denoising.conf" = {
    source = json.generate "99-input-denoising.conf" pipewireRnnoiseConfig;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
