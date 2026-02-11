return {
  {
    "b0o/schemastore.nvim",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/schemastore.nvim",
    },
    opts = {
      servers = {
        intelephense = {
          settings = {
            intelephense = {
              files = {
                maxSize = 5000000,
                associations = { "*.php", "*.phtml" },
                exclude = {
                  "**/.git/**",
                  "**/.svn/**",
                  "**/.hg/**",
                  "**/CVS/**",
                  "**/.DS_Store/**",
                  "**/node_modules/**",
                  "**/bower_components/**",
                  "**/vendor/**/{Tests,tests}/**",
                  "**/.history/**",
                  "**/vendor/**/vendor/**",
                },
              },
              environment = {
                includePaths = {},
              },
              stubs = {
                "apache",
                "bcmath",
                "bz2",
                "calendar",
                "com_dotnet",
                "Core",
                "ctype",
                "curl",
                "date",
                "dba",
                "dom",
                "enchant",
                "exif",
                "fileinfo",
                "filter",
                "fpm",
                "ftp",
                "gd",
                "hash",
                "iconv",
                "imap",
                "interbase",
                "intl",
                "json",
                "ldap",
                "libxml",
                "mbstring",
                "mcrypt",
                "meta",
                "mssql",
                "mysqli",
                "oci8",
                "odbc",
                "openssl",
                "pcntl",
                "pcre",
                "PDO",
                "pdo_ibm",
                "pdo_mysql",
                "pdo_pgsql",
                "pdo_sqlite",
                "pgsql",
                "Phar",
                "posix",
                "pspell",
                "readline",
                "recode",
                "Reflection",
                "regex",
                "session",
                "shmop",
                "SimpleXML",
                "snmp",
                "soap",
                "sockets",
                "sodium",
                "SPL",
                "sqlite3",
                "standard",
                "superglobals",
                "sybase",
                "sysvmsg",
                "sysvsem",
                "sysvshm",
                "tidy",
                "tokenizer",
                "wddx",
                "xml",
                "xmlreader",
                "xmlrpc",
                "xmlwriter",
                "Zend OPcache",
                "zip",
                "zlib",
                "wordpress",
                "phpunit",
              },
              completion = {
                insertUseDeclaration = true,
                fullyQualifyGlobalConstantsAndFunctions = false,
                triggerParameterHints = true,
                maxItems = 100,
              },
              format = {
                enable = true,
              },
              diagnostics = {
                enable = true,
              },
            },
          },
        },
        tailwindcss = {},
        vtsls = {},
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              schemas = {},
              validate = { enable = true },
            },
          },
        },
        html = {
          filetypes = { "html", "blade" },
          settings = {
            html = {
              format = {
                enable = true,
                wrapLineLength = 120,
                wrapAttributes = "auto",
              },
              hover = {
                documentation = true,
                references = true,
              },
              suggest = {
                html5 = true,
              },
            },
          },
          init_options = {
            provideFormatter = true,
            embeddedLanguages = {
              javascript = true,
            },
            configurationSection = { "html" },
            dataPaths = {
              vim.fn.stdpath("config") .. "/alpine-html-data.json",
            },
          },
        },
        cssls = {},
        vue_ls = {
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
        },
        clojure_lsp = {
          settings = {
            clojure = {
              -- Enable semantic tokens
              semanticTokens = {
                enable = true,
              },
              -- Cljfmt formatting options
              cljfmt = {
                enable = true,
              },
              -- Performance settings
              linters = {
                ["clj-kondo"] = {
                  enabled = true,
                },
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
              },
            },
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "intelephense",
        "tailwindcss-language-server",
        "vtsls",
        "json-lsp",
        "html-lsp",
        "css-lsp",
        "vue-language-server",
        "clojure-lsp",
        "pyright",
        "prettier",
        "eslint_d",
        "black",
        "isort",
        "ruff",
        "debugpy",
      },
    },
  },
}
