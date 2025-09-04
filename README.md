# sandbox.nvim

> **Disclaimer:**  
> This plugin is in very early development. Features will change, and breaking changes may occur at any time. Use at your own risk.

Neovim plugin that allows you to try different plugins without ever changing your configuration.

## Installation

Install using your favourite plugin manager.

- [lazy.nvim](https://github.com/folke/lazy.nvim)

````lua
{
  "R-Camacho/sandbox.nvim",
  opts = {},
}
````

- [packer.nvim](https://github.com/wbthomason/packer.nvim)

````lua
use { 'R-Camacho/sandbox.nvim' }
````

- [vim-plug](https://github.com/junegunn/vim-plug)

```viml
Plug 'R-Camacho/sandbox.nvim'
```

## Usage

The main purpose of this plugin is to temporarily install and load a plugin. The sandbox is automatically cleaned when you close Neovim.

- `:SandboxTry <author/plugin-name>`: Clones and loads a plugin from GitHub.
- `:SandboxList`: Lists all currently sandboxed plugins.
- `:SandboxClean`: Removes all sandboxed plugins.

For example, to try the [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) plugin, run:
```
:SandboxTry nvim-telescope/telescope.nvim
```

## License

MIT License. See [LICENSE](./LICENSE) for details.
