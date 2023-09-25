# MIT Jörg Thalheim - https://github.com/Mic92/dotfiles/blob/c6cad4e57016945c4816c8ec6f0a94daaa0c3203/nixos/modules/upgrade-diff.nix
{ config, pkgs, ... }:
{
  system.activationScripts.diff = {
    supportsDryActivation = true;
    text = ''
      if [[ -e /run/current-system ]]; then
        echo "--- diff to current-system"
        PATH=${config.nix.package}/bin:$PATH ${pkgs.nvd}/bin/nvd diff /run/current-system "$systemConfig"
        echo "---"
      fi
    '';
  };
}
