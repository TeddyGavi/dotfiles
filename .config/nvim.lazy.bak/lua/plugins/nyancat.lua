return {
  {
    dir = "~/plugins/nyancat",
    name = "nyancat",
    event = "VimEnter",
    config = function()
      require("nyancat").setup()
    end,
  },
}
