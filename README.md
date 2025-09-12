# mnt-pocket-reform-nix

A Nix flake configuration for an ARM64 MNT Pocket Reform device with Home Manager and Stylix theming.

## Features

- **ARM64 Support**: Configured specifically for `aarch64-linux` architecture
- **Nix Unstable**: Tracks the latest nixpkgs unstable for cutting-edge packages
- **Home Manager**: User environment management with declarative configuration
- **Stylix Integration**: System-wide theming and color scheme management
- **Essential CLI Tools**: Pre-configured with common command line utilities

## Quick Start

### Prerequisites

1. Install Nix with flakes support:
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. Enable flakes and the nix command (if not already enabled):
   ```bash
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/lukeaurio/mnt-pocket-reform-nix.git
   cd mnt-pocket-reform-nix
   ```

2. Apply the Home Manager configuration:
   ```bash
   nix run home-manager/master -- switch --flake .#pocket-reform-user
   ```

   Or if you have home-manager installed globally:
   ```bash
   home-manager switch --flake .#pocket-reform-user
   ```

3. Source your shell configuration:
   ```bash
   source ~/.bashrc
   ```

## Customization

### User Configuration

Edit the `home.nix` file to customize:
- Username and home directory (lines 11-12)
- Git configuration (lines 88-99)
- Package selection (lines 44-86)
- Shell aliases and configuration

### Stylix Theming

The Stylix configuration can be customized in `home.nix`:
- Uncomment and set a custom color scheme
- Add a wallpaper image
- Configure additional target applications

### Adding Packages

Add new packages to the `home.packages` list in `home.nix`:
```nix
home.packages = with pkgs; [
  # existing packages...
  your-new-package
];
```

## Included Tools

### System Utilities
- `htop`, `btop` - System monitoring
- `tree`, `fd`, `ripgrep` - File system navigation
- `fzf`, `bat`, `exa` - Enhanced CLI tools
- `zoxide` - Smart directory jumping

### Development Tools
- `git`, `vim`, `neovim` - Version control and editing
- `tmux`, `screen` - Terminal multiplexers
- `gcc`, `gnumake` - Build tools

### Network & File Tools
- `curl`, `wget`, `rsync`, `openssh` - Network utilities
- `unzip`, `zip`, `p7zip` - Archive management
- `jq`, `yq` - JSON/YAML processing

## Development

Enter the development shell:
```bash
nix develop
```

This provides access to nix tools and helpful commands for managing the configuration.

## ARM64 Specific Notes

This configuration is optimized for ARM64 devices like the MNT Pocket Reform:
- Uses `aarch64-linux` system specification
- Includes ARM-specific hardware utilities (`usbutils`, `pciutils`)
- Lightweight tool selection suitable for ARM performance characteristics

## Troubleshooting

### Permission Issues
If you encounter permission issues, ensure your user is in the `nix-users` group:
```bash
sudo usermod -a -G nix-users $USER
```

### Flake Lock Updates
To update all flake inputs to their latest versions:
```bash
nix flake update
```

### Home Manager Issues
If home-manager fails, try rebuilding with verbose output:
```bash
home-manager switch --flake .#pocket-reform-user -v
```
