return {
  -- on_attach = require 'virtualtypes'.on_attach,
  filetypes = { "php", "blade" },
  init_options = {
    licenceKey = os.getenv("INTELEPHENSE_LICENSE_KEY"),
  },
  settings = {
    intelephense = {
      files = {
        maxSize = 1000000,
      },
    },
  },
}
