return {
  {
    dir = "~/plugins/rem_ghost",
    name = "rem_ghost",
    event = "VeryLazy",
    config = function()
      require("rem_ghost").setup()
    end,
  },
}
