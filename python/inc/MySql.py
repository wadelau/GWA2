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
            password=self.myPwd, database=self.myDb,
            connect_timeout=86400
            );
        self.dbCursor = self.dbConn.cursor(buffered=True);

    #
    # added by xenxin@ufqi, Fri Dec  9 03:16:32 UTC 2022
    def reConnect(self):
        self.dbConn = mysql.connector.connect(
            host=self.myHost, user=self.myUser,
            password=self.myPwd, database=self.myDb,
            connect_timeout=86400
            );
        self.dbCursor = self.dbConn.cursor(buffered=True);

    #
    def query(self, sql, args, idxArr):
        hm = {};
        #self.dbCursor = self.dbConn.cursor(buffered=True);
        try:
            self.dbCursor = self.dbConn.cursor(buffered=True);
        except:
            self.reConnect();
        #print("inc/MySql: query: sql:{}, idxArr:{}".format(sql, idxArr));
        self.dbCursor.execute(sql, idxArr);
        self.dbConn.commit();
        lastId = self.dbCursor.lastrowid;
        affectedRow = self.dbCursor.rowcount;
        if True:
            hm[0] = True;
            hm[1] = lastId;
            hm[2] = affectedRow; # why ?
                
        return hm;

    # 
    def readSingle(self, sql, args, idxArr):
        hm = {};
        try:
            self.dbCursor = self.dbConn.cursor(buffered=True);
        except:
            self.reConnect();
            
        self.dbCursor.execute(sql, idxArr);
        myResult = self.dbCursor.fetchone();
        if myResult != None and len(myResult) > 0:
            field_names = [i[0] for i in self.dbCursor.description];
            #print(field_names);
            #print(myResult);
            hmResult2 = {}; hmResult3 = {};
            for fi in range(len(field_names)):
                fname = field_names[fi];
                #print("fi:{} fname:{}".format(fi, fname));
                hmResult3[fname] = myResult[fi];
            hmResult2 = hmResult3;
            #
            myResult = hmResult2;
            hm[0] = True;
            hm[1] = {0:myResult};
        else:
            hm[0] = False;
            hm[1] = {0:"no-record.202210032151."};

        return hm;

    # 
    def readBatch(self, sql, args, idxArr):
        hm = {};
        #self.dbCursor = self.dbConn.cursor(buffered=True);
        try:
            self.dbCursor = self.dbConn.cursor(buffered=True);
        except:
            self.reConnect();

        self.dbCursor.execute(sql, idxArr);
        myResult = self.dbCursor.fetchall();
        if myResult != None and len(myResult) > 0:
            field_names = [i[0] for i in self.dbCursor.description];
            #print(field_names);
            hmResult2 = {};
            for (ri, row) in enumerate(myResult):
                hmResult3 = {};
                #print(row);
                for fi in range(len(field_names)):
                    fname = field_names[fi];
                    #print("ri:{} fi:{} fname:{}".format(ri, fi, fname));
                    hmResult3[fname] = row[fi];
                hmResult2[ri] = hmResult3;
            #
            myResult = hmResult2;
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
