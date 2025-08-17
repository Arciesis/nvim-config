local M = {}

local ok, dap = pcall(require, "dap")
if not ok then
  vim.notify("nvim-dap not found (debug.disasm)", vim.log.levels.WARN)
  dap = nil
end

local function show_buf(lines, title)
  vim.cmd("vnew")
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "asm"
  if title then
    vim.api.nvim_buf_set_name(bufnr, "disasm://" .. title)
  end
  vim.cmd("normal! gg")
end

local function render_dap_response(resp)
  if not resp then return { "<no response>" } end
  local body = resp.body or resp
  local lines = {}

  if body.instructions then
    if type(body.instructions) == "string" then
      for l in vim.gsplit(body.instructions, "\n", true) do table.insert(lines, l) end
    elseif type(body.instructions) == "table" then
      for _, instr in ipairs(body.instructions) do
        if type(instr) == "string" then
          table.insert(lines, instr)
        else
          local text = instr.text or instr.instruction or (instr.address and (instr.address .. ": " .. vim.inspect(instr)))
          table.insert(lines, text or vim.inspect(instr))
        end
      end
    end
  elseif body.disassembly then
    for l in vim.gsplit(body.disassembly, "\n", true) do table.insert(lines, l) end
  else
    table.insert(lines, vim.inspect(resp))
  end

  return lines
end

local function fallback_objdump(funcname, program_path)
  -- ensure program path
  if not program_path or program_path == "" then
    program_path = vim.fn.input("Binary path for objdump: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
    if program_path == "" then
      vim.notify("No binary path provided for objdump", vim.log.levels.WARN)
      return nil
    end
  end

  -- prefer llvm-objdump, fall back to objdump
  local cmd = "llvm-objdump -d --disassemble --no-show-raw-insn " .. vim.fn.shellescape(program_path)
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or #out == 0 then
    cmd = "objdump -d --no-show-raw-insn " .. vim.fn.shellescape(program_path)
    out = vim.fn.systemlist(cmd)
  end
  if vim.v.shell_error ~= 0 then
    vim.notify("objdump failed (is llvm-objdump or objdump installed?)", vim.log.levels.ERROR)
    return nil
  end

  if funcname and funcname ~= "" then
    -- try to extract the function block: find the line with '<funcname>:' then capture until next function label '<...>:'
    local start_i, stop_i
    for i, line in ipairs(out) do
      if line:match("<" .. vim.pescape(funcname) .. ">:") then
        start_i = i
        break
      end
    end
    if not start_i then
      -- try pattern without angle brackets (some objdump variants)
      for i, line in ipairs(out) do
        if line:match("%s" .. vim.pescape(funcname) .. ":$") or line:match("^" .. vim.pescape(funcname) .. ":$") then
          start_i = i
          break
        end
      end
    end
    if not start_i then
      -- function not found — return full dump (user can search)
      return out
    end
    for j = start_i + 1, #out do
      -- next function header usually contains '<.*>:' or a bare label at line end
      if out[j]:match("<.+>:$") or out[j]:match("^%w+:$") then
        stop_i = j - 1
        break
      end
    end
    stop_i = stop_i or #out
    local slice = {}
    for k = start_i, stop_i do table.insert(slice, out[k]) end
    return slice
  end

  return out
end

function M.show(args)
  if not dap then vim.notify("dap not available", vim.log.levels.WARN); return end
  local session = dap.session()
  if not session then vim.notify("No active debug session", vim.log.levels.WARN); return end

  args = args or {}

  -- attempt DAP disassemble request
  session:request("disassemble", args, function(err, resp)
    if not err then
      local lines = render_dap_response(resp)
      show_buf(lines, "dap-disasm")
      return
    end

    -- handle error -> fallback
    local msg = tostring(err and err.message or vim.inspect(err))
    vim.notify("disassemble error: " .. msg .. " — falling back to objdump", vim.log.levels.WARN)

    -- decide binary path: prefer session.config.program (if available)
    local program_path = nil
    if session.config and session.config.program then
      program_path = session.config.program
      -- sometimes program in config is a function; handle only if string
      if type(program_path) == "function" then program_path = nil end
    end

    local funcname = args.name
    -- fallback to objdump (may be slow for large binaries)
    local out = fallback_objdump(funcname, program_path)
    if not out then
      vim.notify("Fallback objdump produced no output", vim.log.levels.ERROR)
      return
    end
    show_buf(out, "objdump")
  end)
end

function M.prompt_and_show()
  local choice = vim.fn.input("Disassemble by (n)ame / (a)ddress / (c)urrent frame ? [n/a/c]: ")
  if choice == "n" then
    local name = vim.fn.input("Function name: ")
    if name == "" then return end
    M.show({ name = name })
  elseif choice == "a" then
    local addr = vim.fn.input("Start address (hex, e.g. 0x400500): ")
    local cnt  = vim.fn.input("Instruction count (empty for default): ")
    local args = {}
    if addr ~= "" then args.startAddress = addr end
    if cnt ~= "" then args.instructionCount = tonumber(cnt) end
    M.show(args)
  else
    M.show()
  end
end

return M
