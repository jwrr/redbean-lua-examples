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

In this example 5, accounts that use sqlite3 are added to example 4.
The '.lua/account.lua' module is added to manage the accountss.  The accounts 
in this example are simple, with a username, hashed password, and email.

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

* Update .init.lua to add some simple tests that create a database and account table,
create several users, and verify the passwords match.  Creating users and verifying
passwords will eventually move to the join page and the login page.
* Add new .lua/account.lua. Use the lua file that is here, in the example.
* Add the files to the redbean.com zip file.
```
zip redbean.com abc.html .init.lua .lua/*
```
* Start redbean server. The '-vv' option makes it more verbose. Also, press
Ctrl-C twice to kill the server.
```
./redbean.com -vv
```

* The server should now be running on port 8080. On startup the sqlite3 database file
is created (redbean.sql). Several users are then created. The passwords are then
verified and SUCCESS/FAIL results are printed to the console screen.

* You can look at the database
```
> sqlite3 redbean.sql # You may need to install sqlite3 onto your system
sqlite> .tables
sqlite> .schema accounts
sqlite> select * from accounts;
sqlite> .quit
```





