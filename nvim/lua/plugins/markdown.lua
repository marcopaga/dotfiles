-- Override markdownlint-cli2 to use the repo-local config so the disabled
-- rules in nvim/.markdownlint.jsonc are applied regardless of the file
-- being edited.
return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = {
            "--config",
            vim.fn.stdpath("config") .. "/.markdownlint.jsonc",
          },
        },
      },
    },
  },
}
