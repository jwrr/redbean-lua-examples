Example 1
=========

The default redbean.com zip file has the following contents
```
.
./.symtab
./favicon.ico
./help.txt
./.init.lua
./redbean.png
./usr/share/zoneinfo/many_files
./usr/share/ssl/root/many_files
```

In this example 3, cookies are added to example 2.  The '.lua/cookie.lua'
module is added that wraps Redbean's GetCookie and SetCookie.

* Download redbean and make it executable.  You can re-use example 1's redbean.
```
wget https://justine.lol/redbean/redbean-latest.com
mv redbean-latest.com redbean.com
chmod 755 redbean.com
ls -l
```

* If you get an error about CIL then
```
sudo sh -c "echo ':APE:M::MZqFpD::/bin/sh:' >/proc/sys/fs/binfmt_misc/register"
```

* Keep .init.lua. No change from Example 2.
* Modify .lua/dynamic.lua. Use the lua file that is here, in the example.
* Create .lua/cookie.lua. Use the lua file that is here, in the example.
* Add the files to the redbean.com zip file.
```
zip redbean.com abc.html .init.lua .lua/*
```
* Start redbean server. The '-vv' option makes it more verbose. Also, press
Ctrl-C twice to kill the server.
```
./redbean.com -vv
```

* The server should now be running on port 8080. Open Firefox and browse to
localhost:8080. You should see dynamic content being served. You should see the
session-cookie be created. You can view/clear the cookie in Firefox's web developer
tools. 





