#!/usr/bin/python3
# -v

# FinanceFund class for GWA2 in Python
# Xenxin@Ufqi, Sat Sep 24 01:52:16 UTC 2022

from inc import WebApp;

class FinanceFund(WebApp.WebApp):

    def __init__(self):
        pass;


    def mySet(self, key, value):
        #print("mod/FinanceFund: mySet: key:{} value:{}".format(key, value));
        self.set(key, value);

    def myGet(self, key):
        #print("mod/FinanceFund: myGet: key:{} value:{}".format(key, self.get(key)));
        return self.get(key);
