-- MySQL dump 10.13  Distrib 5.5.25a, for Linux (i686)
--
-- Host: localhost    Database: gwa2db
-- ------------------------------------------------------
-- Server version	5.5.25a-log

--
-- Table structure for table `gwa2_fin_operatelogtbl`
--

DROP TABLE IF EXISTS `gwa2_fin_operatelogtbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gwa2_fin_operatelogtbl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parentid` int(11) NOT NULL DEFAULT '0',
  `parenttype` char(32) NOT NULL DEFAULT '',
  `userid` int(11) NOT NULL DEFAULT '0',
  `actionstr` char(255) NOT NULL DEFAULT '',
  `inserttime` datetime NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=386 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gwa2_info_grouptbl`
--

DROP TABLE IF EXISTS `gwa2_info_grouptbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gwa2_info_grouptbl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupname` char(32) NOT NULL DEFAULT '',
  `groupcode` char(32) NOT NULL DEFAULT '',
  `grouplevel` tinyint(1) NOT NULL DEFAULT '0',
  `inserttime` datetime NOT NULL default CURRENT_TIMESTAMP,
  `operator` char(32) NOT NULL DEFAULT '',
  `state` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `key2` (`groupname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gwa2_info_usertbl`
--

DROP TABLE IF EXISTS `gwa2_info_usertbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gwa2_info_usertbl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` char(64) NOT NULL DEFAULT '',
  `realname` char(32) NOT NULL DEFAULT '',
  `email` char(32) NOT NULL DEFAULT '',
  `usergroup` tinyint(1) NOT NULL DEFAULT '0',
  `branchoffice` char(16) NOT NULL default '',
  `operatearea` char(255) NOT NULL DEFAULT '',
  `inserttime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatetime` datetime NOT NULL on update CURRENT_TIMESTAMP,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `operator` char(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniemail` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `gwa2_useraccesstbl`
--

DROP TABLE IF EXISTS `gwa2_useraccesstbl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `gwa2_useraccesstbl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL DEFAULT '0',
  `usergroup` int(11) NOT NULL DEFAULT '0',
  `objectid` mediumint(6) NOT NULL DEFAULT '0',
  `objectfield` char(255) NOT NULL DEFAULT '',
  `objectgroup` tinyint(1) NOT NULL DEFAULT '0',
  `accesstype` tinyint(1) NOT NULL DEFAULT '0',
  `operatelog` char(64) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT '1',
  `inserttime` datetime NOT NULL default CURRENT_TIMESTAMP,
  `memo` char(15) NOT NULL,
  `operator` char(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `key2` (`userid`,`usergroup`,`objectid`,`objectgroup`,`objectfield`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump completed on 2014-03-12  8:21:05
