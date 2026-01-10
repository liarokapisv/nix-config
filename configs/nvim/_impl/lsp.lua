require 'lsp_key_mappings'
require 'cursor_hint'
require 'table_merge'

function add_lsp(server, options)
    options = options or {}

    local user_on_attach = options.on_attach

    options.on_attach = function(client, bufnr)
        set_lsp_key_mappings(bufnr)
        set_cursor_hint()
        if user_on_attach then
            user_on_attach(client, bufnr)
        end
    end

    default_options = {
        autostart = true,
        flags = {
            debounce_text_changes = 150,
        },
    }

    final_options = table_merge(default_options, options)

    executable = final_options["executable"] or server

    if vim.fn.executable(executable) == 1 then
        vim.lsp.config(server, final_options)
        vim.lsp.enable(server, final_options)
    end
end

add_lsp("nil_ls", table_merge(
        (vim.fn.executable("nixfmt") == 1) and {
            settings = {
                ['nil'] = {
                    formatting = {
                        command = { "nixfmt" },
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
    },
})

add_lsp("clangd",
    (vim.fn.executable("clang-format") == 1) and
    {
        on_attach = function(_, bufnr)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>write | silent !clang-format -i %<cr>', { noremap=true, silent=true })
        end,
    } or {}
)

add_lsp("pyright")

add_lsp("jdtls")

add_lsp("terraformls", {
    executable = "terraform-ls",
    filetypes = { "tf", "terraform", },
    init_options = {
        ignoreSingleFileWarning = true
    }
})

add_lsp("standardrb", {
    filetypes = { "ruby", "eruby" }
})

add_lsp("ts_ls", {
    executable = "typescript-language-server";
})

add_lsp("svelte", {
    executable = "svelteserver";
})

add_lsp("astro", {
    executable = "astro-ls";
})

add_lsp("gopls")

-- Setup through the tailwindcss-tools plugin
--
-- add_lsp("tailwindcss", {
--     executable = "tailwindcss-language-server";
-- })

add_lsp("markdown_oxide", {
    executable = "markdown-oxide";
})
