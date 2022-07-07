local cookie = {}


function cookie.randomString()
  len = len or 64
  local s = EncodeBase64(GetRandomBytes(64))
  s = s:gsub('[^a-zA-z0-9]', '')
  return s
end


function cookie.set(name, value, maxAge, secure, httpOnly, sameSite)
  name = name or "session-cookie"
  value = value or cookie.randomString(64)
  maxAge = maxAge or 7*86400 -- default 1 week
  secure = secure or false -- FIXME CHANGE TO true
  httpOnly = httpOnly or true
  sameSite = sameSite or "Lax" -- "Strict", "Lax", "None"
  local options = {MaxAge = maxAge, Secure = secure, HttpOnly = httpOnly, SameSite = sameSite}
  SetCookie(name, value, options)
  return value
end

function cookie.get(name)
  name = name or "session-cookie"
  return GetCookie(name) or ''
end

function cookie.exists(name)
  name = name or "session-cookie"
  return GetCookie(name) and true or false
end

return cookie

