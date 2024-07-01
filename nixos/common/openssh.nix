# Better defaults for OpenSSH
{ config, lib, ... }:
{
  services.openssh = {
    settings.X11Forwarding = false;
    settings.KbdInteractiveAuthentication = false;
    settings.PasswordAuthentication = false;
    settings.UseDns = false;
    # unbind gnupg sockets if they exists
    settings.StreamLocalBindUnlink = true;

    # We might want to remove this once, openssh is fixed everywhere:
    # Workaround for CVE-2024-6387
    # https://github.com/NixOS/nixpkgs/pull/323753#issuecomment-2199762128
    settings.LoginGraceTime = 0;

    # Use key exchange algorithms recommended by `nixpkgs#ssh-audit`
    settings.KexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "sntrup761x25519-sha512@openssh.com"
    ];
    # Only allow system-level authorized_keys to avoid injections.
    # We currently don't enable this when git-based software that relies on this is enabled.
    # It would be nicer to make it more granular using `Match`.
    # However those match blocks cannot be put after other `extraConfig` lines
    # with the current sshd config module, which is however something the sshd
    # config parser mandates.
    authorizedKeysFiles = lib.mkIf
      (!config.services.gitea.enable
        && !config.services.gitlab.enable
        && !config.services.gitolite.enable
        && !config.services.gerrit.enable
        && !config.services.forgejo.enable)
      (lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ]);
  };
}
