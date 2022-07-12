local session = {}

local unix = require"unix"
local cookie = require"cookie"
local account = require"account"


session.exec = function(cmd)
  local c = io.popen(cmd)
  local r = c:read("*a")
  c:close()
  return r
end


function session.fileExists(filename)
  f = io.open(filename, "r")
  if f == nil then
    return false
  end
  f:close()
  return true
end


function session.deleteFile(filename)
  unix.unlink(filename)
--   cmd = "rm -f " .. filename
--   local command_output = session.exec(cmd)
end


function session.split(sep, s)
  sep = sep or ' '
  s = s or ''
  local t = {}
  for piece in string.gmatch(s, "[^" .. sep .. "]+") do
    table.insert(t, piece)
  end
  return t
end


function session.entry(key)
  key = key or cookie.get() or 'invalid-key'
  f = io.open('sessions/session_' .. key, 'r')
  if f == nil then
    return {}
  end
  local multiLineString = f:read('*all')
  local lines = session.split('\r\n', multiLineString)
  local name = lines[1] or 'Missing Username'
  local exp_str= lines[2] or '0'
  local exp = tonumber(exp_str)
  t = {Name = name, Exp = exp}
  return t or {}
end


function session.exists(key)
  key = key or cookie.get() or 'invalid-key'
  return session.fileExists('sessions/session_' .. key)
end


function session.key()
  local key = cookie.get() or 'invalid-key'
  return session.exists(key) and key or ''
end


function session.start(name, exp)
  name = name or 'My Name'
  exp = exp or GetDate() + 7*24*3600
  local key = cookie.set()
  local t = {Name = name, Exp = exp}
  print("START SESSION: ")
  local f = io.open('sessions/session_' .. key, 'w')
  if f == nil then
    return
  end
  f:write(t.Name .. "\n")
  f:write(tostring(t.Exp) .. "\n")
  f:close()
end


function session.stop(key)
  key = key or cookie.get() or 'invalid-key'
  local s = session.entry(key)
  local filename = "sessions/session_" .. key
  session.deleteFile(filename)
  return s
end


function session.exp(sess, now)
  now = now or GetDate()
  local exp = sess.Exp or 0
  return now >= exp
end


function session.active(key)
  key = key or cookie.get()

  sess = session.entry(key)
  if sess == {} then
    return false
  end

  if session.exp(sess) then
    session.stop()
    return false
  end

  return true

end


function session.validPassword(username, password)
  return account.verify(username, password)
end


function session.page(logout)
if logout then
  session.stop()
  html = [[
  <div class="css-logout">You are now logged out. <a href="/">Home</a></div>
  ]]
  return html
end

local username = HasParam('username') and GetParam('username') or ""
local password = HasParam('password') and GetParam('password') or ""

if username ~= "" and session.validPassword(username, password) then
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

