# .dotfiles

This is a set of dotfiles for Linux, intended to be used with [GNU `stow`](https://www.gnu.org/software/stow/).

## Terminology

From [the `stow` docs](https://www.gnu.org/software/stow/manual/stow.html#Terminology):

> A _package_ is a related collection of files and directories that you wish to administer as a unit — e.g., Perl or Emacs — and that needs to be installed in a particular directory structure — e.g., with bin, lib, and man subdirectories.

Each of the directories in this repo acts as a `stow` package.

## Usage

### Prerequisites

> [!IMPORTANT]
> I do plan on adding support for other package managers down the road.
> If you would like to see support for another package manager, please open an issue or a PR.

You will need to have `Homebrew` installed.
See [the `Homebrew` docs](https://brew.sh) for installation instructions.

> [!NOTE]
> If you don't have `gum` installed, you will be prompted to install it.

### Installing

To install all of the dependencies required, and automatically `stow` the packages, run:

```bash
chmod +x ./init.sh
./init.sh
```

#### Customizing the install

```bash
# Skip the installer
./init.sh --no-install

# Skip `stow`
./init.sh --no-stow

# Manually `stow` packages
./init.sh --manual-stow
```

### Uninstalling

> [!WARNING]
> In the case of `Homebrew`: (default)
> Uninstalling without disabling the dependency installer will uninstall all of the dependencies that could be installed by the installer.

```bash
./init.sh --uninstall
```
