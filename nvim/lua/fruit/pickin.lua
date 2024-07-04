local pick = require "mini.pick"
pick.setup {
  options = {
    use_cache = true,
  },
}

local k = vim.keymap.set

k("n", "<leader>f", function()
  pick.builtin.files { tool = "git" }
end, { desc = "[pick] Find git files" })
k("n", "<leader>F", function()
  pick.start {
    source = { items = vim.fn.readdir "." },
  }
end, { desc = "[pick] Find files in current directory" })

-- https://github.com/mrshmllow/nvim-candy/blob/26f90fd23be1d3ce85340195ed28307f8cc55918/candy/lua/marshmallow/remap.lua#L40-L61
-- <3333

k("n", "<leader>g", function()
  local cope = function()
    local items = require("mini.pick").get_picker_items()

    vim.fn.setqflist(vim.tbl_map(function(value)
      local split = vim.split(value, ":")
      local text = table.concat(split, "", 4)

      return {
        filename = split[1],
        lnum = split[2],
        col = split[3],
        text = vim.trim(text),
      }
    end, items))

    vim.cmd.cope()
    return true
  end
  local buffer_mappings = { wipeout = { char = "<C-q>", func = cope } }
  require("mini.pick").builtin.grep_live({}, { mappings = buffer_mappings })
end, { desc = "Grep (root dir)" })
