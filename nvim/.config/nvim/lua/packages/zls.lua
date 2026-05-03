---@param ctx InstallContext
---@param build BuildInstruction
local function run_build_instruction(ctx, build)
  local platform = require "mason-core.platform"
  local powershell = require "mason-core.installer.managers.powershell"
  local a = require "mason-core.async"
  local async_uv = require "mason-core.async.uv"

  return platform.when {
    unix = function()
      return ctx.spawn.bash {
        on_spawn = a.scope(function(_, stdio)
          local stdin = stdio[1]
          async_uv.write(stdin, "set -euxo pipefail;\n")
          async_uv.write(stdin, build.run)
          async_uv.shutdown(stdin)
          async_uv.close(stdin)
        end),
        env = build.env,
      }
    end,
    win = function()
      return powershell.command(build.run, {
        env = build.env,
      }, ctx.spawn)
    end,
  }
end

---@type RegistryPackageSpec
return {
  name = "zls",
  description = "Zig LSP implementation + Zig Language Server.",
  categories = { "LSP" },
  homepage = "https://github.com/zigtools/zls ",
  languages = { "Zig" },
  licenses = { "MIT" },
  schema = "registry+v1",
  ---@type RegistryPackageSource
  source = {
    -- NOTE: you can change this PURL here to modify where ZLS is cloned from,
    -- such as using a fork if the current main branch isn't up-to-date with Zig `master`
    id = "pkg:mason/zigtools/zls",
    ---@param ctx InstallContext
    ---@param purl Purl
    install = function(ctx, purl)
      local git_args = {
        "clone",
        ("https://github.com/%s/%s"):format(purl.namespace, purl.name),
        ".",
      }
      if purl.version then
        table.insert(git_args, ("--branch=%s"):format(purl.version))
      end

      if pcall(ctx.spawn.git, git_args) then
        ctx.stdio_sink:stdout "Finished cloning from GitHub.\n"
      else
        ctx.stdio_sink:stderr "Failed to clone from GitHub.\n"
        return
      end

      if pcall(run_build_instruction, ctx, {
        run = [[zig build -Doptimize=ReleaseSafe]],
      }) then
        ctx.stdio_sink:stderr "Finished building from source.\n"
      else
        ctx.stdio_sink:stderr "Failed to build from source.\n"
        return
      end
    end,
  },
  bin = {
    ["zls"] = "zig-out/bin/zls",
  },
}
