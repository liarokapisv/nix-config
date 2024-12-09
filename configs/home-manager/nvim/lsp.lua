require 'lsp_key_mappings'
require 'cursor_hint'
require 'table_merge'

-- capabilities = require('cmp_nvim_lsp').default_capabilities()
nvim_lsp = require('lspconfig')

function add_lsp(server, options)
    options = options or {}

    default_options = {
        -- capabilities = capabilities,
        autostart = true,
        on_attach = function(_, bufnr)
            set_lsp_key_mappings(bufnr)
            set_cursor_hint()
        end,
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


function get_project_rustanalyzer_settings()
    local handle = io.open(vim.fn.resolve(vim.fn.getcwd() .. '/./.rust-analyzer.json'))
    if not handle then
        return {}
    end
    local out = handle:read("*a")
    handle:close()
    local config = vim.json.decode(out)
    if type(config) == "table" then
        return config
    end
    return {}
end

add_lsp("rust_analyzer", {
    executable = "rust-analyzer",
    settings = {
        ['rust-analyzer'] = get_project_rustanalyzer_settings(),
    }
})

add_lsp("clangd", 
    (vim.fn.executable("clang-format") == 1) and 
    {
        on_attach = function(_, bufnr)
            set_lsp_key_mappings(bufnr)
            set_cursor_hint()
            -- use environment clang-format instead of embedded one.
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>write | silent !clang-format -i %<cr>', { noremap=true, silent=true })
        end,
    } or {}
)

add_lsp("pyright")

add_lsp("jdtls")

add_lsp("terraformls", {
    executable = "terraform-ls",
    filetypes = { "tf", "terraform", }
})

add_lsp("standardrb", {
    filetypes = { "ruby", "eruby" }
})

add_lsp("ts_ls", {
    executable = "typescript-language-server";
})

add_lsp("astro", {
    executable = "astro-ls";
})

-- Setup through the tailwindcss-tools plugin
--
-- add_lsp("tailwindcss", {
--     executable = "tailwindcss-language-server";
-- })

add_lsp("markdown_oxide", {
    executable = "markdown-oxide";
})
