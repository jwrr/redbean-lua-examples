local session = {}

local cookie = require"cookie"



session.explode = function(sep, s)
  sep = sep or ' '
  s = s or ''
  local t = {}
  for piece in string.gmatch(s, "[^" .. sep .. "]+") do
    table.insert(t, piece)
  end
  return t
end

session.exec = function(cmd)
  local c = io.popen(cmd)
  local r = c:read("*a")
  c:close()
  return r
end


session.glob = function(glob_path, opt)
  glob_path = glob_path or ''
  opt = opt or ''
  local one_file_per_line = session.exec('ls ' .. opt .. ' ' .. glob_path .. ' 2> /dev/null')
  local file_table = session.explode('\r\n', one_file_per_line)
  return file_table
end



session.file_exists = function(filename)
  files = session.glob(filename)
  return #files > 0
end


-- function session.createTable(filename)
--     db = sqlite3.open(filename)
--     db:busy_timeout(1000)
--     db:exec[[PRAGMA journal_mode=WAL]]
--     db:exec[[PRAGMA synchronous=NORMAL]]
--     db:exec[[
--       CREATE TABLE IF NOT EXISTS Session (
--         id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
--         username TEXT,
--         expdate  INTEGER)
--     ]]
-- end
--
-- function session.setupSql(filename)
--   filename = filename or 'redbean.sqlite3'
--   if not db then
--     db = sqlite3.open(filename)
--     db:busy_timeout(1000)
--     db:exec[[PRAGMA journal_mode=WAL]]
--     db:exec[[PRAGMA synchronous=NORMAL]]
--
--     getSessionStmt = db:prepare[[
--       SELECT * FROM Session WHERE username = ?
--     ]]
--    end
-- end
--
-- local function GetBar(id)
--    if not getBarStmt then
--       Log(kLogWarn, 'prepare failed: ' .. db:errmsg())
--       return nil
--    end
--    getBarStmt:reset()
--    getBarStmt:bind(1, id)
--    for bar in getBarStmt:nrows() do
--       return bar
--    end
--    return nil
-- end



-- GLOBAL_SESSION_TABLE = {}

function session.getEntry(key)
  key = key or cookie.get() or 'invalid-key'
  f = io.open('sessions/session_' .. key, 'r')
  if f == nil then
    return {}
  end
  local multiLineString = f:read('*all')
  local lines = session.explode('\r\n', multiLineString)
  local name = lines[1] or 'Missing Username'
  local exp_str= lines[2] or '0'
  local expDate = tonumber(exp_str)
  t = {Name = name, ExpDate = expDate}
--  t = GLOBAL_SESSION_TABLE[key] or {} -- read
  return t or {}
end

function session.exists(key)
  key = key or cookie.get() or 'invalid-key'
  return session.file_exists('sessions/session_' .. key)
--   return session.getEntry(key) and true or false
end

function session.getKey(key)
  key = key or cookie.get() or 'invalid-key'
  return session.exists(key) and key or ''
end

function session.start(name, expPate)
  name = name or 'My Name'
  expDate = expDate or GetDate() + 7*24*3600
  local key = cookie.set()
  local t = {Name = name, ExpDate = expDate}
  print("START SESSION: ")
  local f = io.open('sessions/session_' .. key, 'w')
  if f == nil then
    return
  end
  f:write(t.Name .. "\n")
  f:write(tostring(t.ExpDate) .. "\n")
  f:close()
--   GLOBAL_SESSION_TABLE[key] = t -- write
end



function session.delete(key)
  key = key or cookie.get() or 'invalid-key'
  local s = session.getEntry(key)
  -- GLOBAL_SESSION_TABLE[key] = nil -- delete
  cmd = "rm -f session_" .. key
  local command_output = session.exec(cmd)
  return s
end

function session.isExpired(now, expDate)
  return now >= expDate
end

function session.isLoggedIn()
  if not cookie.exists() then
    return false
  end

  local sessionKey = cookie.get()
  if not session.exists(sessionKey) then
    return false
  end

  session_entry = session.getEntry(sessionKey)
  if session_entry == {} then
    return false
  end

  if session.isExpired(GetDate(), session_entry.ExpDate) then
    session.delete(key)
    return false
  end

  return true

end


function session.validPassword(password)
  return true -- FIXME
end


function session.page()

local username = HasParam('username') and GetParam('username') or ""
local password = HasParam('password') and GetParam('password') or ""

if username ~= "" and session.validPassword(password) then
  session.start(username)
  -- FIXME ServeRedirect(303, "/") -- 303 redirects are for handling form submissions
  return [[You are now logged in!!! <a href="/">Home</a>]]
end


html = [[
 <form action="/login" method="post">
  <div class="css-login-form">
    <label for="username">Username</label>
    <input type="text" placeholder="Enter Username" name="username" required>
    <label for="password">Password</label>
    <input type="password" placeholder="Enter Password" name="password" required>
    <button type="submit">Login</button>
  </div>
</form>
]]

return html
end


return session

