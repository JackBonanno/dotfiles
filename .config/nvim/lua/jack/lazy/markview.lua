return {
  "oxy2dev/markview.nvim",
  lazy = false,

    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },

  config = function()
    -- this sets up markview
    require("markview").setup({
        latex = {
            enable = true,
            inline = {
                enable = true,
            },
            block = {
                enable = true,
                hl = "MarkviewCode", -- Reuses your existing code highlight
                text = " Equation ", -- Adds a nice label to equation blocks
            },
        },
        -- Ensure markdown extensions are enabled
        markdown = {
            enable = true,
        }
        })

    -- ### the real fix (v3) ###
    -- this function sets the correct markview-specific highlight groups
    local function set_markview_highlights()
      
      -- using colors from the bamboo palette
      local colors = {
        green = "#7f9a3f",
        blue = "#5f8787",
        yellow = "#d7af5f",
        orange = "#d7875f",
        purple = "#af87af",
        grey = "#6c6c6c",
        -- adding a brighter color for links/code
        red = "#d75f5f" 
      }

      -- set markview's custom highlight groups
      
      -- headers
      vim.api.nvim_set_hl(0, "markviewheading1", { fg = colors.purple, bold = true })
      vim.api.nvim_set_hl(0, "markviewheading2", { fg = colors.green, bold = true })
      vim.api.nvim_set_hl(0, "markviewheading3", { fg = colors.yellow, bold = true })
      vim.api.nvim_set_hl(0, "markviewheading4", { fg = colors.blue, bold = true })
      vim.api.nvim_set_hl(0, "markviewheading5", { fg = colors.red, bold = true })
      vim.api.nvim_set_hl(0, "markviewheading6", { fg = colors.orange, bold = true })
      
      -- text styles
      vim.api.nvim_set_hl(0, "markviewbold", { bold = true })
      vim.api.nvim_set_hl(0, "markviewitalic", { italic = true })
      vim.api.nvim_set_hl(0, "markviewstrikethrough", { strikethrough = true })

      -- code and links
      vim.api.nvim_set_hl(0, "markviewcode", { fg = colors.red }) -- `inline code`
      vim.api.nvim_set_hl(0, "markviewcodeblock", { fg = colors.orange })
      vim.api.nvim_set_hl(0, "markviewhyperlink", { fg = colors.blue, underline = true })
      
      -- lists and other elements
      vim.api.nvim_set_hl(0, "markviewlistitem", { fg = colors.orange }) -- for the * or -
      vim.api.nvim_set_hl(0, "markviewblockquote", { fg = colors.grey, italic = true })
      vim.api.nvim_set_hl(0, "markviewhorizontalrule", { fg = colors.grey })
    end

    -- 1. run the function immediately to apply the highlights on load
    set_markview_highlights()

    -- 2. create an autocmd to re-apply highlights if you change colorscheme
    vim.api.nvim_create_autocmd("colorscheme", {
      pattern = "*",
      group = vim.api.nvim_create_augroup("mymarkviewhighlights", { clear = true }),
      callback = set_markview_highlights, -- use the same function
    })
    
  end,
}

