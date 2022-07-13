local account = {}

sqlite3 = require 'lsqlite3'

function account.init(dbname, tablename)
  dbname = "redbean.sql"
  tablename = tablename or "account"
  query= [[CREATE TABLE IF NOT EXISTS ]] .. tablename .. [[(
    id       INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name     TEXT,
    password TEXT,
    nonce    TEXT,
    email    TEXT
  )]]
  local db = sqlite3.open(dbname)
  db:exec(query)
  db:close()
end


function account.clean(name)
  name = name or ''
  local origName = name
  local cleanName = name:gsub('[^a-zA-Z0-9_ -]','')
  if origName ~= cleanName then
    cleanName = ''
  end
  return cleanName
end


function account.randomstring()
  len = len or 32
  local s = EncodeBase64(GetRandomBytes(64))
  s = s:gsub('[^a-zA-z0-9]', '')
  return s
end


function account.create(name, password, email, dbname, tablename)
  name = account.clean(name)
  if name == '' then return false end

  password = password or ''
  if password == '' then return false end

  email = email or ''

  local nonce = account.randomstring(32)
  local passwordHash = EncodeBase64(Sha512(nonce .. password))
  dbname = dbname or "redbean.sql"
  tablename = tablename or "account"
  properties = properties or {}
  tablename = "account"
  query = [[
    INSERT INTO account (name, password, nonce, email) VALUES(  "]] ..
    name .. [[", "]] ..
    passwordHash .. [[", "]] ..
    nonce .. [[", "]] ..
    email .. [[");]]
  local db = sqlite3.open(dbname)
  db:exec(query)
  db:close()
  return true
end


function account.verifypassword_callback(password,cols,values,names)
  local nameFromDb = ''
  local passwordFromDb = ''
  local nonceFromDb = ''
  local emailFromDb = ''
  for i=1,cols do
    if names[i] == 'name' then nameFromDb = values[i] end
    if names[i] == 'password' then passwordFromDb = values[i] end
    if names[i] == 'nonce' then nonceFromDb = values[i] end
    if names[i] == 'email' then emailFromDb = values[i] end
  end

  local passwordHash = EncodeBase64(Sha512(nonceFromDb .. password))
  account.GOODPASSWORD = passwordHash == passwordFromDb

  return 0
end


function account.verify(name, password, dbname, tablename)
  name = account.clean(name)
  if name == '' then return false end

  password = password or ''
  if password == '' then return false end

  email = email or ""

  local nonce = ""
  passwordHash = EncodeBase64(Sha512(nonce .. password))
  dbname = dbname or "redbean.sql"
  tablename = tablename or "account"
  tablename = "account"
  query = [[SELECT * FROM ]] .. tablename  .. [[ WHERE name = "]] .. name .. [[";]]
  local db = sqlite3.open(dbname)
  account.GOODPASSWORD = false
  db:exec(query, account.verifypassword_callback, password)
  db:close()

  return account.GOODPASSWORD
end


function account.update(name, password, email, dbname, tablename)
  dbname = dbname or "redbean.sql"
  tablename = tablename or "account"

  name = account.clean(name)
  if name == '' then return false end

  password = password or ''
  if password == '' then return false end

  email = email or ""

  local goodPassword = account.verify(name, password, dbname, tablename)
  if not goodPassword then return false end

  query = [[UPDATE ]] .. tablename .. [[ SET ]] ..
    [[email    = ']] .. email    .. [[' ]] ..
    [[WHERE name = ']] .. name .. [[';]]

--     [[password = ']] .. password .. [[', ]] ..
--     [[nonce    = ']] .. nonce    .. [[', ]] ..


  local db = sqlite3.open(dbname)
  local result = db:exec(query)
  db:close()
  return result == sqlite3.OK
end


function account.delete(name, password, email, dbname, tablename)
  dbname = dbname or "redbean.sql"
  tablename = tablename or "account"

  name = account.clean(name)
  if name == '' then return false end

  password = password or ''
  if password == '' then return false end

  email = email or ""

  local goodPassword = account.verify(name, password, dbname, tablename)
  if not goodPassword then return false end

  query = [[DELETE FROM ]] .. tablename  .. [[ WHERE name = "]] .. name .. [[";]]
  local db = sqlite3.open(dbname)
  local result = db:exec(query)
  db:close()
  return result == sqlite3.OK
end


function account.checkPassword(account, password)
end

function account.get(name)
end


function account.joinPage()

-- if session.active() then
--   html = "Hello. No need to join... You're already logged in'"
-- end
local username = HasParam('username') and GetParam('username') or ''
local password = HasParam('password') and GetParam('password') or ''
local email    = HasParam('email')    and GetParam('email')    or ''

if username ~= "" and session.validPassword(username, password) then
  session.start(username)
  -- FIXME ServeRedirect(303, "/") -- 303 redirects are for handling form submissions
  return [[You are now logged in!!! <a href="/">Home</a>]]
end

html = [[
 <form action="/join" method="post">
  <div class="css-login-form">
    <label for="username">Username</label>
    <input type="text" placeholder="Enter Username" name="username" required>
    <label for="email">Email</label>
    <input type="text" placeholder="Enter Email" name="email" required>
    <label for="password">Password</label>
    <input type="password" placeholder="Enter Password" name="password" required>
    <button type="submit">Login</button>
  </div>
</form>
]]

return html
end




return account
