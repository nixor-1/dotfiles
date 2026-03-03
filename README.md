# Overview

The dotfiles directory is used to store all files related to the configuration of my setup in one place.

# GNU Stow

The GNU Stow manager is used to insert symbolic links in the correct paths.

# Modular approach

A modular approach is utilized to enable/disable certain configurations at will. Each configuration file is stored in a parent directory with a module name.

The GNU Stow command `stow <module>` is used to create the symbolic link for a configuration file from a certain module.

An alias has been created in the `.bashrc` file, `stowall`, to run above GNU Stow command for all modules.
