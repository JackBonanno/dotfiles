return {
--    "nvim-treesitter/nvim-treesitter",
--    build = ":TSUpdate",
--    config = function()
--        require("nvim-treesitter.configs").setup({
--            -- A list of parser names, or "all"
--            ensure_installed = {
--                "vimdoc", "javascript", "typescript", "c", "lua", "rust",
--                "jsdoc", "bash", "java", "python",
--            },
--
--            -- Install parsers synchronously (only applied to `ensure_installed`)
--            sync_install = false,
--
--            -- Automatically install missing parsers when entering buffer
--            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
--            auto_install = false,
--
--            indent = {
--                enable = false
--            },
--
--            highlight = {
--                -- `false` will disable the whole extension
--                enable = true,
--                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
--                -- Using this option may slow down your editor, and you may see some duplicate highlights.
--                -- Instead of true it can also be a list of languages
--                --additional_vim_regex_highlighting = { "markdown" },
--            },
--        })


{
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',

    config = function()
      require('nvim-treesitter').setup()

      require('nvim-treesitter').install({
        'vimdoc',
        'javascript',
        'typescript',
        'c',
        'lua',
        'rust',
        'jsdoc',
        'bash',
        'java',
        'python',
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'javascript',
          'typescript',
          'c',
          'lua',
          'rust',
          'bash',
          'java',
          'python',
        },
        callback = function(args)
          vim.treesitter.start(args.buf)
        end,
      })
    end,
  },
}

