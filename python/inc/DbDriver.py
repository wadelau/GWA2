#!/usr/bin/python3

# DbDriver interface for all database drivers
# xenxin@ufqi, Tue Oct  4 00:28:15 UTC 2022

from abc import ABC, ABCMeta;

#
class DbDriver(ABC):
    
    def __init__(self):
        pass;

    def query(self, sql:str, args:dict, idxArr:list):
        pass;

    def readSingle(self, sql:str, args:dict, idxArr:list):
        pass;

    def readBatch(self, sql:str, args:dict, idxArr:list):
        pass;

    def selectDb(self, sql:str):
        pass;

    def getAffectedRows(self):
        pass;

    def close(self):
        pass;

##
