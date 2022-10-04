#!/usr/bin/python3

# Dba class
# xenxin@ufqi, Fri Sep 30 09:33:05 UTC 2022

from inc import Config;
from inc import Conn;
from inc import MySql;

#
class Dba:

    myConn = object();
    myDriver = object();
    logTag = "inc/Dba ";
    Sql_Operator_List = [
        " ","^","~",":","!","/",
        "*","&","%","+","=","|",
        ">","<","-","(",")",","
        ];

    #
    def __init__(self, xconf):
        if xconf == "":
            xconf = "master";
        self.myConn = Conn.DbConn(xconf);
        driverStr = "";
        if xconf == "master":
            driverStr = Config.conf['dbdriver'];
        else:
            driverStr = Config.conf['dbdriver_'+driverStr];

        if driverStr == "MYSQL":
            self.myDriver = MySql.MySql(self.myConn);
        else:
            print("inc/Dba: unsupported driverStr:{}".format(driverStr));

    #
    def select(self, sql, args):
        hm = {};
        idxArr = self.sortObject(sql, args);
        hasLimitOne = False;
        pageSize = 0;
        hmResult = {};
        print("inc/Dba: select: sql:{}".format(sql));
        if "pagesize" in args:
            pageSize = args["pagesize"];

        if " limit 1" in sql or pageSize == 1:
            hasLimitOne = True;
            hmResult = self.myDriver.readSingle(sql, args, idxArr);
        else:
            hmResult = self.myDriver.readBatch(sql, args, idxArr);
        
        if hmResult[0]:
            hm[0] = True;
            hm[1] = hmResult[1];
        else:
            hm[0] = False;
            hm[1] = hmResult[1];

        return hm;
        
    #
    def update(self, sql, args):
        hm = {};

        return hm;

    #
    def sortObject(self, sql, hmArgs):
        obj = [];
        tmpk = "";
        for key in hmArgs:
            print("\t{} k:{}, val:{}".format(self.logTag, key, hmArgs[key]));
            for op in self.Sql_Operator_List:
                #print("\t{} op:{}".format(self.logTag, op));
                tmpk = key+op+'%';
                if tmpk in sql:
                    obj.append(hmArgs[key]);
                    print("\t{} op:{} found val:{}".format(self.logTag, op, hmArgs[key]));
                else:
                    tmpk = key+' '+op+' %';
                    if tmpk in sql:
                        obj.append(hmArgs[key]);
                        print("\t{} op:{} found val:{}".format(self.logTag, op, hmArgs[key]));

        return obj;

##

