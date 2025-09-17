return {
  -- on_attach = require 'virtualtypes'.on_attach,
  filetypes = { "php", "blade" },
  init_options = {
    licenceKey = "REDACTED",
  },
  settings = {
    intelephense = {
      files = {
        maxSize = 1000000,
      },
    },
  },
}
