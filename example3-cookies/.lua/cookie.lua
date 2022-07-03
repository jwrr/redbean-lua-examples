local cookie = {}

function cookie.set(name, value, maxAge, secure, httpOnly, sameSite)
  name = name or "session-cookie"
  value = value or EncodeBase64(GetRandomBytes(48))
  maxAge = maxAge or 7*86400 -- default 1 week
  secure = secure or false -- FIXME CHANGE TO TRUE
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

