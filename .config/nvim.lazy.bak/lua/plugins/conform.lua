return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      prettier = {
        prepend_args = {
          "--single-quote",
          "--trailing-comma",
          "none",
          "--arrow-parens", "always"
        },
      },
    },
  },
}
