#!/usr/bin/python3
# -v

# WebApp class for GWA2 in Python
# Xenxin@Ufqi,   Fri 15 Dec 2017 21:04:39 CST
# Ongoing by xenxin@ufqi.com, Sat Sep 24 01:44:10 UTC 2022

from inc import WebInterface;
from inc import Config;
from inc import Dba;

import mysql.connector; # optional third-party modules

#
class WebApp(WebInterface.WebInterface):

    hmf = {}; # container for runtime variables
    dba = object();
    myId = "id";

    def __init__(self, hmcfg):
        # db
        if True:
            dbconf = "";
            if "dbconf" in hmcfg:
                dbconf = hmcfg["dbconf"];
                self.set("dbconf", dbconf);
            self.dba = Dba.Dba(dbconf);
        print("inc/WebApp: init dba...");

        # cache


    def set(self, key, value):
        self.hmf[key] = value;
        #print("inc/WebApp: key:{}, value:{} hmf:{}".format(key, value, self.hmf));
    
    def setId(xId):
        self.hmf[self.myId] = xId;

    def getId():
        return self.hmf[self.myId];

    def get(self, key):
        #print("inc/WebApp: get key:{}, value:{} hmf:{}".format(key, self.hmf[key], self.hmf));
        return self.hmf[key];

    def setTbl(self, xtbl):
        self.hmf["tbl"] = xtbl;

    def getTbl(self):
        return self.hmf["tbl"];

    def getBy(self, fields, args, hmCache={}):
        hm = {};
        sqls = "";
        hasLimitOne = False;
        pageNum = 1;
        pageSize = 0;
        # readCache, @todo
        if "pagenum" in self.hmf:
            pageNum = self.hmf["pagenum"];
        
        if "pagesize" in self.hmf:
            pageSize = self.hmf["pagesize"];

        sqls = "select "+fields+" from "+self.getTbl()+" where ";
        if args == "":
            if self.getId() == "":
                sqls += " 1==1 ";
            else:
                sqls += self.myId+"=%d";
                hasLimitOne = True;
        else:
            sqls += args;

        if "groupby" in self.hmf:
            sqls += " group by "+self.hmf["groupby"];

        if "orderby" in self.hmf:
            sqls += " order by "+self.hmf["orderby"];

        if hasLimitOne:
            sqls += " limit 1";
        else:
            if " limit" not in sqls:
                if pageSize == 0:
                    pageSize = 99999;
                sqls += " limit "+str((pageNum-1)*pageSize)+", "+str(pageSize);
        hm = self.dba.select(sqls, self.hmf);
        # setCache, @todo

        return hm;

    def setBy(self, fields, args, hmCache={}):
        hm = {};
        # @todo: write to objects
        # write to db
        sqls = "";
        isUpdate = False; tmpId = self.getId();
        if tmpId == "" or tmpId == "0":
            if args == None or args == "":
                isUpdate = False;
            else:
                isUpdate = True;
        else:
            isUpdate = True;
        #
        if isUpdate:
            sqls = sqls + "update "+self.getTbl()+" set ";
        else:
            sqls = sqls + "insert into "+self.getTbl()+" set ";
        #
        fields = fields.split(",");
        for field in fields:
            field = field.lstrip().rstrip();
            # @todo: time field
            sqls = sqls + field + "=%s, ";
        #
        sqlsLen = len(sqls);
        sqls = sqls[:-2]; # remove ", "
        isSqlReady = True;
        if args != None and args != "":
            sqls + sqls + " where " + args;
        else:
            if tmpId == "" or tmpId == "0":
                if isUpdate:
                    print("unconditonal update is forbidden. 1607072133.");
                    hm[0] = False;
                    hm[1] = {"errordesc":"unconditonal update is forbidden. 1607072133."};
                    isSqlReady = False;
            else:
                sqls = sqls + " where "+self.myId + "=%s "
        #
        if isSqlReady:
            # @todo: pagesize
            hm = self.dba.update(sqls, self.hmf);
            hm["isupdate"] = isUpdate;
            # @todo: cache

        return hm;

    def execBy(self, sql, args, hmCache):
        hm = {};
        args = args.strip();
        origSql = sql;
        sqlx = '';
        pos = -1;
        if sql != '':
            sqlx = sql.strip().upper();
            pos = sqlx.find("SELECT ");
            if pos == 0:
                pass;
            else:
               pos = sqlx.find("DESC ");
               if pos == 0:
                   pass;
               else:
                   pos = sqlx.find("SHOW ");
            # read from cache, @todo
            #
            if args != '':
                if sqlx.find("WHERE ") > -1:
                    sql = sql + args;
                else:
                    sql = " where " + args;
            #
            #print("inc/WebApp: execBy: sql:{}, pos:{}".format(sql, pos));
            if pos == 0:
                hm = self.dba.select(sql, self.hmf);
            else:
                hm = self.dba.update(sql, self.hmf);

        else:
            print("sql:[{}] is empty.".format(sql));

        return hm;

    def rmBy(self, args):
        hm = {};
        # @todo: sql pack

        return hm;

##