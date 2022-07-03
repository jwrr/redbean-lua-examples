local dynamic = {}

-- This module defines the three functions needed by .init.lua to serve
-- a dynamic page.

-- The cookie module wraps the Redbean's GetCookie and SetCookie

local cookie = require"cookie"


-- function that returns true if the path is a valid dynamic page.
function dynamic.isValidDynamicPath()

  -- get the path from redbean. All paths start with '/', even the home page.
  local path = GetPath()
  
  -- The '^' and '$' are lua pattern anchors for start of string and end of
  -- string, respectively (same as perl regex).
  
  -- This pattern matches the home page, '/'
  if path:find('^/$') then return true end
  
  -- This pattern matches any path starting with '/one'
  if path:find('^/one') then return true end
  
  -- This pattern matches any path starting with '/two'
  if path:find('^/two') then return true end
  
  -- For this example, any other path is not valid
  return false;
end



-- function that returns html string containing the webpage content
function dynamic.page()

  local old_cookie = cookie.get()
  
  local new_cookie = "No Change"
  if not cookie.exists() then
    new_cookie = cookie.set()
--  new_cookie = EncodeBase64(GetRandomBytes(48))
--  local t = { MaxAge = 7*86400, Secure = false, HttpOnly = true, SameSite = "Lax" }
--  SetCookie('myCookie', new_cookie, t)
  end
  
  -- Example to get parameger p. /one?p=123
  local p = HasParam('p') and GetParam('p') or "not set"
  return "This is dynamic content for page " .. GetPath() .. ". Parameter 'p' is " .. p .. "<br>old_cookie = " .. old_cookie .. "<br>new_cookie=" .. new_cookie
end


-- function that returns html string containing a custom error page
dynamic.err404 = {}
function dynamic.err404.page()
  return "Error 404: Not Found: " .. GetPath()
end

return dynamic

