local dynamic = {}

-- This module defines the three functions needed by .init.lua to serve
-- a dynamic page.

-- The cookie module wraps the Redbean's GetCookie and SetCookie

local session = require"session"


-- function that returns true if the path is a valid dynamic page.
function dynamic.isValidDynamicPath()

  -- get the path from redbean. All paths start with '/', even the home page.
  local path = GetPath()
  
  -- The '^' and '$' are lua pattern anchors for start of string and end of
  -- string, respectively (same as perl regex).
  
  -- This pattern matches the home page, '/'
  if path:find('^/$') then return true end
  
  -- This pattern matches any path starting with '/one'
  if path:find('^/login') then return true end
  
  -- This pattern matches any path starting with '/two'
  if path:find('^/logout') then return true end
  
  -- For this example, any other path is not valid
  return false;
end



-- function that returns html string containing the webpage content
function dynamic.page()
  page = GetPath()
  if page:find('^/login') then return session.page(false) end
  if page:find('^/logout') then return session.page(true) end


  if session.isLoggedIn() then
    local s = session.getEntry()
    name = s.Name or "No Name"
    expDate = s.ExpDate or 0 
    return ("using active sessionId=" .. session.getKey() ..  " name=" .. name ..  ", expDate=" .. tostring(expDate) .. [[. <a href="/logout">Logout</a>]])
  end

  local sessionId = session.getKey()

  -- Example to get parameger p. /one?p=123
  local p = HasParam('p') and GetParam('p') or [[not set. To set add '?p=123' to url]]
  return [[This is dynamic content for page ]] .. GetPath() .. [[<br>Parameter 'p' is ]] .. p .. [[<br>Not Logged in. Go to <a href="/login">Login Page</a><br>]]
end


-- function that returns html string containing a custom error page
dynamic.err404 = {}
function dynamic.err404.page()
  return "Error 404: Not Found: " .. GetPath()
end

return dynamic

