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

In this example 4, sessions that use the cookies are added to example 3.  The '.lua/sessions.lua'
module is added to manage the sessions.  The sessions in this example use the file-based
approach, similar to PHP's approach.

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
* Keep .lua/cookie.lua. No change from Example 3.
* Add new .lua/session.lua. Use the lua file that is here, in the example.
* Make a sessions folder
```
mkdir sessions
```
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
localhost:8080. You should see dynamic content being served. Click on the 'login'
link and then enter/submit name and password (password isn't used in this example).
You should get a message saying you're logged in.  Click on the 'home' link and it 
should show your name, when the session will expire and the session-id.





