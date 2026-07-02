# AGENTS.md

NixOS system configuration flake for four machines: main desktop, ThinkPad, ThinkPad T14, and home server.

## Commands

```bash
# Build (verify without applying)
nixos-rebuild build --flake .#nichtsos
nixos-rebuild build --flake .#nichtsos-thinkpad
nixos-rebuild build --flake .#nichtsos-thinkpad-T14
nixos-rebuild build --flake .#nix-server

# Switch (apply and make boot default)
sudo nixos-rebuild switch --flake .#nichtsos

# Update flake inputs
nix flake update

# Build all systems (used by server cache)
nix flake update && \
  nixos-rebuild build --flake .#nichtsos && \
  nixos-rebuild build --flake .#nichtsos-thinkpad && \
  nixos-rebuild build --flake .#nichtsos-thinkpad-T14 && \
  nixos-rebuild build --flake .#nix-server

# Pre-commit check
nix flake check
```

The custom bash function `nix-rebuild` (defined in `modules/base/shell.nix`) wraps `nixos-rebuild switch`, prompts for a commit message, then auto-commits and pushes.

## Architecture (Dendritic Pattern)

Every `.nix` file under `modules/` is a **top-level Nixpkgs module** implementing a single feature. All modules are auto-imported via `import-tree` (github:denful/import-tree). Features are activated by toggling `vinlabs.<feature>.enable` options. Home-manager config lives alongside NixOS config in the same feature module file.

```
flake.nix                       # entry point — wires inputs → nixosConfigurations
modules/
  ├── base/                     # Applies to ALL hosts (no toggles, always active)
  │   ├── boot.nix              #   systemd-boot / EFI
  │   ├── locale.nix            #   timezone, i18n, keyboard layout
  │   ├── nix.nix               #   nix settings, substituters, GC, trusted-users
  │   ├── tailscale.nix         #   Tailscale with headscale server
  │   ├── sops.nix              #   SOPS secrets integration
  │   ├── sudo.nix              #   passwordless nixos-rebuild sudo
  │   ├── packages.nix          #   base system packages
  │   ├── docker.nix            #   Docker daemon
  │   ├── stylix.nix            #   System-wide theming (stylix)
  │   └── shell.nix             #   HM base: bash, git, direnv, kitty, nixvim
  ├── case/                     # Use-case modules (toggled per-host)
  │   ├── desktop.nix           #   vinlabs.desktop.enable
  │   ├── gaming.nix            #   vinlabs.gaming.enable
  │   └── server.nix            #   vinlabs.server.enable
  ├── device-type/              # Device-class modules (toggled per-host)
  │   ├── workstation.nix       #   vinlabs.workstation.enable
  │   └── laptop.nix            #   vinlabs.laptop.enable
  └── extensions/               # Feature modules shared between some hosts (toggled)
      ├── hyprland.nix          #   vinlabs.hyprland.enable
      ├── sway.nix              #   vinlabs.sway.enable
      ├── vr.nix                #   vinlabs.vr.enable
      ├── obs.nix               #   vinlabs.obs.enable
      ├── sunshine.nix          #   vinlabs.sunshine.enable
      ├── gns3.nix              #   vinlabs.gns3.enable
      ├── _llama-cpp.nix        #   vinlabs.llama-cpp.enable (_ prefix = explicit import only)
      ├── fonts.nix             #   vinlabs.fonts.enable
      ├── art.nix               #   vinlabs.art.enable
      ├── eww.nix               #   vinlabs.eww.enable (EWW widgets)
      ├── nixvim.nix            #   vinlabs.nixvim.enable
      ├── nginx.nix             #   vinlabs.nginx.enable
      ├── vaultwarden.nix       #   vinlabs.vautwarden.enable
      ├── step-ca.nix           #   vinlabs.step-ca.enable
      ├── komga.nix             #   vinlabs.komga.enable
      ├── samba.nix             #   vinlabs.samba.enable
      ├── navidrome.nix         #   vinlabs.navidrome.enable
      ├── arr.nix               #   vinlabs.arr.enable
      ├── open-webui.nix        #   vinlabs.open-webui.enable
      ├── searxng.nix           #   vinlabs.searxng.enable
      ├── llmswitch.nix         #   vinlabs.llmswitch.enable
      ├── nix-cache.nix         #   vinlabs.nix-cache.enable
      └── ollama.nix            #   vinlabs.ollama.enable
nixosConfigurations/            # Per-system thin entry points
  ├── nichtsos/
  │   ├── nixos.nix             #   toggles: desktop, workstation, hyprland, sway, vr, ...
  │   └── hardware-configuration.nix
  ├── nichtsos-thinkpad/
  │   ├── nixos.nix             #   toggles: desktop, laptop, hyprland, sway, obs
  │   └── hardware-configuration.nix
  ├── nichtsos-thinkpad-T14/
  │   ├── nixos.nix             #   toggles: desktop, laptop, hyprland, sway, gns3
  │   └── hardware-configuration.nix
  └── nix-server/
      ├── nixos.nix             #   toggles: server, nginx, vaultwarden, komga, ...
      └── hardware-configuration.nix
nixosModules/                   # Lower-level NixOS module definitions
  ├── keybord-remap.nix         #   vinlabs.keyboard.enable
  ├── nixvim/                   #   Nixvim config copied from kickstart.nixvim
  └── amdgpu-derivation.nix     #   Patched amdgpu kernel module for VR
pkgs/                           # Self-packaged derivations
  └── Helium/package.nix
secrets/                        # SOPS-encrypted (unchanged)
```

### How it works

1. `flake.nix` uses `inputs.import-tree ./modules` to auto-import every `.nix` file under `modules/` (excluding paths containing `/_`).
2. Each feature module defines `options.vinlabs.<feature>.enable = mkEnableOption` and wraps its NixOS + HM config in `config = mkIf cfg.enable { ... }`.
3. Host entry points (`nixosConfigurations/<name>/nixos.nix`) import `./hardware-configuration.nix` and set `vinlabs.<feature>.enable` toggles.
4. Files starting with `_` (e.g. `_llama-cpp.nix`) are excluded from auto-import and must be imported explicitly where needed.
5. `nixosModules/` contains lower-level modules that are manually imported by specific hosts.

## Hosts

| Flake output | Config | State version (OS) | State version (HM) |
|---|---|---|---|
| `nichtsos` | `nixosConfigurations/nichtsos/` | 23.11 | 24.05 |
| `nichtsos-thinkpad` | `nixosConfigurations/nichtsos-thinkpad/` | 23.11 | 24.05 |
| `nichtsos-thinkpad-T14` | `nixosConfigurations/nichtsos-thinkpad-T14/` | 23.11 | 24.05 |
| `nix-server` | `nixosConfigurations/nix-server/` | 25.05 | 25.05 |

All targets are `x86_64-linux`.

## Gotchas

- **`.envrc` auto-pulls git on `cd`.** Every directory entry triggers `git pull`. Be aware when working offline.
- **Secrets are SOPS-encrypted** with age. The key must be at `~/.config/sops/age/keys.txt`. SOPS templates are used for env vars, API keys, and nginx basic auth — never commit plaintext secrets.
- **`hosts/server/ca.json` is gitignored** — it is generated by step-ca at runtime. The step-ca module references it via `../../hosts/server/ca.json`.
- **Nix cache at `nix.slave.int`** — all machines use this as a substituter. The server builds all systems and serves them as a binary cache.
- **Stable package overlay** — `nixpkgs-stable` (nixos-26.05) is accessible as `pkgs.stable` in configurations.
- **`import-tree`** auto-imports all `.nix` files under `modules/`. Files with `/_` in their path (e.g. `_llama-cpp.nix`) are excluded by default.
- **`_llama-cpp.nix`** is excluded from auto-import because it downloads ~60GB of LLM models during evaluation. It's explicitly imported only for `nichtsos` in `flake.nix`.
- **`result*` symlinks** point into `/nix/store/` and are build artifacts. Do not commit or edit them.

## Style

- Consistent spelling quirks in the codebase: `recorces` (resources), `keybord` (keyboard), `vautwarden` (vaultwarden). Match existing usage when adding to those files.
- Custom module namespace at `vinlabs.`.
- Feature modules are named by a single feature at a path that reflects the feature name. When a module grows too large, split it.
