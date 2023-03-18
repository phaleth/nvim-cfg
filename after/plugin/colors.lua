function SetColors(color)
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, 'NvimTreeRootFolder', { fg = '#E4E4E4' })
end

SetColors('codedark')
