{ self, inputs, ...}: {

  flake.nixosModules.desktop-apps = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      thunderbird
      obsidian
      nextcloud-client
      mpv
      # LibreOffice with spellcheck
      libreoffice-stable
      hunspell
      hunspellDicts.en_GB-ise
      hyphenDicts.en_GB
    ];
  };
}
