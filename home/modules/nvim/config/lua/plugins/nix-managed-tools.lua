return {
  -- On NixOS, prefer installing tools via nixpkgs/home-manager.
  -- Keep Mason available as a UI, but prevent it from auto-downloading binaries.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {},
    },
  },

  -- Tell LazyVim/LSP not to use Mason for servers we provide via nixpkgs.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = { mason = false },
        nil_ls = { mason = false },
      },
    },
  },

  -- Ensure Nix treesitter parser is present.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "nix" },
    },
  },
}
