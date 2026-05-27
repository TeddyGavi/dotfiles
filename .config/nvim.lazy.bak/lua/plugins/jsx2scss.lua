return {
  {
    dir = "~/plugins/jsx2scss",
    name = "jsx2scss",
    event = "VeryLazy",
    config = function()
      require("jsx2scss").setup()
    end,
  },
}
