#!/usr/bin/python3
# Xenxin@Ufqi
# Sat Sep 24 08:04:16 UTC 2022

# controll for financefund

import sys;
sys.path.append("..");
import random;
from inc import Config;

from mod.FinanceFund import FinanceFund;

#
crsPage = Config.crsPage;
mod = crsPage['mod'];
act = crsPage['act'];
out = crsPage['out']; # output string
data = crsPage['data']; # output container for format, e.g. json

#
ffund = FinanceFund();
print("ctrl/"+mod+":dir:ffund:{}".format(dir(ffund)));

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

elif act == 'list':
    print("ctrl/"+mod+": act:{} is ready in mod:{}. 202209241807.".format(act, mod));
    pass;

else:
    print("ctrl/"+mod+": act:{} not support in mod:{}. 202209241715.".format(act, mod));

#
crsPage['mod'] = mod;
crsPage['act'] = act;
crsPage['out'] = out;
crsPage['data'] = data;

