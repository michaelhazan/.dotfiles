local function find_tsdk(root_dir)
  local dir = root_dir
  while dir do
    local candidate = vim.fs.joinpath(dir, "node_modules", "typescript", "lib")
    if vim.uv.fs_stat(candidate) then
      return candidate
    end

    local parent = vim.fs.dirname(dir)
    if parent == dir then
      return nil
    end
    dir = parent
  end
end

---@type vim.lsp.Config
return {
  cmd = { "mdx-language-server", "--stdio" },
  filetypes = { "mdx" },
  root_markers = { "package.json", ".git", ".storybook" },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  init_options = {
    typescript = {
      enabled = true,
    },
  },
  before_init = function(_, config)
    if not config.init_options.typescript.tsdk then
      config.init_options.typescript.tsdk = find_tsdk(config.root_dir)
    end
  end,
}
