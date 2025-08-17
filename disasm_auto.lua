-- Auto-updating disassembly view for nvim-dap / dap-ui
-- Reuses a single buffer/window to avoid spawning many splits.
-- Usage: require("debug.disasm_auto").setup({ enable = true })

local M = {}

local function notify(msg, level) vim.notify("[disasm] " .. msg, level or vim.log.levels.INFO) end

local ok_dap, dap = pcall(require, "dap")
if not ok_dap then
  notify("nvim-dap not found; module disabled", vim.log.levels.WARN)
  dap = nil
end

local ns = vim.api.nvim_create_namespace("disasm_auto_ns")

-- STATE: remember single buffer id and optional window id
local state = {
  bufnr = nil,
  winid = nil,
  enabled = false,
}

-- Helper: is buffer still valid?
local function buf_valid(bufnr)
  return bufnr and vim.api.nvim_buf_is_valid(bufnr)
end

-- Helper: is window still valid and showing our buffer?
local function win_valid_with_buf(winid, bufnr)
  if not winid or not vim.api.nvim_win_is_valid(winid) then return false end
  local wbuf = vim.api.nvim_win_get_buf(winid)
  return wbuf == bufnr
end

-- create or reuse buffer + window; returns bufnr, winid
local function open_or_reuse_window(title)
  -- If bufnr exists but was wiped, clear it
  if state.bufnr and not buf_valid(state.bufnr) then
    state.bufnr = nil
    state.winid = nil
  end

  -- If there is a valid window showing our buffer, return it
  if state.winid and win_valid_with_buf(state.winid, state.bufnr) then
    return state.bufnr, state.winid
  end

  -- If buffer exists but not visible, reuse it in a new split
  if state.bufnr and buf_valid(state.bufnr) then
    -- open a vertical split and set buffer
    vim.cmd("vsplit")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, state.bufnr)
    state.winid = win
    -- ensure it's listed as a scratch name
    if title then vim.api.nvim_buf_set_name(state.bufnr, "disasm://" .. title) end
    return state.bufnr, state.winid
  end

  -- else create a new scratch buffer and window
  vim.cmd("vnew")
  local bufnr = vim.api.nvim_get_current_buf()
  state.bufnr = bufnr
  state.winid = vim.api.nvim_get_current_win()

  -- buffer options for scratch/asm
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, {})
  vim.bo[bufnr].buftype = "nofile"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].swapfile = false
  vim.bo[bufnr].filetype = "asm"
  if title then vim.api.nvim_buf_set_name(bufnr, "disasm://" .. title) end

  return state.bufnr, state.winid
end

-- close and wipe the disasm buffer/window
function M.close()
  if state.winid and vim.api.nvim_win_is_valid(state.winid) then
    -- close the window (this will not wipe the buffer if bufhidden ~= wipe)
    pcall(vim.api.nvim_win_close, state.winid, true)
    state.winid = nil
  end
  if state.bufnr and buf_valid(state.bufnr) then
    -- wipe the buffer
    pcall(vim.api.nvim_buf_delete, state.bufnr, { force = true })
    state.bufnr = nil
  end
end

-- Render lines into the reused buffer; highlight & move cursor to addr line if possible
local function show_lines(lines, title, highlight_addr)
  local bufnr, winid = open_or_reuse_window(title)
  if not buf_valid(bufnr) then
    notify("failed to create disasm buffer", vim.log.levels.ERROR); return
  end

  -- set contents efficiently
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  -- update buffer name if provided
  if title then pcall(vim.api.nvim_buf_set_name, bufnr, "disasm://" .. title) end

  -- clear old highlights
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  -- try to find highlight line from address
  if highlight_addr then
    local addr = tostring(highlight_addr)
    local addr_forms = {}
    if addr:match("^0x") then
      table.insert(addr_forms, addr)
      table.insert(addr_forms, addr:lower())
      table.insert(addr_forms, addr:upper())
      table.insert(addr_forms, addr:gsub("^0x0+", "0x"))
      table.insert(addr_forms, addr:gsub("^0x", ""))
    else
      table.insert(addr_forms, addr)
      table.insert(addr_forms, "0x" .. addr)
    end

    local found_line = nil
    for i, line in ipairs(lines) do
      for _, a in ipairs(addr_forms) do
        if line:find(a, 1, true) then found_line = i; break end
      end
      if found_line then break end
    end

    if found_line then
      -- if our disasm window is not focused, switch focus there so cursor movement is visible
      if not state.winid or not vim.api.nvim_win_is_valid(state.winid) then
        -- nothing to do
      else
        pcall(vim.api.nvim_set_current_win, state.winid)
      end
      -- move cursor (line, col) and add highlight
      pcall(vim.api.nvim_win_set_cursor, 0, { found_line, 0 })
      vim.api.nvim_buf_add_highlight(bufnr, ns, "Visual", found_line - 1, 0, -1)
    end
  end

  -- ensure top of buffer visible
  pcall(vim.cmd, "normal! zz")
end

-- (Reused) helper functions from previous module: render_dap_response & fallback objdump
local function render_dap_response(resp)
  if not resp then return { "<no response>" } end
  local body = resp.body or resp
  local lines = {}
  if body.instructions then
    if type(body.instructions) == "string" then
      for l in vim.gsplit(body.instructions, "\n", true) do table.insert(lines, l) end
    elseif type(body.instructions) == "table" then
      for _, instr in ipairs(body.instructions) do
        if type(instr) == "string" then table.insert(lines, instr)
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

local function fallback_objdump_extract(funcname, program_path)
  if not program_path or program_path == "" then
    program_path = vim.fn.input("Binary path for objdump: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
    if program_path == "" then return nil end
  end
  local cmd = "llvm-objdump -d --no-show-raw-insn " .. vim.fn.shellescape(program_path)
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or #out == 0 then
    cmd = "objdump -d --no-show-raw-insn " .. vim.fn.shellescape(program_path)
    out = vim.fn.systemlist(cmd)
  end
  if vim.v.shell_error ~= 0 or #out == 0 then
    notify("objdump/llvm-objdump failed or not found", vim.log.levels.ERROR)
    return nil, program_path
  end

  if funcname and funcname ~= "" then
    local start_i
    for i, line in ipairs(out) do
      if line:match("<" .. vim.pescape(funcname) .. ">:") or line:match("%s" .. vim.pescape(funcname) .. ":$") or line:match("^" .. vim.pescape(funcname) .. ":$") then
        start_i = i
        break
      end
    end
    if not start_i then return out, program_path end
    local stop_i
    for j = start_i + 1, #out do
      if out[j]:match("<.+>:$") or out[j]:match("^%w+:$") then stop_i = j - 1; break end
    end
    stop_i = stop_i or #out
    local slice = {}
    for k = start_i, stop_i do table.insert(slice, out[k]) end
    return slice, program_path
  end
  return out, program_path
end

-- extract an address (PC) from DAP frame (try multiple common fields)
local function extract_address_from_frame(frame)
  if not frame then return nil end
  if frame.instructionPointerReference then return frame.instructionPointerReference end
  if frame.address then return frame.address end
  if frame.loadAddress then return frame.loadAddress end
  if frame.raw and frame.raw.address then return frame.raw.address end
  if frame.presentationHint and frame.presentationHint.address then return frame.presentationHint.address end
  return nil
end

-- Core: try adapter disassemble, fallback to objdump, then show via show_lines()
function M.show_with_fallback(session, args, program_path)
  if not dap then notify("dap not available", vim.log.levels.WARN); return end
  if not session then session = dap.session() end
  if not session then notify("no active dap session", vim.log.levels.WARN); return end
  args = args or {}

  session:request("disassemble", args, function(err, resp)
    if not err then
      local lines = render_dap_response(resp)
      local addr = args.startAddress or args.address or args.instructionAddress
      if not addr and resp and resp.body and resp.body.instructions and type(resp.body.instructions) == "table" and resp.body.instructions[1] and resp.body.instructions[1].address then
        addr = resp.body.instructions[1].address
      end
      show_lines(lines, "dap-disasm", addr)
      return
    end

    -- fallback
    notify("adapter disassemble failed: " .. tostring(err.message or vim.inspect(err)) .. " — falling back to objdump", vim.log.levels.WARN)
    local bin = program_path
    if not bin and session.config and session.config.program and type(session.config.program) == "string" then bin = session.config.program end
    local lines, used_bin = fallback_objdump_extract(args.name, bin)
    if not lines then notify("objdump fallback failed", vim.log.levels.ERROR); return end

    local addr = args.startAddress or args.__frame_addr_hint
    show_lines(lines, "objdump:" .. (used_bin or "binary"), addr)
  end)
end

-- get current top frame and disassemble around it
function M.disasm_for_current_frame(event_body)
  if not dap then return end
  local session = dap.session()
  if not session then return end

  local threadId = event_body and (event_body.threadId or event_body.threadId) or nil

  local function request_stack_and_disasm(tid)
    if not tid then
      session:request("threads", {}, function(err, resp)
        if err or not resp or not resp.body or not resp.body.threads or #resp.body.threads == 0 then
          M.show_with_fallback(session, {}, session.config and session.config.program or nil)
          return
        end
        request_stack_and_disasm(resp.body.threads[1].id)
      end)
      return
    end

    session:request("stackTrace", { threadId = threadId or tid, startFrame = 0, levels = 1 }, function(err, resp)
      if err or not resp or not resp.body or not resp.body.stackFrames or #resp.body.stackFrames == 0 then
        M.show_with_fallback(session, {}, session.config and session.config.program or nil)
        return
      end

      local frame = resp.body.stackFrames[1]
      local addr = extract_address_from_frame(frame)
      local name = frame.name
      local dis_args = {}
      if addr then dis_args.startAddress = addr; dis_args.instructionCount = 80; dis_args.__frame_addr_hint = addr
      elseif name and name ~= "" then dis_args.name = name end

      M.show_with_fallback(session, dis_args, session.config and session.config.program or nil)
    end)
  end

  request_stack_and_disasm(threadId)
end

-- Auto listener toggle
local listeners_id = "disasm_auto_listeners"
function M.enable_auto()
  if not dap then notify("dap not found", vim.log.levels.WARN); return end
  if state.enabled then return end
  dap.listeners.after.event_stopped = dap.listeners.after.event_stopped or {}
  dap.listeners.after.event_stopped[listeners_id] = function(session, body)
    M.disasm_for_current_frame(body)
  end
  state.enabled = true
  notify("auto-disasm enabled")
end

function M.disable_auto()
  if not dap or not state.enabled then return end
  if dap.listeners and dap.listeners.after and dap.listeners.after.event_stopped then
    dap.listeners.after.event_stopped[listeners_id] = nil
  end
  state.enabled = false
  notify("auto-disasm disabled")
end

function M.toggle_auto()
  if state.enabled then M.disable_auto() else M.enable_auto() end
end

-- prompt + manual
function M.prompt_and_show()
  local choice = vim.fn.input("Disassemble by (n)ame / (a)ddress / (c)urrent frame ? [n/a/c]: ")
  if choice == "n" then
    local name = vim.fn.input("Function name: ")
    if name == "" then return end
    M.show_with_fallback(dap and dap.session() or nil, { name = name }, dap and dap.session() and dap.session().config and dap.session().config.program)
  elseif choice == "a" then
    local addr = vim.fn.input("Start address (hex, e.g. 0x400500): ")
    local cnt  = vim.fn.input("Instruction count (empty for default): ")
    local args = {}
    if addr ~= "" then args.startAddress = addr end
    if cnt ~= "" then args.instructionCount = tonumber(cnt) end
    M.show_with_fallback(dap and dap.session() or nil, args, dap and dap.session() and dap.session().config and dap.session().config.program)
  else
    M.disasm_for_current_frame()
  end
end

-- setup: call from your config; sets keymaps and optional auto enable
function M.setup(opts)
  opts = opts or {}
  if opts.enable then M.enable_auto() end
  local map = opts.map or {}
  local df = map.auto_toggle or "<Leader>df"
  local da = map.prompt or "<Leader>da"
  local dc = map.close or "<Leader>dc"
  vim.keymap.set("n", df, function() M.toggle_auto() end, { noremap = true, silent = true, desc = "auto disasm"})
  vim.keymap.set("n", da, function() M.prompt_and_show() end, { noremap = true, silent = true, desc = "Start disasm" })
  vim.keymap.set("n", dc, function() M.close() end, { noremap = true, silent = true, desc = "Close disasm" })
  notify("disasm_auto setup complete (keys: " .. df .. ", " .. da .. ", " .. dc .. ")")
end

return M
