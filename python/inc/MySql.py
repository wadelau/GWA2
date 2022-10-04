#!/usr/bin/python3

# Dba class
# xenxin@ufqi,  Fri Sep 30 09:56:10 UTC 2022
# updt Mon Oct  3 13:55:11 UTC 2022

import mysql.connector;
from inc import Config;
from inc import DbDriver;

#
class MySql(DbDriver.DbDriver):

    logTag = "inc/MySql ";
    myHost = "";
    myPort = 3306;
    myUser = "";
    myPwd = "";
    myDb = "";
    hasSockPool = False;
    dbConn = object();
    dbCursor = object();

    #
    def __init__(self, dbConf):
        self.myHost = dbConf.myHost;
        self.myPort = dbConf.myPort;
        self.myUser = dbConf.myUser;
        self.myPwd = dbConf.myPwd;
        self.myDb = dbConf.myDb;
        self.hasSockPool = Config.conf['db_enable_socket_pool'];

        self.dbConn = mysql.connector.connect(
            host=self.myHost, user=self.myUser,
            password=self.myPwd, database=self.myDb
            );
        self.dbCursor = self.dbConn.cursor();

    #
    def query(self, sql, args, idxArr):
        hm = {};
        self.dbCursor = self.dbConn.cursor();
        self.dbCursor.execute(sql, idxArr);
        self.dbConn.commit();
        lastId = dbCursor.lastrowid;
        if True:
            hm[0] = True;
            hm[1] = lastId;

        return hm;

    # 
    def readSingle(self, sql, args, idxArr):
        hm = {};
        self.dbCursor = self.dbConn.cursor();
        self.dbCursor.execute(sql, idxArr);
        myResult = self.dbCursor.fetchone();
        if len(myResult) > 0:
            hm[0] = True;
            hm[1] = {0:myResult};
        else:
            hm[0] = False;
            hm[1] = {0:"no-record.202210032151."};

        return hm;

    # 
    def readBatch(self, sql, args, idxArr):
        hm = {};
        self.dbCursor = self.dbConn.cursor();
        self.dbCursor.execute(sql, idxArr);
        myResult = self.dbCursor.fetchall();
        if len(myResult) > 0:
            hm[0] = True;
            hm[1] = myResult;
        else:
            hm[0] = False;
            hm[1] = {0:"no-record.202210032151."};

        return hm;

    #
    def selectDb(self, myDb):
        self.myDb = myDb;
        self.query("use "+self.myDb, {}, []);

##
