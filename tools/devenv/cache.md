# Fix cache

devenv init

...
• Added input 'nixpkgs':
'github:cachix/devenv-nixpkgs/8f24a228a782e24576b155d1e39f0d914b380691' (2026-05-11)
• Added input 'nixpkgs/nixpkgs-src':
'github:NixOS/nixpkgs/b3da656039dc7a6240f27b2ef8cc6a3ef3bccae7?narHash=sha256-I4puXmX1iovcCHZlRmztO3vW0mAbbRvq4F8wgIMQ1MM%3D' (2026-05-08)
• Added input 'pre-commit-hooks':
follows 'git-hooks'
⠇ Building shell
⠙ Building shell direnv: ([/nix/store/59c64rj85ahjd3wm36xkgmngvbc3101z-direnv-2.37.1/bin/direnv export zsh]) is taking a while to execute. Use CTRL-C to give up.
• Using Cachix caches: devenv
Trusting devenv.cachix.org on first use with the public key devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
Failed to set up binary caches:

https://devenv.cachix.org

devenv is configured to automatically manage binary caches with `cachix.enable = true`, but cannot do so because you are not a trusted user of the Nix store.

You have several options:

a) To let devenv set up the caches for you, add yourself to the trusted-users list in /etc/nix/nix.conf:

     trusted-users = root rj

Then restart the nix-daemon:

     $ sudo launchctl kickstart -k system/org.nixos.nix-daemon

b) Add the missing binary caches to /etc/nix/nix.conf yourself:

     extra-substituters = https://devenv.cachix.org
     extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=

c) Disable automatic cache management in your devenv configuration:

     {
       cachix.enable = false;
     }

Failed to get cachix caches due to evaluation error
warning: unknown setting 'eval-cores'
⠋ Building shell

Creating .gitignore
direnv: loading ~/tmp/.envrc
direnv: using devenv
• Using Cachix caches: devenv
Failed to set up binary caches:

https://devenv.cachix.org

devenv is configured to automatically manage binary caches with `cachix.enable = true`, but cannot do so because you are not a trusted user of the Nix store.

You have several options:

a) To let devenv set up the caches for you, add yourself to the trusted-users list in /etc/nix/nix.conf:

     trusted-users = root rj

Then restart the nix-daemon:

     $ sudo launchctl kickstart -k system/org.nixos.nix-daemon

b) Add the missing binary caches to /etc/nix/nix.conf yourself:

     extra-substituters = https://devenv.cachix.org
     extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=

c) Disable automatic cache management in your devenv configuration:

     {
       cachix.enable = false;
     }

Failed to get cachix caches due to evaluation error
✖ Building shell
