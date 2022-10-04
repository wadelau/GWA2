#!/usr/bin/python3

# Connection class
# xenxin@ufqi,  Fri Sep 30 10:02:16 UTC 2022

from inc import Config;

#
class DbConn:

    myHost = "";
    myPort = "";
    myUser = "";
    myPwd = "";
    myDb = "";
    myDriver = "";

    def __init__(self, xServer):
        if xServer == '':
            xServer = "master";
        # master
        if xServer == "master":
            self.myHost = Config.conf['dbhost'];
            self.myPort= Config.conf['dbport'];
            self.myUser = Config.conf['dbuser'];
            self.myPwd = Config.conf['dbpwd'];
            self.myDb = Config.conf['dbname'];
            self.myDriver = Config.conf['dbdriver'];

        elif xServer == "slave":
            pass;

        else:
            print("inc/Conn: unsupported xServer:{}".format(xServer));

#
class CacheConn:

    myHost = "";
    myPort = "";
    myUser = "";
    myPwd = "";
    myDb = "";
    myDriver = "";

    def __init__(self, xServer):
        if xServer == '':
            xServer = "master";
        # master


