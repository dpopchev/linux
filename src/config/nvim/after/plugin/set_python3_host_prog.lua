local function set_python3_host_prog()
    local python = '.venv/bin/python'
    local is_present = os.execute('test -e ' .. python)
    if ( is_present == 0 ) then
        return python
    else
        return 'python3'
    end
end

vim.g.python3_host_prog = set_python3_host_prog()
