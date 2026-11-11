---@brief
---
--- https://github.com/fwcd/kotlin-language-server
---
--- `kotlin-language-server`, a language server for Kotlin. The project root is the
--- folder with the Gradle settings file, so the server reads the build and the dependencies.

---@type vim.lsp.Config
return {
  cmd = { 'intellij-server', '--stdio' },
  filetypes = { 'kotlin' },
  root_markers = {
      'settings.gradle.kts',
      'settings.gradle',
      'build.gradle.kts',
      'build.gradle',
      '.git',
  },
}
