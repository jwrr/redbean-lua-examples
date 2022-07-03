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

In this exampl redbean will serve static content.
* Download redbean and make executable
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

* Create file abc.html with some dummy text.
* Add abc.html to the redbean.com zip file.
```
zip redbean.com abc.html
```
* Start redbean server. The '-vv' option makes it more verbose. Also, press
Ctrl-C twice to kill the server.
```
./redbean.com -vv
```

* The server should now be running on port 8080. Open Firefox and browse to 
localhost:8080. You should see an index page listing all files in the directory,
including abc.html. click on the link to see your content.

* Add as many files as you want to the redbean.com zip file, including image files
and probably any other file types. Then restart the redbean.com server.

* Next. Dynamic files




