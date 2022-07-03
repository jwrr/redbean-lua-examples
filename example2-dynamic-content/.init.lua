-- special script called by main redbean process at startup
HidePath('/usr/share/zoneinfo/')
HidePath('/usr/share/ssl/')

-- The following is added to the default .init.lua file.

-- dynamic.lua is in .lua folder. It defines three functions,
-- dynamic.page(), dynamic.err404.page() and dynamic.isValidDynamicPath(path)
dynamic = require"dynamic"

-- OnHttpRequest is a Redbean hook that gets called for each
-- HTTP request. It first tries to serve a static page. If the page
-- does not exist then it tries to serve a dynamic page.  If the
-- path does not match a user defined pattern for a dynamic page then
-- 404 is returned.

OnHttpRequest = function()
  local path = GetPath()
  local staticSuccess = ServeAsset(path)
  if staticSuccess then
    return
  end
  
  if dynamic.isValidDynamicPath(path) then
    Write(dynamic.page())
  else
    SetStatus(404, "Not Found")
    Write(dynamic.err404.page())
  end
end


