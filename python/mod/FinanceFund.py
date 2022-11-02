#!/usr/bin/python3
# -v

# FinanceFund class for GWA2 in Python
# Xenxin@Ufqi, Sat Sep 24 01:52:16 UTC 2022

import time;
from datetime import date;

from inc import WebApp;

class FinanceFund(WebApp.WebApp):

    logTag = "mod/FinanceFund ";
    basetbl = "";
    basePriceTbl = "";
    fundTypeArr = ["fund", "etf", "lof", "fja", "fjb", "open_fund", "bond_fund", 
            "stock_fund", "QDII_fund", "money_market_fund", "mixture_fund"];
    fundTypeDict = {"fund":0, "etf":1, "lof":2, "fja":3, "fjb":4, "open_fund":5, "bond_fund":6, 
            "stock_fund":7, "QDII_fund":8, "money_market_fund":9, "mixture_fund":10};

    def __init__(self):
        self.setTbl(self.basetbl);
        hmcfg = {};
        super().__init__(hmcfg);

    def mySet(self, key, value):
        #print("mod/FinanceFund: mySet: key:{} value:{}".format(key, value));
        self.set(key, value);

    def myGet(self, key):
        #print("mod/FinanceFund: myGet: key:{} value:{}".format(key, self.get(key)));
        return self.get(key);

    def getInfo(self, icode):
        self.set("icode", icode);
        idate = date.today().isoformat();
        #print("{} getInfo idate:{}".format(self.logTag, idate));
        hmResult = self.getBy("*", "icode=%s", hmCache={});
        #print("{} getInfo idate:{} icode:{} hmResult:{}".format(self.logTag, idate, icode, hmResult));

        return hmResult;

    def saveInfo(self, hmArgs):
        hmResult = {};
        for key in hmArgs:
            self.set(key, hmArgs[key]);
        #
        icode = hmArgs["icode"]; sql = "";
        hmResult = self.getInfo(icode);
        # main duty....
        if sql != "":
            hmResult = self.execBy(sql, "", {});
        else:
            hmResult = {0:True, 1:"no-save-need-skip."};
        #print("{} saveInfo: result:{} sql:{}".format(self.logTag, hmResult, sql));

        return hmResult;

    def getPriceInfo(self, icode, idate):
        self.set("icode", icode);
        self.set("idate", idate);
        sql = "select id from "+self.basePriceTbl+" where 1=1 limit 1";
        hmResult = self.execBy(sql, "", hmCache={});

        return hmResult;

    def savePriceInfo(self, icode, idate, priceData):
        self.set("icode", icode);
        self.set("idate", idate);
        hmResult = self.getPriceInfo(icode, idate);
        # main duty @todo
        return hmResult;

    def isDebt(self, fundName):
        hasTag = False;
        debtTagList = ["中债","债券","行债","城投债","国开债","金融债"];
        for tag in debtTagList:
            if tag in fundName:
                print("\t{} {} is debt for tag:{}.".format(self.logTag, fundName, tag));
                hasTag = True;
                break;
        #
        return hasTag;

    def isLof(self, fundName):
        hasTag = False;
        debtTagList = ["LOF"];
        fundName = fundName.upper();
        for tag in debtTagList:
            if tag in fundName:
                print("\t{} {} is Lof for tag:{}.".format(self.logTag, fundName, tag));
                hasTag = True;
                break;
        #
        return hasTag;
    
    def offline(self):
        hmResult = {};
        today = date.fromtimestamp(time.time()-86400*1.5); # half a day before
        idate = today.isoformat();
        sql = "?"; # why 3000?
        hmResult = self.execBy(sql, "", hmCache={});
        print("\t{} offline sql:{} hmResult:{}.".format(self.logTag, sql, hmResult));
        return hmResult;
    
##
