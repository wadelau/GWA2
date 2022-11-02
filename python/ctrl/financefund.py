#!/usr/bin/python3
# Xenxin@Ufqi
# Sat Sep 24 08:04:16 UTC 2022

# controll for financefund

import sys;
sys.path.append("..");
import random;
import time;
#import datetime; # why wrong way?
from datetime import date,datetime,timedelta;

from inc import Config;
from mod.FinanceFund import FinanceFund;

#sys.path.append("./mod/efinance/") # pay attention!
#from mod.efinance import efinance; 

# ctrl header
crsPage = Config.crsPage;
mod = crsPage['mod'];
act = crsPage['act'];
out = crsPage['out']; # output string
data = crsPage['data']; # output container for format, e.g. json
_REQUEST = crsPage['_REQUEST'];
_RESPONSE = crsPage['_RESPONSE'];
idate = _REQUEST.get('idate');

#
ffund = FinanceFund();
#print("ctrl/"+mod+":dir:ffund:{}".format(dir(ffund)));

#
if act == '':
    act = 'index';

if act == 'index':
    mykey = "abc-key";
    myval = "abc-value-"+str(random.randint(100,1000000));

    ffund.set(mykey, myval);
    myval2 = ffund.get(mykey);
    print("ctrl/"+mod+":set/get: mykey:{}, myval:{}, myval2:{}".format(mykey, myval, myval2));

    ffund.mySet(mykey, myval);
    myval2 = ffund.myGet(mykey);
    print("ctrl/"+mod+":mySet/myGet: mykey:{}, myval:{}, myval2:{}".format(mykey, myval, myval2));
    data['myval'] = myval2;

    fundName = "中信建投中证1000指数增强C";
    print("{} is debt? {}".format(fundName, ffund.isDebt(fundName)));
    fundName = "华夏中债50-3-5年国开债";
    print("\n{} is debt? {}".format(fundName, ffund.isDebt(fundName)));

    today = date.today();
    hour = datetime.now().strftime("%H");
    print("today:{} hour:{}".format(today, hour));

elif act == "sync":
    print("ctrl/"+mod+": sync: starting {}".format(mod));
    hmArgs = {}; hmArgsPrice = {}; 
    last2date = idate; hmResult = {} 
    if idate == None or idate == '':
        today = date.today();
        hour = datetime.now().strftime("%H");
        print("today:{} hour:{}".format(today, hour));
        if int(hour) > 21:
            # run in 22:00 UTC+0000 as 06:00 Beijing+0800 
            yesterday = today - timedelta(days = 0);
            idate = yesterday; 
            last2date = today - timedelta(days = 1);
        else:
            yesterday = today - timedelta(days = 1);
            idate = yesterday; 
            last2date = today - timedelta(days = 2);
    else:
        today = datetime.date.strftime(idate);
        last2date = today - datetime.timedelta(days = 2);
    # @todo: check idate/last2date if saturday or sunday? 
    #
    print("ctrl/"+mod+": act:{} idate:{} last2date:{}".format(act, idate, last2date));
	# business process
#
elif act == 'list':
    print("ctrl/"+mod+": act:{} is ready in mod:{}. 202209241807.".format(act, mod));
    pass;

else:
    print("ctrl/"+mod+": act:{} not support in mod:{}. 202209241715.".format(act, mod));

# ctrl footer
crsPage['mod'] = mod;
crsPage['act'] = act;
crsPage['out'] = out;
crsPage['data'] = data;
crsPage['_REQUEST'] = _REQUEST;
crsPage['_RESPONSE'] = _RESPONSE;
Config.crsPage = crsPage;
