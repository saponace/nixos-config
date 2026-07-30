{ pkgs, username, ... }:

{

  environment.systemPackages = with pkgs; [
    crosspipe
    alsa-utils # ships amidi: send/receive MIDI SysEx
  ];

  preservation.preserveAt."/persistent".users.${username}.directories = [
    ".local/state/wireplumber" # Per-device routing/volume
  ];

  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
