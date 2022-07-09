local custom_err404 = {}

custom_err404.page = function()
local html = [[<!DOCTYPE html>
<html style="height:100%">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title> 404 Not Found</title>
<style>
body {color:#444;margin:0;height:100%;background-color:#fff;}
h1 {font-size:10em;font-weight:bold;margin:0;padding:0}
h2 {font-size:2.5em;margin:0;padding:0}
a {color:#fff;}
#center {
 width:100%;text-align:center;margin:0;position:absolute;top:40%;
 -ms-transform:translateY(-40%);transform:translateY(-40%);}
#footer {
 width:100%;color:#ccc;background-color:#444;font-size:1.1em;padding:30px 0px 30px 10px;
 position:fixed;bottom:0;width:100%;}
</style>
</head>
<body>
<div id="center">
<h1>404</h1>
<h2>Not Found</h2>
<p>The resource could not be found</p>
<p>]] .. GetPath() .. [[
</div>
<div id="footer">
Powered by <a href="https://redbean.dev">Redbean</a> and
<a href="https://lua.org">Lua</a>
</div>
</body></html>
]]
return html
end

return custom_err404

