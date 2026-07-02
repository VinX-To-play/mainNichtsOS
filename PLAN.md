# Dendritic Migration Plan

## Goal

Restructure from the old hierarchical pattern (`hosts/` → imports `shared/`) to the dendritic pattern: every `.nix` under `modules/` is a top-level module implementing a single feature, auto-imported via `treeImport`, activated by `vinlabs.<feature>.enable` toggles.

## Impact

- **No runtime change.** Hosts build identically — same packages, same services, same configs.
- **File structure changes completely.** `hosts/`, `shared/`, `Packages/`, `Wigits/` are decomposed into `modules/` + `nixosConfigurations/` + `nixosModules/` + `pkgs/`.
- **Host configs become thin toggles.** Adding a feature to a host goes from an `imports` list entry to a single `vinlabs.<feature>.enable = true` line.

## Mapping: Current → New

### `shared/base.nix` → `modules/base/` (no toggles, always active)

| Current section | New file | Contents |
|---|---|---|
| Boot settings | `modules/base/boot.nix` | systemd-boot, EFI, kernelPackages |
| Localization | `modules/base/locale.nix` | timezone, i18n, locale settings, xkb layout, console keyMap |
| Nix settings | `modules/base/nix.nix` | experimental-features, trusted-users, substituters, GC, nixpkgs config |
| Tailscale | `modules/base/tailscale.nix` | tailscale service, headscale server, auth key, networking.hosts |
| SOPS | `modules/base/sops.nix` | sops module import, defaultSopsFile, age keyFile |
| Sudo | `modules/base/sudo.nix` | NOPASSWD nixos-rebuild for vincentl |
| Base packages | `modules/base/packages.nix` | auto-cpufreq, btop, git, tmux, wget, etc. |
| Docker | `modules/base/docker.nix` | virtualisation.docker.enable |
| GnuPG / polkit | inlined in `modules/base/sops.nix` | security.polkit, programs.gnupg.agent |

### `shared/hm-base.nix` → `modules/base/shell.nix` (no toggle)

Bash, git config, direnv, nix-direnv, kitty, theming — always active for all hosts.

### `shared/modules/style.nix` → `modules/base/stylix.nix` (no toggle)

Stylix theming module used by all hosts. Merge in HM theming from `shared/hm-modules/theming.nix`.

### `shared/clients-base.nix` → split into `modules/case/` + `modules/device-type/`

| Current section | New file | Toggle |
|---|---|---|
| GUI apps (zen-browser, discord, vesktop, obsidian, thunderbird, etc.) | `modules/case/desktop.nix` | `vinlabs.desktop.enable` |
| Steam, gamescope, heroic | `modules/case/gaming.nix` | `vinlabs.gaming.enable` |
| Wayland, display manager (ly), xwayland, electron wayland | `modules/device-type/workstation.nix` | `vinlabs.workstation.enable` |
| Bluetooth, printing, pipewire, opentabletdriver | `modules/device-type/laptop.nix` | `vinlabs.laptop.enable` |
| Fonts import | `modules/extensions/fonts.nix` | `vinlabs.fonts.enable` |

### `shared/modules/` → `modules/extensions/` (one file per feature, all toggled)

| Current | New file | Toggle |
|---|---|---|
| `obs.nix` | `modules/extensions/obs.nix` | `vinlabs.obs.enable` |
| `sunshine.nix` | `modules/extensions/sunshine.nix` | `vinlabs.sunshine.enable` |
| `gns3.nix` | `modules/extensions/gns3.nix` | `vinlabs.gns3.enable` |
| `lama-cpp.nix` | `modules/extensions/llama-cpp.nix` | `vinlabs.llama-cpp.enable` |
| `art.nix` | `modules/extensions/art.nix` | `vinlabs.art.enable` |
| `hyprland/` + HM hyprland | `modules/extensions/hyprland.nix` | `vinlabs.hyprland.enable` |
| `sway/` + HM sway | `modules/extensions/sway.nix` | `vinlabs.sway.enable` |
| `vr/` | `modules/extensions/vr.nix` | `vinlabs.vr.enable` |
| `hardware/keybord-remap.nix` | `nixosModules/keybord-remap.nix` | `vinlabs.keybord.enable` |
| `AI.nix` | `modules/extensions/ollama.nix` | `vinlabs.ollama.enable` |

### `shared/hm-modules/` → merge into feature modules

| Current HM module | Destination |
|---|---|
| `bash.nix` | `modules/base/shell.nix` |
| `kitty.nix` | `modules/base/shell.nix` |
| `theming.nix` | `modules/base/stylix.nix` |
| `kickstart.nixvim/nixvim.nix` | `modules/extensions/nixvim.nix` (new toggle) |
| `hyprland/` HM config | `modules/extensions/hyprland.nix` (merge into) |
| `sway/` HM config | `modules/extensions/sway.nix` (merge into) |

### `hosts/server/` → `modules/extensions/` (one file per service)

| Current | New file | Toggle |
|---|---|---|
| `nginx.nix` | `modules/extensions/nginx.nix` | `vinlabs.nginx.enable` |
| `vaultwarden.nix` | `modules/extensions/vaultwarden.nix` | `vinlabs.vautwarden.enable` |
| `step-ca.nix` | `modules/extensions/step-ca.nix` | `vinlabs.step-ca.enable` |
| `komga.nix` | `modules/extensions/komga.nix` | `vinlabs.komga.enable` |
| `samba.nix` | `modules/extensions/samba.nix` | `vinlabs.samba.enable` |
| `navidrome.nix` | `modules/extensions/navidrome.nix` | `vinlabs.navidrome.enable` |
| `arr.nix` | `modules/extensions/arr.nix` | `vinlabs.arr.enable` |
| `open-webui.nix` | `modules/extensions/open-webui.nix` | `vinlabs.open-webui.enable` |
| `searxng.nix` | `modules/extensions/searxng.nix` | `vinlabs.searxng.enable` |
| `llmswitch.nix` | `modules/extensions/llmswitch.nix` | `vinlabs.llmswitch.enable` |
| `nix-cache.nix` | `modules/extensions/nix-cache.nix` | `vinlabs.nix-cache.enable` |

### Other moves

| Current | New |
|---|---|
| `Packages/Helium/package.nix` | `pkgs/Helium/package.nix` |
| `Wigits/eww/` | Config inline in `modules/extensions/eww.nix` |
| `hosts/<host>/hardware-configuration.nix` | `nixosConfigurations/<name>/hardware-configuration.nix` |
| `hosts/<host>/home.nix` | Removed — HM inline in feature modules |
| `hosts/main_desktop/my-edid.bin` | `nixosConfigurations/nichtsos/my-edid.bin` |
| `secrets/` | Unchanged |
| `shared/recorces/` | If still needed, reference from absolute path or move to a static asset location |
| `shared/scripts/` | Evaluate if scripts are still used; move to appropriate location if so |

## Host entry point schemas

### `nixosConfigurations/nichtsos/nixos.nix`
```nix
{ ... }: {
  imports = [ ../modules ./hardware-configuration.nix ];
  networking.hostName = "nichtsos";
  boot.kernelParams = [ "drm.edid_firmware=DP-1:edid/my-edid.bin" "video=DP-1:2560x1440@144e" ];
  services.openssh.enable = true;

  vinlabs = {
    desktop.enable = true;
    gaming.enable = true;
    workstation.enable = true;
    hyprland.enable = true;
    sway.enable = true;
    obs.enable = true;
    sunshine.enable = true;
    vr.enable = true;
    gns3.enable = true;
    llama-cpp.enable = true;
    fonts.enable = true;
    art.enable = true;
  };
}
```

### `nixosConfigurations/nichtsos-thinkpad/nixos.nix`
```nix
{ ... }: {
  imports = [ ../modules ./hardware-configuration.nix ];
  networking.hostName = "nichtsos-thinkpad";

  vinlabs = {
    desktop.enable = true;
    laptop.enable = true;
    hyprland.enable = true;
    sway.enable = true;
    obs.enable = true;
    fonts.enable = true;
  };
}
```

### `nixosConfigurations/nichtsos-thinkpad-T14/nixos.nix`
```nix
{ ... }: {
  imports = [ ../modules ./hardware-configuration.nix ];
  networking.hostName = "nichtsos-thinkpad-T14";

  vinlabs = {
    desktop.enable = true;
    laptop.enable = true;
    hyprland.enable = true;
    sway.enable = true;
    obs.enable = true;
    gns3.enable = true;
    fonts.enable = true;
    keybord.enable = true;
  };
}
```

### `nixosConfigurations/nix-server/nixos.nix`
```nix
{ ... }: {
  imports = [ ../modules ./hardware-configuration.nix ];
  networking.hostName = "nix-server";
  services.openssh.enable = true;

  vinlabs = {
    server.enable = true;
    nginx.enable = true;
    vautwarden.enable = true;
    step-ca.enable = true;
    komga.enable = true;
    samba.enable = true;
    navidrome.enable = true;
    arr.enable = true;
    open-webui.enable = true;
    searxng.enable = true;
    llmswitch.enable = true;
    nix-cache.enable = true;
  };
}
```

## Updated `flake.nix`

```nix
{
  description = "NixOS configuration";

  nixConfig.extra-experimental-features = ["nix-command" "flakes"];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    sheard-host.url = "github:VinX-To-play/sheard-host-mirror";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scrumpkgs = {
      url = "github:Scrumplex/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-stable, home-manager, sops-nix, sheard-host, nixpkgs-xr, nixos-hardware, ... }:
    let
      system = "x86_64-linux";

      stableOverlay = final: prev: {
        stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
      };
    in {
      nixosConfigurations = {
        nichtsos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ stableOverlay nixpkgs-xr.overlays.default ]; }
            ./nixosConfigurations/nichtsos/nixos.nix
            sops-nix.nixosModules.sops
            sheard-host.nixosModules.sheardHosts
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = {};
              home-manager.sharedModules = [ inputs.nixvim.homeModules.nixvim ];
            }
          ];
        };

        nichtsos-thinkpad = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ stableOverlay ]; }
            ./nixosConfigurations/nichtsos-thinkpad/nixos.nix
            sops-nix.nixosModules.sops
            sheard-host.nixosModules.sheardHosts
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = {};
              home-manager.sharedModules = [ inputs.nixvim.homeModules.nixvim ];
            }
          ];
        };

        nichtsos-thinkpad-T14 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ stableOverlay ]; }
            ./nixosConfigurations/nichtsos-thinkpad-T14/nixos.nix
            sops-nix.nixosModules.sops
            sheard-host.nixosModules.sheardHosts
            nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen1
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = {};
              home-manager.sharedModules = [ inputs.nixvim.homeModules.nixvim ];
            }
          ];
        };

        nix-server = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ stableOverlay ]; }
            ./nixosConfigurations/nix-server/nixos.nix
            sops-nix.nixosModules.sops
            sheard-host.nixosModules.sheardHosts
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.vincentl = {};
              home-manager.sharedModules = [ inputs.nixvim.homeModules.nixvim ];
            }
          ];
        };
      };
    };
}
```

## Execution checklist

### Phase 1 — Scaffold

- [ ] 1. Create directory skeleton:
  ```bash
  mkdir -p modules/{abstract,base,case,device-type,extensions}
  mkdir -p nixosConfigurations/{nichtsos,nichtsos-thinkpad,nichtsos-thinkpad-T14,nix-server}
  mkdir -p nixosModules pkgs
  ```

- [ ] 2. Create `modules/default.nix` with `treeImport` function (auto-imports all `*.nix` recursively, excluding itself).

### Phase 2 — `modules/base/` (no toggles)

- [ ] 3. Create `modules/base/boot.nix` — from `shared/base.nix` boot section
- [ ] 4. Create `modules/base/locale.nix` — from `shared/base.nix` locale section
- [ ] 5. Create `modules/base/nix.nix` — from `shared/base.nix` nix settings section
- [ ] 6. Create `modules/base/tailscale.nix` — from `shared/base.nix` tailscale section
- [ ] 7. Create `modules/base/sops.nix` — from `shared/base.nix` sops section (merge gnupg agent, polkit, SOPS import)
- [ ] 8. Create `modules/base/sudo.nix` — from `shared/base.nix` sudo section
- [ ] 9. Create `modules/base/packages.nix` — from `shared/base.nix` packages section
- [ ] 10. Create `modules/base/docker.nix` — from `shared/base.nix` docker line

### Phase 3 — `modules/base/` style + shell

- [ ] 11. Create `modules/base/stylix.nix` — merge `shared/modules/style.nix` + `shared/hm-modules/theming.nix`
- [ ] 12. Create `modules/base/shell.nix` — merge `shared/hm-modules/{bash,kitty}.nix` + HM git, direnv, xdg mime from `shared/hm-base.nix`

### Phase 4 — `modules/abstract/`

- [ ] 13. Create `modules/abstract/flake-config.nix` — nixConfig block
- [ ] 14. Create `modules/abstract/overlays.nix` — stableOverlay definition

### Phase 5 — `modules/case/` and `modules/device-type/`

- [ ] 15. Create `modules/case/desktop.nix` — `vinlabs.desktop.enable`, GUI apps
- [ ] 16. Create `modules/case/gaming.nix` — `vinlabs.gaming.enable`, Steam, gamescope
- [ ] 17. Create `modules/case/server.nix` — `vinlabs.server.enable` (server base + GRUB override)
- [ ] 18. Create `modules/device-type/workstation.nix` — `vinlabs.workstation.enable`, wayland, display manager, GPU
- [ ] 19. Create `modules/device-type/laptop.nix` — `vinlabs.laptop.enable`, bluetooth, printing, pipewire, OTD

### Phase 6 — `modules/extensions/` (from `shared/modules/`)

- [ ] 20. Convert `shared/modules/hyprland/` → `modules/extensions/hyprland.nix` with `vinlabs.hyprland.enable` (merge HM hyprland)
- [ ] 21. Convert `shared/modules/sway/` → `modules/extensions/sway.nix` with `vinlabs.sway.enable` (merge HM sway)
- [ ] 22. Convert `shared/modules/vr/` → `modules/extensions/vr.nix` with `vinlabs.vr.enable`
- [ ] 23. Convert `shared/modules/obs.nix` → `modules/extensions/obs.nix` with `vinlabs.obs.enable`
- [ ] 24. Convert `shared/modules/sunshine.nix` → `modules/extensions/sunshine.nix` with `vinlabs.sunshine.enable`
- [ ] 25. Convert `shared/modules/gns3.nix` → `modules/extensions/gns3.nix` with `vinlabs.gns3.enable`
- [ ] 26. Convert `shared/modules/lama-cpp.nix` → `modules/extensions/llama-cpp.nix` with `vinlabs.llama-cpp.enable`
- [ ] 27. Convert `shared/modules/fonts.nix` → `modules/extensions/fonts.nix` with `vinlabs.fonts.enable`
- [ ] 28. Convert `shared/modules/art.nix` → `modules/extensions/art.nix` with `vinlabs.art.enable`
- [ ] 29. Convert `shared/modules/AI.nix` → `modules/extensions/ollama.nix` with `vinlabs.ollama.enable`

### Phase 7 — `modules/extensions/` (from `hosts/server/`)

- [ ] 30. Convert `hosts/server/nginx.nix` → `modules/extensions/nginx.nix` with `vinlabs.nginx.enable`
- [ ] 31. Convert `hosts/server/vaultwarden.nix` → `modules/extensions/vaultwarden.nix` with `vinlabs.vautwarden.enable`
- [ ] 32. Convert `hosts/server/step-ca.nix` → `modules/extensions/step-ca.nix` with `vinlabs.step-ca.enable`
- [ ] 33. Convert `hosts/server/komga.nix` → `modules/extensions/komga.nix` with `vinlabs.komga.enable`
- [ ] 34. Convert `hosts/server/samba.nix` → `modules/extensions/samba.nix` with `vinlabs.samba.enable`
- [ ] 35. Convert `hosts/server/navidrome.nix` → `modules/extensions/navidrome.nix` with `vinlabs.navidrome.enable`
- [ ] 36. Convert `hosts/server/arr.nix` → `modules/extensions/arr.nix` with `vinlabs.arr.enable`
- [ ] 37. Convert `hosts/server/open-webui.nix` → `modules/extensions/open-webui.nix` with `vinlabs.open-webui.enable`
- [ ] 38. Convert `hosts/server/searxng.nix` → `modules/extensions/searxng.nix` with `vinlabs.searxng.enable`
- [ ] 39. Convert `hosts/server/llmswitch.nix` → `modules/extensions/llmswitch.nix` with `vinlabs.llmswitch.enable`
- [ ] 40. Convert `hosts/server/nix-cache.nix` → `modules/extensions/nix-cache.nix` with `vinlabs.nix-cache.enable`

### Phase 8 — `nixosModules/`, `pkgs/`, misc

- [ ] 41. Move `shared/modules/hardware/keybord-remap.nix` → `nixosModules/keybord-remap.nix` with `vinlabs.keybord.enable`
- [ ] 42. Move `Packages/Helium/package.nix` → `pkgs/Helium/package.nix`
- [ ] 43. Create `modules/extensions/eww.nix` — `vinlabs.eww.enable` (EWW widgets from `Wigits/`)
- [ ] 44. Create `modules/extensions/nixvim.nix` — `vinlabs.nixvim.enable` (HM nixvim config from `shared/hm-modules/kickstart.nixvim/`)

### Phase 9 — Entry points

- [ ] 45. Create `nixosConfigurations/nichtsos/nixos.nix` with toggles + per-host overrides
- [ ] 46. Copy `hardware-configuration.nix` + `my-edid.bin` from `hosts/main_desktop/` to `nixosConfigurations/nichtsos/`
- [ ] 47. Create `nixosConfigurations/nichtsos-thinkpad/nixos.nix` with toggles
- [ ] 48. Copy `hardware-configuration.nix` from `hosts/ThinkPad/` to `nixosConfigurations/nichtsos-thinkpad/`
- [ ] 49. Create `nixosConfigurations/nichtsos-thinkpad-T14/nixos.nix` with toggles
- [ ] 50. Copy `hardware-configuration.nix` from `hosts/T14/` to `nixosConfigurations/nichtsos-thinkpad-T14/`
- [ ] 51. Create `nixosConfigurations/nix-server/nixos.nix` with toggles
- [ ] 52. Copy `hardware-configuration.nix` from `hosts/server/` to `nixosConfigurations/nix-server/`

### Phase 10 — flake.nix + verification

- [ ] 53. Update `flake.nix` — module lists point to new entry point paths
- [ ] 54. Verify: `nix flake check`
- [ ] 55. Build all hosts: `nixos-rebuild build --flake .#nichtsos` etc.
- [ ] 56. Remove old directories: `hosts/`, `shared/`, `Packages/`, `Wigits/`, `result*` symlinks
- [ ] 57. Update `AGENTS.md` to final state
