require("conform").setup({
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
})
