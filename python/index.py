#!/usr/bin/python3
# Xenxin@Ufqi
# Sat Jan 13 21:21:29 CST 2018
# Resume by xenxin@ufqi.com, Sat Sep 24 01:57:46 UTC 2022

import sys;
sys.path.append("..");
import os.path;
import random;
from datetime import date,datetime;
import time;
from time import gmtime,strftime;

from inc import Config;

#
mod = "index"; # controller routing
act = "index"; # methods
_REQUEST = {};
_RESPONSE = {};
out = ""; # output string
data = {} # output container for format, e.g. json
crsPage = {};

if __name__ == "__main__":
    print(f"Cmdline-Arguments count: {len(sys.argv)}")
    for i, arg in enumerate(sys.argv):
        print(f"\tArgument {i:>6}: {arg}");

    __import__("comm.cmdline-inc");
    
    if len(sys.argv) > 1:
        args = sys.argv[1];
        if args.find('?') > -1:
            args = args[1:];
        argsList = args.split('&');
        for seg in argsList:
            pair = seg.split('=');
            if pair[0] == 'mod':
                mod = pair[1];
            elif pair[0] == 'act':
                act = pair[1];
            #
            _REQUEST[pair[0]] = pair[1];
        crsPage['_REQUEST'] = _REQUEST;

# 
data['timestamp'] = time.time(); 
data['timestamp_gm'] = time.gmtime(); 
#print("./index: mod:{} act:{} config:{}".format(mod, act, Config.myConf));

if os.path.isfile('./ctrl/'+mod+'.py'):
    crsPage['mod'] = mod;
    crsPage['act'] = act;
    crsPage['out'] = out;
    crsPage['data'] = data;
    crsPage['_REQUEST'] = _REQUEST;
    crsPage['_RESPONSE'] = _RESPONSE;
    Config.crsPage = crsPage;

    __import__("ctrl."+mod, globals(), locals());

    crsPage = Config.crsPage;
    mod = crsPage['mod'];
    act = crsPage['act'];
    out = crsPage['out'];
    data = crsPage['data'];
    _REQUEST = crsPage['_REQUEST'];
    _RESPONSE = crsPage['_RESPONSE'];

else:
    print("./index: mod:{} not exist. 202209241657.".format(mod));

# 
if Config.conf['is_debug'] == 1:
   print("./index: debug enabled."); 
else:
   print("./index: debug disabled."); 

#
print("./index: succ out:{} data:{}".format(out, data));
