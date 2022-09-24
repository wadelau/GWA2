#!/usr/bin/python3
# -v

# Config class for GWA2 in Python
# Xenxin@Ufqi,   Fri 15 Dec 2017 21:04:39 CST
# Ongoing by xenxin@ufqi.com, Sat Sep 24 01:44:10 UTC 2022

# globals
crsPage = {};
conf = {};

#
class Config:

    conf = {};
 
    def __init__(self):
        pass;

    def getConf(self):
        return self.conf;

    def setConf(self, myConf):
        for key, value in myConf.items():
            print("inc/Config:key:{} value:{}".format(key, value));
            self.conf[key] = value;

#
myConfig = Config();
if True:
    # global settings
    myConf = {};

    myConf['is_debug'] = 1;
    # ...
    #

    myConfig.setConf(myConf);

#
conf = myConfig.getConf();


