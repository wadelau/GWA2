#!/usr/bin/python3
# -v

# FinanceFund class for GWA2 in Python
# Xenxin@Ufqi, Sat Sep 24 01:52:16 UTC 2022

from inc import WebApp;

class FinanceFund(WebApp.WebApp):

    basetbl = "finance_fund_infotbl";

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
        hmResult = self.getBy("id, icode, iname", "icode=%s", hmCache={});

        return hmResult;
