#!/usr/bin/python3
# -v

# WebApp Interface for GWA2 in Python
# Xenxin@Ufqi, Fri 15 Dec 2017 21:03:47 CST
# Ongoing by xenxin@ufqi.com, Sat Sep 24 01:28:52 UTC 2022

from abc import ABC, ABCMeta;

#
class WebInterface(ABC):
    
    def __init__(self):
        pass;

    #
    def get(self, key:str):
        return str;

    def set(self, key:str, value:object):
        pass;

    #
    def setBy(self, fields:str, conditions:str):
        pass;

    def getBy(self, fields:str, conditions:str):
        return dict;

    #
    def setTbl(self, tbl:str):
        pass;

    def getTbl(self):
        return str;

    # 
    def setId(self, myId:str):
        pass;

    def getId(self):
        return str;

    #
    def execBy(self, expression:str, conditions:str):
        return dict;

    def rmBy(self, conditions:str):
        pass;

    #
    def toString(self, obj:object):
        return str;


