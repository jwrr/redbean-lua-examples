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

In this example redbean will serve dynamic content.  '.init.lua' will be
modified and '.lua/dynamic.lua' will be added. It's a boring example, but
there's enough to get started.

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

* Modify .init.lua. Use the .init.lua that is here, in the example.
* Modify .lua/dynamic.lua. Uwd the lua file that is here, in the example.

* Create file abc.html with some dummy text. (Optional, done for example 1)
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
localhost:8080. You should see dynamic content being served. Navigate to
'/one' or '/two' and you should still see dynamic content.  Navigate to
'/three' or any other path and you should see the 404 message.  Go to
'/one?p=123' and you should see that 123 is displayed on the dynamic page.

You should also still be able to go to static page abc.html (from example 1).

* Add as many files as you want to the redbean.com zip file, including image files
and probably any other file types. Then restart the redbean.com server.




