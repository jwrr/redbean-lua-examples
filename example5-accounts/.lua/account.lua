local account = {}

sqlite3 = require 'lsqlite3'

function account.init(dbname, tablename)
  dbname = "redbean.sql"
  tablename = tablename or "accounts"
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
  tablename = tablename or "accounts"
  properties = properties or {}
  tablename = "accounts"
  query = [[
    INSERT INTO accounts (name, password, nonce, email) VALUES(  "]] ..
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


function account.verify(name, password, email, dbname, tablename)
  name = account.clean(name)
  if name == '' then return false end

  password = password or ''
  if password == '' then return false end

  local nonce = ""
  passwordHash = EncodeBase64(Sha512(nonce .. password))
  dbname = dbname or "redbean.sql"
  tablename = tablename or "accounts"
  properties = properties or {}
  tablename = "accounts"
  query = [[SELECT * FROM ]] .. tablename  .. [[ WHERE name = "]] .. name .. [[";]]
  local db = sqlite3.open(dbname)
  db:exec(query, account.verifypassword_callback, password)
  db:close()
  
  return account.GOODPASSWORD  
end


function account.update()
end

function account.delete()
end


function account.checkPassword(account, password)
end

function account.get(name)
end



return account
