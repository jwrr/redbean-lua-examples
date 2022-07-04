local dynamic = {}

-- This module defines the three functions needed by .init.lua to serve
-- a dynamic page.


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

  -- Example to get parameger p. /one?p=123
  local p = HasParam('p') and GetParam('p') or [[not set. To set add '?p=123' to url]]
  return [[This is dynamic content for page ]] .. GetPath() .. [[.<br>Parameter 'p' is ]] .. p
end


-- function that returns html string containing a custom error page
dynamic.err404 = {}
function dynamic.err404.page()
  return "Error 404: Not Found: " .. GetPath()
end

return dynamic

