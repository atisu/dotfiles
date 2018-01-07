
# Dotfiles
My dotfiles (vim, bash, zsh, etc. scripts). Mainly for personal use, but feel free to reuse them.

# Installing

1. Clone this repository (with submodules) to your home directory with submodules, as follows:

    `git clone --recursive https://github.com/atisu/dotfiles.git .dotfiles`

2. Cd to .dotfiles directory.

3. Use stow[1] to install files, e.g., `stow -R zsh`

# Notes

- TMUX configuration relies on TPM[2] and tmux-resurrect[3]. Please refer to their READMEs for more detail.

# References
 
[1] GNU Stow. https://www.gnu.org/software/stow/

[2] TMUX Plugin Manager. https://github.com/tmux-plugins/tpm

[3] tmux-resurrect. https://github.com/tmux-plugins/tmux-resurrect

