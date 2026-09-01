return {
    cmd = function(dispatchers, root_dir)
        local marker = root_dir and (root_dir .. "/.zls-bin")
        local path = "zls"
        if marker and vim.fn.filereadable(marker) == 1 then
            path = vim.fn.trim(vim.fn.readfile(marker)[1])
        end
        return vim.lsp.rpc.start(path, {}, dispatchers)
    end
}
