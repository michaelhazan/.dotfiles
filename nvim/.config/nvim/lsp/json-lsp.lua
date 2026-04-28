---@type vim.lsp.Config
return {
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  init_options = {
    provideFormatter = true,
  },
  settings = {
    json = {
      schemas = {
        { fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" },
        { fileMatch = { "tsconfig*.json" }, url = "https://json.schemastore.org/tsconfig.json" },
        { fileMatch = { "turbo.json" }, url = "https://turborepo.dev/schema.json" },
      },
    },
  },
  root_markers = { ".git" },
}
