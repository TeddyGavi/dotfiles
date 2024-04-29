return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
  },
  config = function(_, opts)
    local Harpoon = require("harpoon")
    Harpoon:setup(opts)

    -- basic telescope configuration
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")

    local function toggle_telescope(Harpoon_files)
      local refresh_list = function(files)
        local file = {}
        for _, item in ipairs(files.items) do
          table.insert(file, item.value)
        end
        return file
      end

      local file_paths = refresh_list(Harpoon_files)

      require("telescope.pickers")
        .new({}, {
          prompt_title = "Harpoon",
          finder = require("telescope.finders").new_table({
            results = file_paths,
          }),
          previewer = conf.file_previewer({}),
          sorter = conf.generic_sorter({}),
          attach_mappings = function(_, map)
            map({ "i", "n" }, "<C-d>", function(prompt_bufnr)
              local action_state = require("telescope.actions.state")
              local current_picker = action_state.get_current_picker(prompt_bufnr)

              current_picker:delete_selection(function(selection)
                Harpoon:list():remove_at(selection.index)
                file_paths = refresh_list(Harpoon:list())
              end)
            end, { desc = "Remove from Harpoon list" })
            return true
          end,
        })
        :find()
    end

    local keymap = vim.keymap

    keymap.set("n", "<C-e>", function()
      Harpoon.ui:toggle_quick_menu(Harpoon:list())
    end, { desc = "Open Harpoon quick window" })

    keymap.set("n", "<leader>ha", function()
      Harpoon:list():add()
    end, { desc = "Add file to Harpoon" })

    keymap.set("n", "<leader>ht", function()
      toggle_telescope(Harpoon:list())
    end, { desc = "Harpoon telescope menu" })

    keymap.set("n", "<leader>hn", function()
      Harpoon:list():prev()
    end, { desc = "Go to next Harpoon mark" })

    keymap.set("n", "<leader>hp", function()
      Harpoon:list():next()
    end, { desc = "Go to previous Harpoon mark" })

    keymap.set("n", "<leader>hx", function()
      Harpoon:list():clear()
    end, { desc = "Clear the Harpooned list" })

    keymap.set("n", "<leader>h1", function()
      Harpoon:list():select(1)
    end, { desc = "Harpoon select buffer 1" })

    keymap.set("n", "<leader>h2", function()
      Harpoon:list():select(2)
    end, { desc = "Harpoon select buffer 2" })

    keymap.set("n", "<leader>h3", function()
      Harpoon:list():select(3)
    end, { desc = "Harpoon select buffer 3" })

    keymap.set("n", "<leader>h4", function()
      Harpoon:list():select(4)
    end, { desc = "Harpoon select buffer 4" })

    keymap.set("n", "<leader>h5", function()
      Harpoon:list():select(5)
    end, { desc = "Harpoon select buffer 5" })
  end,
}
