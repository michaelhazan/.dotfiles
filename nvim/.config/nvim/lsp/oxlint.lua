---@type vim.lsp.Config
return {
  cmd = { "oxlint", "--lsp" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(vim.fs.dirname(vim.fs.find({ ".oxlintrc.json" }, { path = fname, upward = true })[1]))
  end,
}
