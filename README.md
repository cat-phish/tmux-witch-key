# Tmux-Witch-Key

***Tmux-Witch-Key is a work in progress. Do not use if you're not willing to encounter some bugs. Major changes to the code and features may occur.***

A Tmux plugin inspired by [whichkey.nvim](https://github.com/folke/which-key.nvim)
to automatically show your mappings for the most common Tmux commands

## About

Tmux-Witch-Key is a Tmux plugin that can be installed using [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)
that will build a Tmux menu based on the most commonly used commands using your
existing Tmux mappings. It is bound by default to `prefix+Space`. You can build
your sub-menus from the main menu with `B`. Currently the supported menu categories
are mappings related to sessions, windows, and panes.

#### Limitations

There are limits to the way this plugin is implemented which mean that not every
permutation of some Tmux commands will be supported. Some commands are currently
(possibly permanently) outside of the scope of this project. Very specific commands
like those targeting a specific session, window, or pane number will likely never be
implemented. This is for multiple reasons. For one, there are simply too many commands
to cover. There are also limitations with Tmux menus in general that cause menus
to not display if they exceed to height of the terminal. This means that adding
core support for too many commands could cause issues that would be unfixable
for the user.

## Usage

`prefix+Space` to activate the menu

`B` on the the main menu to build the sub-menus from your config

## Installation

Install [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm)

Then add this line to your tmux.conf with the rest of your plugins

```set -g @plugin 'cat-phish/tmux-witch-key'```

## Roadmap

- [ ] Add support to add custom commands to sub-menus via tmux.conf
- [ ] Add support to change menu colors via tmux.conf
- [ ] Add root mappings
- [ ] Sort menu entries in alphabetical order
