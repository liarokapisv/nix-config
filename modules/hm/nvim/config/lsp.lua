require 'lsp_key_mappings'
require 'cursor_hint'
require 'table_merge'

nvim_lsp = require 'lspconfig'

function add_lsp(server, options)
    options = options or {}

    default_options = {
        autostart = true,
        on_attach = function(_, bufnr)
            set_lsp_key_mappings(bufnr)
            set_cursor_hint()
        end,
        root_dir = nvim_lsp.util.root_pattern(".git"),
        flags = {
            debounce_text_changes = 150,
        },
    }

    final_options = table_merge(default_options, options)

    executable = final_options["executable"] or server

    if vim.fn.executable(executable) == 1 then 
        nvim_lsp[server].setup(final_options)
    end
end

add_lsp("nil_ls", table_merge(
        (vim.fn.executable("nixpkgs-fmt") == 1) and {
            settings = {
                ['nil'] = {
                    formatting = {
                        command = { "nixpkgs-fmt" },
                    },
                },
            },
        } or {},
        {
            executable = "nil"
        }))

add_lsp("rust_analyzer")
add_lsp("clangd")
add_lsp("pyright")
add_lsp("jdtls")

add_lsp("standardrb", {
    filetypes = { "ruby", "eruby" }
})
