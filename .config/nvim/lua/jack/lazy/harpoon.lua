-- /home/jack/.config/nvim/lua/jack/lazy/harpoonConf.lua

return {
  -- The plugin spec table itself
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2", -- or whatever branch you use
    config = function()
      -- All your setup and keymaps go here, *inside* the config function.
      local harpoon = require("harpoon")
      harpoon:setup()

      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        
            vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end )
            vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end )
            vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end )
            vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end )

    end,
  },
}
