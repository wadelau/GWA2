#!/usr/bin/python3
# -v

# WebApp class for GWA2 in Python
# Xenxin@Ufqi,   Fri 15 Dec 2017 21:04:39 CST
# Ongoing by xenxin@ufqi.com, Sat Sep 24 01:44:10 UTC 2022

from inc import WebInterface;

import mysql.connector; # optional third-party modules


class WebApp(WebInterface.WebInterface):

    hmf = {}; # container for runtime variables

    def __init__(self, hmcfg):
        pass;


    def set(self, key, value):
        self.hmf[key] = value;
        #print("inc/WebApp: key:{}, value:{} hmf:{}".format(key, value, self.hmf));


    def get(self, key):
        #print("inc/WebApp: get key:{}, value:{} hmf:{}".format(key, self.hmf[key], self.hmf));
        return self.hmf[key];
