-- MySQL dump 10.13  Distrib 5.7.30, for Linux (x86_64)
--
-- Host: localhost    Database: mj
-- ------------------------------------------------------
-- Server version	5.7.30-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts_account`
--

DROP TABLE IF EXISTS `accounts_account`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_account` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `email` varchar(254) NOT NULL,
  `phone` varchar(128) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `website` varchar(200) DEFAULT NULL,
  `description` longtext,
  `created_on` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `status` varchar(64) NOT NULL,
  `lead_id` int(11) DEFAULT NULL,
  `billing_address_line` varchar(255) DEFAULT NULL,
  `billing_city` varchar(255) DEFAULT NULL,
  `billing_country` varchar(3) DEFAULT NULL,
  `billing_postcode` varchar(64) DEFAULT NULL,
  `billing_state` varchar(255) DEFAULT NULL,
  `billing_street` varchar(55) DEFAULT NULL,
  `contact_name` varchar(120) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `accounts_account_created_by_id_96988f15_fk_common_user_id` (`created_by_id`),
  KEY `accounts_account_lead_id_f33685c2_fk_leads_lead_id` (`lead_id`),
  CONSTRAINT `accounts_account_created_by_id_96988f15_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`),
  CONSTRAINT `accounts_account_lead_id_f33685c2_fk_leads_lead_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_lead` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_account`
--

LOCK TABLES `accounts_account` WRITE;
/*!40000 ALTER TABLE `accounts_account` DISABLE KEYS */;
INSERT INTO `accounts_account` VALUES (1,'ajith','ajith@gmail.com','+919878900987',NULL,'http://www.wipro.com','','2020-05-18 09:58:19.288418',0,1,'open',2,'21','chennai','IN','607','tamil nadu','nehru st',''),(2,'abcd','abcd@gmail.com','+919879081234',NULL,'http://www.abcd.com','','2020-05-19 04:40:40.438409',0,1,'open',3,'12','banglore','IN','607','karnataka','npg st',''),(3,'abcd','abcd@gmail.com','+919127899876',NULL,'http://www.abc.com','','2020-06-04 09:42:11.539156',0,1,'close',2,'12','chennai','IN','908787','tamil nadu','gandhi st',''),(4,'abc','mani@gmail.com','+NoneNone',NULL,'www.def.com','','2020-06-04 09:47:30.658118',0,1,'open',NULL,NULL,'chennai','IN',NULL,NULL,NULL,''),(5,'vani','vani@gmail.com','+918909807890',NULL,'http://www.abcd.com','','2020-06-06 12:44:31.471205',0,1,'open',5,'22','chennai','IN','780','tamil nadu','mgr street',''),(8,'nju','nju@gmail.com','+919087896889',NULL,'http://www.dfg.com','','2020-06-18 06:00:44.121603',0,1,'open',5,'23','chennai','IN','908','tamil nadu','abc st',''),(9,'qwe','qwe@gmail.com','+919089870987',NULL,'http://www.loi.com','','2020-06-18 06:02:04.216710',0,1,'open',5,'12','cvbn','IN','978','bhk','as st','');
/*!40000 ALTER TABLE `accounts_account` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_account_assigned_to`
--

DROP TABLE IF EXISTS `accounts_account_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_account_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_account_assigned_to_account_id_user_id_44dc1cab_uniq` (`account_id`,`user_id`),
  KEY `accounts_account_assigned_to_user_id_407e8c4d_fk_common_user_id` (`user_id`),
  CONSTRAINT `accounts_account_ass_account_id_7e994f48_fk_accounts_` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `accounts_account_assigned_to_user_id_407e8c4d_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_account_assigned_to`
--

LOCK TABLES `accounts_account_assigned_to` WRITE;
/*!40000 ALTER TABLE `accounts_account_assigned_to` DISABLE KEYS */;
INSERT INTO `accounts_account_assigned_to` VALUES (12,1,1),(11,5,1);
/*!40000 ALTER TABLE `accounts_account_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_account_contacts`
--

DROP TABLE IF EXISTS `accounts_account_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_account_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_account_contacts_account_id_contact_id_63ccfc8f_uniq` (`account_id`,`contact_id`),
  KEY `accounts_account_con_contact_id_1ebaea8d_fk_contacts_` (`contact_id`),
  CONSTRAINT `accounts_account_con_account_id_dd7706b6_fk_accounts_` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `accounts_account_con_contact_id_1ebaea8d_fk_contacts_` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_account_contacts`
--

LOCK TABLES `accounts_account_contacts` WRITE;
/*!40000 ALTER TABLE `accounts_account_contacts` DISABLE KEYS */;
INSERT INTO `accounts_account_contacts` VALUES (17,1,1),(16,2,3),(18,3,2),(15,5,2),(21,8,4),(22,9,2);
/*!40000 ALTER TABLE `accounts_account_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_account_tags`
--

DROP TABLE IF EXISTS `accounts_account_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_account_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `tags_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_account_tags_account_id_tags_id_5920940e_uniq` (`account_id`,`tags_id`),
  KEY `accounts_account_tags_tags_id_78fe9bd2_fk_accounts_tags_id` (`tags_id`),
  CONSTRAINT `accounts_account_tags_account_id_3be82424_fk_accounts_account_id` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `accounts_account_tags_tags_id_78fe9bd2_fk_accounts_tags_id` FOREIGN KEY (`tags_id`) REFERENCES `accounts_tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_account_tags`
--

LOCK TABLES `accounts_account_tags` WRITE;
/*!40000 ALTER TABLE `accounts_account_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_account_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_account_teams`
--

DROP TABLE IF EXISTS `accounts_account_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_account_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `teams_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_account_teams_account_id_teams_id_63eb02cd_uniq` (`account_id`,`teams_id`),
  KEY `accounts_account_teams_teams_id_f8111d1e_fk_teams_teams_id` (`teams_id`),
  CONSTRAINT `accounts_account_tea_account_id_7be328bb_fk_accounts_` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `accounts_account_teams_teams_id_f8111d1e_fk_teams_teams_id` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_account_teams`
--

LOCK TABLES `accounts_account_teams` WRITE;
/*!40000 ALTER TABLE `accounts_account_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_account_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_email`
--

DROP TABLE IF EXISTS `accounts_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime(6) NOT NULL,
  `message_subject` longtext,
  `message_body` longtext,
  `from_account_id` int(11) DEFAULT NULL,
  `from_email` varchar(254) NOT NULL,
  `rendered_message_body` longtext,
  `scheduled_date_time` datetime(6) DEFAULT NULL,
  `scheduled_later` tinyint(1) NOT NULL,
  `timezone` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `accounts_email_from_account_id_86dd0e6a_fk_accounts_account_id` (`from_account_id`),
  CONSTRAINT `accounts_email_from_account_id_86dd0e6a_fk_accounts_account_id` FOREIGN KEY (`from_account_id`) REFERENCES `accounts_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_email`
--

LOCK TABLES `accounts_email` WRITE;
/*!40000 ALTER TABLE `accounts_email` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_email_recipients`
--

DROP TABLE IF EXISTS `accounts_email_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_email_recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email_id` int(11) NOT NULL,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounts_email_recipients_email_id_contact_id_39ddf0f8_uniq` (`email_id`,`contact_id`),
  KEY `accounts_email_recip_contact_id_8b4d5e07_fk_contacts_` (`contact_id`),
  CONSTRAINT `accounts_email_recip_contact_id_8b4d5e07_fk_contacts_` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `accounts_email_recipients_email_id_a9e1dba2_fk_accounts_email_id` FOREIGN KEY (`email_id`) REFERENCES `accounts_email` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_email_recipients`
--

LOCK TABLES `accounts_email_recipients` WRITE;
/*!40000 ALTER TABLE `accounts_email_recipients` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_email_recipients` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_emaillog`
--

DROP TABLE IF EXISTS `accounts_emaillog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_emaillog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_sent` tinyint(1) NOT NULL,
  `contact_id` int(11) DEFAULT NULL,
  `email_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `accounts_emaillog_contact_id_10e17a75_fk_contacts_contact_id` (`contact_id`),
  KEY `accounts_emaillog_email_id_b252a46b_fk_accounts_email_id` (`email_id`),
  CONSTRAINT `accounts_emaillog_contact_id_10e17a75_fk_contacts_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `accounts_emaillog_email_id_b252a46b_fk_accounts_email_id` FOREIGN KEY (`email_id`) REFERENCES `accounts_email` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_emaillog`
--

LOCK TABLES `accounts_emaillog` WRITE;
/*!40000 ALTER TABLE `accounts_emaillog` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_emaillog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accounts_tags`
--

DROP TABLE IF EXISTS `accounts_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `accounts_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `slug` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_tags`
--

LOCK TABLES `accounts_tags` WRITE;
/*!40000 ALTER TABLE `accounts_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `accounts_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=209 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can view permission',1,'view_permission'),(5,'Can add group',2,'add_group'),(6,'Can change group',2,'change_group'),(7,'Can delete group',2,'delete_group'),(8,'Can view group',2,'view_group'),(9,'Can add content type',3,'add_contenttype'),(10,'Can change content type',3,'change_contenttype'),(11,'Can delete content type',3,'delete_contenttype'),(12,'Can view content type',3,'view_contenttype'),(13,'Can add session',4,'add_session'),(14,'Can change session',4,'change_session'),(15,'Can delete session',4,'delete_session'),(16,'Can view session',4,'view_session'),(17,'Can add user',5,'add_user'),(18,'Can change user',5,'change_user'),(19,'Can delete user',5,'delete_user'),(20,'Can view user',5,'view_user'),(21,'Can add address',6,'add_address'),(22,'Can change address',6,'change_address'),(23,'Can delete address',6,'delete_address'),(24,'Can view address',6,'view_address'),(25,'Can add attachments',7,'add_attachments'),(26,'Can change attachments',7,'change_attachments'),(27,'Can delete attachments',7,'delete_attachments'),(28,'Can view attachments',7,'view_attachments'),(29,'Can add comment',8,'add_comment'),(30,'Can change comment',8,'change_comment'),(31,'Can delete comment',8,'delete_comment'),(32,'Can view comment',8,'view_comment'),(33,'Can add comment_ files',9,'add_comment_files'),(34,'Can change comment_ files',9,'change_comment_files'),(35,'Can delete comment_ files',9,'delete_comment_files'),(36,'Can view comment_ files',9,'view_comment_files'),(37,'Can add document',10,'add_document'),(38,'Can change document',10,'change_document'),(39,'Can delete document',10,'delete_document'),(40,'Can view document',10,'view_document'),(41,'Can add google',11,'add_google'),(42,'Can change google',11,'change_google'),(43,'Can delete google',11,'delete_google'),(44,'Can view google',11,'view_google'),(45,'Can add api settings',12,'add_apisettings'),(46,'Can change api settings',12,'change_apisettings'),(47,'Can delete api settings',12,'delete_apisettings'),(48,'Can view api settings',12,'view_apisettings'),(49,'Can add profile',13,'add_profile'),(50,'Can change profile',13,'change_profile'),(51,'Can delete profile',13,'delete_profile'),(52,'Can view profile',13,'view_profile'),(53,'Can add account',14,'add_account'),(54,'Can change account',14,'change_account'),(55,'Can delete account',14,'delete_account'),(56,'Can view account',14,'view_account'),(57,'Can add tags',15,'add_tags'),(58,'Can change tags',15,'change_tags'),(59,'Can delete tags',15,'delete_tags'),(60,'Can view tags',15,'view_tags'),(61,'Can add email',16,'add_email'),(62,'Can change email',16,'change_email'),(63,'Can delete email',16,'delete_email'),(64,'Can view email',16,'view_email'),(65,'Can add email log',17,'add_emaillog'),(66,'Can change email log',17,'change_emaillog'),(67,'Can delete email log',17,'delete_emaillog'),(68,'Can view email log',17,'view_emaillog'),(69,'Can add case',18,'add_case'),(70,'Can change case',18,'change_case'),(71,'Can delete case',18,'delete_case'),(72,'Can view case',18,'view_case'),(73,'Can add sla',19,'add_sla'),(74,'Can change sla',19,'change_sla'),(75,'Can delete sla',19,'delete_sla'),(76,'Can view sla',19,'view_sla'),(77,'Can add sla email',20,'add_slaemail'),(78,'Can change sla email',20,'change_slaemail'),(79,'Can delete sla email',20,'delete_slaemail'),(80,'Can view sla email',20,'view_slaemail'),(81,'Can add sla voice',21,'add_slavoice'),(82,'Can change sla voice',21,'change_slavoice'),(83,'Can delete sla voice',21,'delete_slavoice'),(84,'Can view sla voice',21,'view_slavoice'),(85,'Can add updated case',22,'add_updatedcase'),(86,'Can change updated case',22,'change_updatedcase'),(87,'Can delete updated case',22,'delete_updatedcase'),(88,'Can view updated case',22,'view_updatedcase'),(89,'Can add contact',23,'add_contact'),(90,'Can change contact',23,'change_contact'),(91,'Can delete contact',23,'delete_contact'),(92,'Can view contact',23,'view_contact'),(93,'Can add multimail',24,'add_multimail'),(94,'Can change multimail',24,'change_multimail'),(95,'Can delete multimail',24,'delete_multimail'),(96,'Can view multimail',24,'view_multimail'),(97,'Can add emailinfo',25,'add_emailinfo'),(98,'Can change emailinfo',25,'change_emailinfo'),(99,'Can delete emailinfo',25,'delete_emailinfo'),(100,'Can view emailinfo',25,'view_emailinfo'),(101,'Can add email',26,'add_email'),(102,'Can change email',26,'change_email'),(103,'Can delete email',26,'delete_email'),(104,'Can view email',26,'view_email'),(105,'Can add lead',27,'add_lead'),(106,'Can change lead',27,'change_lead'),(107,'Can delete lead',27,'delete_lead'),(108,'Can view lead',27,'view_lead'),(109,'Can add opportunity',28,'add_opportunity'),(110,'Can change opportunity',28,'change_opportunity'),(111,'Can delete opportunity',28,'delete_opportunity'),(112,'Can view opportunity',28,'view_opportunity'),(113,'Can add event',29,'add_event'),(114,'Can change event',29,'change_event'),(115,'Can delete event',29,'delete_event'),(116,'Can view event',29,'view_event'),(117,'Can add reminder',30,'add_reminder'),(118,'Can change reminder',30,'change_reminder'),(119,'Can delete reminder',30,'delete_reminder'),(120,'Can view reminder',30,'view_reminder'),(121,'Can add kv store',31,'add_kvstore'),(122,'Can change kv store',31,'change_kvstore'),(123,'Can delete kv store',31,'delete_kvstore'),(124,'Can view kv store',31,'view_kvstore'),(125,'Can add campaign',32,'add_campaign'),(126,'Can change campaign',32,'change_campaign'),(127,'Can delete campaign',32,'delete_campaign'),(128,'Can view campaign',32,'view_campaign'),(129,'Can add campaign link click',33,'add_campaignlinkclick'),(130,'Can change campaign link click',33,'change_campaignlinkclick'),(131,'Can delete campaign link click',33,'delete_campaignlinkclick'),(132,'Can view campaign link click',33,'view_campaignlinkclick'),(133,'Can add campaign log',34,'add_campaignlog'),(134,'Can change campaign log',34,'change_campaignlog'),(135,'Can delete campaign log',34,'delete_campaignlog'),(136,'Can view campaign log',34,'view_campaignlog'),(137,'Can add campaign open',35,'add_campaignopen'),(138,'Can change campaign open',35,'change_campaignopen'),(139,'Can delete campaign open',35,'delete_campaignopen'),(140,'Can view campaign open',35,'view_campaignopen'),(141,'Can add contact',36,'add_contact'),(142,'Can change contact',36,'change_contact'),(143,'Can delete contact',36,'delete_contact'),(144,'Can view contact',36,'view_contact'),(145,'Can add contact list',37,'add_contactlist'),(146,'Can change contact list',37,'change_contactlist'),(147,'Can delete contact list',37,'delete_contactlist'),(148,'Can view contact list',37,'view_contactlist'),(149,'Can add email template',38,'add_emailtemplate'),(150,'Can change email template',38,'change_emailtemplate'),(151,'Can delete email template',38,'delete_emailtemplate'),(152,'Can view email template',38,'view_emailtemplate'),(153,'Can add link',39,'add_link'),(154,'Can change link',39,'change_link'),(155,'Can delete link',39,'delete_link'),(156,'Can view link',39,'view_link'),(157,'Can add tag',40,'add_tag'),(158,'Can change tag',40,'change_tag'),(159,'Can delete tag',40,'delete_tag'),(160,'Can view tag',40,'view_tag'),(161,'Can add failed contact',41,'add_failedcontact'),(162,'Can change failed contact',41,'change_failedcontact'),(163,'Can delete failed contact',41,'delete_failedcontact'),(164,'Can view failed contact',41,'view_failedcontact'),(165,'Can add campaign completed',42,'add_campaigncompleted'),(166,'Can change campaign completed',42,'change_campaigncompleted'),(167,'Can delete campaign completed',42,'delete_campaigncompleted'),(168,'Can view campaign completed',42,'view_campaigncompleted'),(169,'Can add contact unsubscribed campaign',43,'add_contactunsubscribedcampaign'),(170,'Can change contact unsubscribed campaign',43,'change_contactunsubscribedcampaign'),(171,'Can delete contact unsubscribed campaign',43,'delete_contactunsubscribedcampaign'),(172,'Can view contact unsubscribed campaign',43,'view_contactunsubscribedcampaign'),(173,'Can add contact email campaign',44,'add_contactemailcampaign'),(174,'Can change contact email campaign',44,'change_contactemailcampaign'),(175,'Can delete contact email campaign',44,'delete_contactemailcampaign'),(176,'Can view contact email campaign',44,'view_contactemailcampaign'),(177,'Can add duplicate contacts',45,'add_duplicatecontacts'),(178,'Can change duplicate contacts',45,'change_duplicatecontacts'),(179,'Can delete duplicate contacts',45,'delete_duplicatecontacts'),(180,'Can view duplicate contacts',45,'view_duplicatecontacts'),(181,'Can add blocked email',46,'add_blockedemail'),(182,'Can change blocked email',46,'change_blockedemail'),(183,'Can delete blocked email',46,'delete_blockedemail'),(184,'Can view blocked email',46,'view_blockedemail'),(185,'Can add blocked domain',47,'add_blockeddomain'),(186,'Can change blocked domain',47,'change_blockeddomain'),(187,'Can delete blocked domain',47,'delete_blockeddomain'),(188,'Can view blocked domain',47,'view_blockeddomain'),(189,'Can add task',48,'add_task'),(190,'Can change task',48,'change_task'),(191,'Can delete task',48,'delete_task'),(192,'Can view task',48,'view_task'),(193,'Can add Invoice',49,'add_invoice'),(194,'Can change Invoice',49,'change_invoice'),(195,'Can delete Invoice',49,'delete_invoice'),(196,'Can view Invoice',49,'view_invoice'),(197,'Can add invoice history',50,'add_invoicehistory'),(198,'Can change invoice history',50,'change_invoicehistory'),(199,'Can delete invoice history',50,'delete_invoicehistory'),(200,'Can view invoice history',50,'view_invoicehistory'),(201,'Can add event',51,'add_event'),(202,'Can change event',51,'change_event'),(203,'Can delete event',51,'delete_event'),(204,'Can view event',51,'view_event'),(205,'Can add teams',52,'add_teams'),(206,'Can change teams',52,'change_teams'),(207,'Can delete teams',52,'delete_teams'),(208,'Can view teams',52,'view_teams');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cases_case`
--

DROP TABLE IF EXISTS `cases_case`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cases_case` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `status` varchar(64) NOT NULL,
  `priority` varchar(64) NOT NULL,
  `case_type` varchar(255) DEFAULT NULL,
  `closed_on` date DEFAULT NULL,
  `description` longtext,
  `created_on` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `phone1` varchar(10) DEFAULT NULL,
  `action_items` longtext,
  `address` longtext,
  `assigned_date` datetime(6) DEFAULT NULL,
  `case_number` varchar(100) DEFAULT NULL,
  `creation_date` datetime(6) DEFAULT NULL,
  `email` varchar(254),
  `remark` longtext,
  `sla` datetime(6) DEFAULT NULL,
  `parent_case` varchar(255),
  `parent_description` longtext,
  PRIMARY KEY (`id`),
  KEY `cases_case_account_id_18367a6b_fk_accounts_account_id` (`account_id`),
  KEY `cases_case_created_by_id_91d115ec_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `cases_case_account_id_18367a6b_fk_accounts_account_id` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `cases_case_created_by_id_91d115ec_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases_case`
--

LOCK TABLES `cases_case` WRITE;
/*!40000 ALTER TABLE `cases_case` DISABLE KEYS */;
INSERT INTO `cases_case` VALUES (46,'raj','Open','Critical','Enquiry',NULL,'accident','2020-06-05 04:30:32.794825',0,NULL,1,'9876567898','','chennai','2020-06-05 04:30:32.714761','C_001','2020-06-05 04:30:32.714749','raj@gmail.com','','2020-06-05 05:00:32.794825',NULL,''),(49,'bamu','Closed','Not Critical','Enquiry','2020-06-10','about the custom sevices','2020-06-05 09:18:38.638750',0,NULL,1,'9867856785','','pondy','2020-06-05 09:18:38.606979','C_002','2020-06-05 09:18:38.606968','bamu@gmail.com','','2020-06-05 09:58:38.000000',NULL,''),(51,'abcd','In Progress','Critical','Ambulance Service','2020-06-09','emergency case accident','2020-06-09 11:24:41.634912',0,NULL,1,'9895678578','','pune','2020-06-09 11:24:41.614349','C_003','2020-06-09 11:24:41.614322','abcd@gmail.com','','2020-06-09 12:04:41.634912','C_001','accident'),(52,'xyz','Open','Not Critical','Compliments',NULL,'','2020-06-09 13:08:48.740904',0,NULL,1,'9876567898','','abn','2020-06-09 13:08:48.655788','C_004','2020-06-09 13:08:48.655777','xyj@gmail.com','','2020-06-09 13:38:48.740904',NULL,''),(53,'devi','In Progress','Not Critical','Feedback','2020-06-10','feedbck','2020-06-10 04:06:57.965937',0,NULL,1,'8905678967','','mumbai','2020-06-10 04:06:57.883725','C_005','2020-06-10 04:06:57.883715','devi@gmail.com','','2020-06-10 04:46:57.965937','C_004',''),(54,'mnop','Open','Not Critical','Enquiry',NULL,'xcb sdfghjkl asdfghjkl sdfgjk','2020-06-11 05:54:46.307207',0,NULL,2,'9876567890','','cvbnm','2020-06-11 05:54:46.204833','C_006','2020-06-11 05:54:46.204821','mnop@gmail.com','','2020-06-11 06:24:46.307207','C_004',''),(55,'pqrst','Open','Critical','Feedback',NULL,'asdfghj asdfgjkl dfghj sdfghjkldfkb dfghjk','2020-06-11 05:55:54.506356',0,NULL,2,'8945678905','','wertyui','2020-06-11 05:55:54.466579','C_007','2020-06-11 05:55:54.466567','pqrst@gmail.com','','2020-06-11 06:25:54.506356',NULL,''),(56,'janani','Open','Not Critical','Enquiry',NULL,'dsfghjk','2020-06-11 06:53:01.113184',0,NULL,1,NULL,'','pondy','2020-06-11 06:53:01.063552','C_008','2020-06-11 06:53:01.063539',NULL,'','2020-06-11 07:23:01.113184','C_006','xcb sdfghjkl asdfghjkl sdfgjk'),(57,'nivi','Open','Not Critical','Feedback',NULL,'suhjknm','2020-06-15 12:51:13.918710',0,NULL,1,'9878965678','','pune','2020-06-15 12:51:13.855103','C_009','2020-06-15 12:51:13.855093','nivi@gmail.com','','2020-06-15 13:21:13.918710',NULL,''),(58,'tony','In Progress','Not Critical','Enquiry','2020-06-18','zxcbm','2020-06-18 12:33:21.975697',0,NULL,1,'9890989668','','chennai','2020-06-18 12:33:21.864532','C_0010','2020-06-18 12:33:21.864518','tony@gmail.com','','2020-06-18 13:13:21.975697',NULL,''),(59,'rishi','Open','Critical','Feedback',NULL,'wertyuio','2020-06-18 12:33:59.005479',0,NULL,1,'8905678956','','pune','2020-06-18 12:33:58.952871','C_0011','2020-06-18 12:33:58.952857','rishi@gmail.com','','2020-06-18 13:03:59.005479',NULL,''),(60,'gopi','Open','Not Critical','Sales',NULL,'qwertyui','2020-06-18 12:35:22.040611',0,NULL,2,'9034567234','','mumbai','2020-06-18 12:35:21.997336','C_0012','2020-06-18 12:35:21.997323','gopi@gmail.com','','2020-06-18 13:05:22.040611',NULL,''),(61,'banu','In Progress','Not Critical','Ambulance Service','2020-06-18','wertyukcvb','2020-06-18 12:35:46.312703',0,NULL,2,'8945678934','','xcvbn','2020-06-18 12:35:46.263291','C_0013','2020-06-18 12:35:46.263280','bamu@gmail.com','','2020-06-18 13:15:46.312703',NULL,''),(62,'vel','Closed','Not Critical','Feedback','2020-06-18','','2020-06-18 12:36:25.316345',0,NULL,2,'7890567894','','delhi','2020-06-18 12:36:25.273730','C_0014','2020-06-18 12:36:25.273719','vel@gmail.comqwertyuio','','2020-06-18 13:06:25.000000',NULL,'');
/*!40000 ALTER TABLE `cases_case` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cases_case_assigned_to`
--

DROP TABLE IF EXISTS `cases_case_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cases_case_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `case_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cases_case_assigned_to_case_id_user_id_d3edec98_uniq` (`case_id`,`user_id`),
  KEY `cases_case_assigned_to_user_id_475b56e3_fk_common_user_id` (`user_id`),
  CONSTRAINT `cases_case_assigned_to_case_id_2e4863d1_fk_cases_case_id` FOREIGN KEY (`case_id`) REFERENCES `cases_case` (`id`),
  CONSTRAINT `cases_case_assigned_to_user_id_475b56e3_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases_case_assigned_to`
--

LOCK TABLES `cases_case_assigned_to` WRITE;
/*!40000 ALTER TABLE `cases_case_assigned_to` DISABLE KEYS */;
INSERT INTO `cases_case_assigned_to` VALUES (66,46,1),(77,49,1),(73,51,1),(74,52,1),(76,53,1),(78,56,1),(79,57,1),(82,58,1),(81,59,1);
/*!40000 ALTER TABLE `cases_case_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cases_case_contacts`
--

DROP TABLE IF EXISTS `cases_case_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cases_case_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `case_id` int(11) NOT NULL,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cases_case_contacts_case_id_contact_id_79772048_uniq` (`case_id`,`contact_id`),
  KEY `cases_case_contacts_contact_id_b13062a2_fk_contacts_contact_id` (`contact_id`),
  CONSTRAINT `cases_case_contacts_case_id_76980f08_fk_cases_case_id` FOREIGN KEY (`case_id`) REFERENCES `cases_case` (`id`),
  CONSTRAINT `cases_case_contacts_contact_id_b13062a2_fk_contacts_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases_case_contacts`
--

LOCK TABLES `cases_case_contacts` WRITE;
/*!40000 ALTER TABLE `cases_case_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `cases_case_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cases_case_teams`
--

DROP TABLE IF EXISTS `cases_case_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cases_case_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `case_id` int(11) NOT NULL,
  `teams_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cases_case_teams_case_id_teams_id_975db1af_uniq` (`case_id`,`teams_id`),
  KEY `cases_case_teams_teams_id_48201301_fk_teams_teams_id` (`teams_id`),
  CONSTRAINT `cases_case_teams_case_id_18a51654_fk_cases_case_id` FOREIGN KEY (`case_id`) REFERENCES `cases_case` (`id`),
  CONSTRAINT `cases_case_teams_teams_id_48201301_fk_teams_teams_id` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases_case_teams`
--

LOCK TABLES `cases_case_teams` WRITE;
/*!40000 ALTER TABLE `cases_case_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `cases_case_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_address`
--

DROP TABLE IF EXISTS `common_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address_line` varchar(255) DEFAULT NULL,
  `street` varchar(55) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `postcode` varchar(64) DEFAULT NULL,
  `country` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_address`
--

LOCK TABLES `common_address` WRITE;
/*!40000 ALTER TABLE `common_address` DISABLE KEYS */;
INSERT INTO `common_address` VALUES (1,'32',NULL,'chennai','tamil nadu','60701','IN'),(2,'32',NULL,'pondy','tamil nadu','6799','IN'),(3,'29',NULL,'pondy','pondy','780','IN'),(4,'12',NULL,NULL,'tamilnadu','6010','IN'),(5,'23',NULL,'chennai','tamil nadu','607','IN'),(6,NULL,NULL,NULL,NULL,NULL,'IN');
/*!40000 ALTER TABLE `common_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_apisettings`
--

DROP TABLE IF EXISTS `common_apisettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_apisettings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(1000) NOT NULL,
  `apikey` varchar(16) NOT NULL,
  `created_on` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `website` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `common_apisettings_created_by_id_98c6c22e_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `common_apisettings_created_by_id_98c6c22e_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_apisettings`
--

LOCK TABLES `common_apisettings` WRITE;
/*!40000 ALTER TABLE `common_apisettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_apisettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_apisettings_lead_assigned_to`
--

DROP TABLE IF EXISTS `common_apisettings_lead_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_apisettings_lead_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `apisettings_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `common_apisettings_lead__apisettings_id_user_id_31b7a12b_uniq` (`apisettings_id`,`user_id`),
  KEY `common_apisettings_l_user_id_0e624afc_fk_common_us` (`user_id`),
  CONSTRAINT `common_apisettings_l_apisettings_id_bcb9b4d4_fk_common_ap` FOREIGN KEY (`apisettings_id`) REFERENCES `common_apisettings` (`id`),
  CONSTRAINT `common_apisettings_l_user_id_0e624afc_fk_common_us` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_apisettings_lead_assigned_to`
--

LOCK TABLES `common_apisettings_lead_assigned_to` WRITE;
/*!40000 ALTER TABLE `common_apisettings_lead_assigned_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_apisettings_lead_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_apisettings_tags`
--

DROP TABLE IF EXISTS `common_apisettings_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_apisettings_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `apisettings_id` int(11) NOT NULL,
  `tags_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `common_apisettings_tags_apisettings_id_tags_id_74019ad7_uniq` (`apisettings_id`,`tags_id`),
  KEY `common_apisettings_tags_tags_id_53f647a4_fk_accounts_tags_id` (`tags_id`),
  CONSTRAINT `common_apisettings_t_apisettings_id_37ac3e70_fk_common_ap` FOREIGN KEY (`apisettings_id`) REFERENCES `common_apisettings` (`id`),
  CONSTRAINT `common_apisettings_tags_tags_id_53f647a4_fk_accounts_tags_id` FOREIGN KEY (`tags_id`) REFERENCES `accounts_tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_apisettings_tags`
--

LOCK TABLES `common_apisettings_tags` WRITE;
/*!40000 ALTER TABLE `common_apisettings_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_apisettings_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_attachments`
--

DROP TABLE IF EXISTS `common_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(60) NOT NULL,
  `created_on` datetime(6) NOT NULL,
  `attachment` varchar(1001) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `contact_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `lead_id` int(11) DEFAULT NULL,
  `opportunity_id` int(11) DEFAULT NULL,
  `case_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `common_attachments_account_id_3ded5aec_fk_accounts_account_id` (`account_id`),
  KEY `common_attachments_contact_id_f32626af_fk_contacts_contact_id` (`contact_id`),
  KEY `common_attachments_lead_id_408ab6f8_fk_leads_lead_id` (`lead_id`),
  KEY `common_attachments_opportunity_id_55c921d1_fk_opportuni` (`opportunity_id`),
  KEY `common_attachments_case_id_9141eaa4_fk_cases_case_id` (`case_id`),
  KEY `common_attachments_created_by_id_de1aec79_fk_common_user_id` (`created_by_id`),
  KEY `common_attachments_task_id_a2c58513_fk_tasks_task_id` (`task_id`),
  KEY `common_attachments_invoice_id_5a2e90d0_fk_invoices_invoice_id` (`invoice_id`),
  KEY `common_attachments_event_id_a2570824_fk_events_event_id` (`event_id`),
  CONSTRAINT `common_attachments_account_id_3ded5aec_fk_accounts_account_id` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `common_attachments_case_id_9141eaa4_fk_cases_case_id` FOREIGN KEY (`case_id`) REFERENCES `cases_case` (`id`),
  CONSTRAINT `common_attachments_contact_id_f32626af_fk_contacts_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `common_attachments_created_by_id_de1aec79_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`),
  CONSTRAINT `common_attachments_event_id_a2570824_fk_events_event_id` FOREIGN KEY (`event_id`) REFERENCES `events_event` (`id`),
  CONSTRAINT `common_attachments_invoice_id_5a2e90d0_fk_invoices_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `invoices_invoice` (`id`),
  CONSTRAINT `common_attachments_lead_id_408ab6f8_fk_leads_lead_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_lead` (`id`),
  CONSTRAINT `common_attachments_opportunity_id_55c921d1_fk_opportuni` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity_opportunity` (`id`),
  CONSTRAINT `common_attachments_task_id_a2c58513_fk_tasks_task_id` FOREIGN KEY (`task_id`) REFERENCES `tasks_task` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_attachments`
--

LOCK TABLES `common_attachments` WRITE;
/*!40000 ALTER TABLE `common_attachments` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_attachments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_comment`
--

DROP TABLE IF EXISTS `common_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_comment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` varchar(255) NOT NULL,
  `commented_on` datetime(6) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `case_id` int(11) DEFAULT NULL,
  `commented_by_id` int(11) DEFAULT NULL,
  `contact_id` int(11) DEFAULT NULL,
  `lead_id` int(11) DEFAULT NULL,
  `opportunity_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `common_comment_account_id_dfaa7135_fk_accounts_account_id` (`account_id`),
  KEY `common_comment_case_id_1869f987_fk_cases_case_id` (`case_id`),
  KEY `common_comment_commented_by_id_d25d4735_fk_common_user_id` (`commented_by_id`),
  KEY `common_comment_contact_id_5001da5f_fk_contacts_contact_id` (`contact_id`),
  KEY `common_comment_opportunity_id_69135f56_fk_opportuni` (`opportunity_id`),
  KEY `common_comment_user_id_06e537fc_fk_common_user_id` (`user_id`),
  KEY `common_comment_task_id_4d5c683f_fk_tasks_task_id` (`task_id`),
  KEY `common_comment_invoice_id_56094310_fk_invoices_invoice_id` (`invoice_id`),
  KEY `common_comment_event_id_743a165c_fk_events_event_id` (`event_id`),
  KEY `common_comment_lead_id_a06ba983_fk_leads_lead_id` (`lead_id`),
  CONSTRAINT `common_comment_account_id_dfaa7135_fk_accounts_account_id` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `common_comment_case_id_1869f987_fk_cases_case_id` FOREIGN KEY (`case_id`) REFERENCES `cases_case` (`id`),
  CONSTRAINT `common_comment_commented_by_id_d25d4735_fk_common_user_id` FOREIGN KEY (`commented_by_id`) REFERENCES `common_user` (`id`),
  CONSTRAINT `common_comment_contact_id_5001da5f_fk_contacts_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `common_comment_event_id_743a165c_fk_events_event_id` FOREIGN KEY (`event_id`) REFERENCES `events_event` (`id`),
  CONSTRAINT `common_comment_invoice_id_56094310_fk_invoices_invoice_id` FOREIGN KEY (`invoice_id`) REFERENCES `invoices_invoice` (`id`),
  CONSTRAINT `common_comment_lead_id_a06ba983_fk_leads_lead_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_lead` (`id`),
  CONSTRAINT `common_comment_opportunity_id_69135f56_fk_opportuni` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity_opportunity` (`id`),
  CONSTRAINT `common_comment_task_id_4d5c683f_fk_tasks_task_id` FOREIGN KEY (`task_id`) REFERENCES `tasks_task` (`id`),
  CONSTRAINT `common_comment_user_id_06e537fc_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_comment`
--

LOCK TABLES `common_comment` WRITE;
/*!40000 ALTER TABLE `common_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_comment_files`
--

DROP TABLE IF EXISTS `common_comment_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_comment_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `updated_on` datetime(6) NOT NULL,
  `comment_file` varchar(100) NOT NULL,
  `comment_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `common_comment_files_comment_id_4a871ebd_fk_common_comment_id` (`comment_id`),
  CONSTRAINT `common_comment_files_comment_id_4a871ebd_fk_common_comment_id` FOREIGN KEY (`comment_id`) REFERENCES `common_comment` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_comment_files`
--

LOCK TABLES `common_comment_files` WRITE;
/*!40000 ALTER TABLE `common_comment_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_comment_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_document`
--

DROP TABLE IF EXISTS `common_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_document` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(1000) DEFAULT NULL,
  `document_file` varchar(5000) NOT NULL,
  `created_on` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `status` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `common_document_created_by_id_19742726_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `common_document_created_by_id_19742726_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_document`
--

LOCK TABLES `common_document` WRITE;
/*!40000 ALTER TABLE `common_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_document_shared_to`
--

DROP TABLE IF EXISTS `common_document_shared_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_document_shared_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `common_document_shared_to_document_id_user_id_270c028b_uniq` (`document_id`,`user_id`),
  KEY `common_document_shared_to_user_id_09ae644f_fk_common_user_id` (`user_id`),
  CONSTRAINT `common_document_shar_document_id_f5146fd1_fk_common_do` FOREIGN KEY (`document_id`) REFERENCES `common_document` (`id`),
  CONSTRAINT `common_document_shared_to_user_id_09ae644f_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_document_shared_to`
--

LOCK TABLES `common_document_shared_to` WRITE;
/*!40000 ALTER TABLE `common_document_shared_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_document_shared_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_document_teams`
--

DROP TABLE IF EXISTS `common_document_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_document_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `teams_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `common_document_teams_document_id_teams_id_1a1b5d77_uniq` (`document_id`,`teams_id`),
  KEY `common_document_teams_teams_id_17146b17_fk_teams_teams_id` (`teams_id`),
  CONSTRAINT `common_document_teams_document_id_494fb8a5_fk_common_document_id` FOREIGN KEY (`document_id`) REFERENCES `common_document` (`id`),
  CONSTRAINT `common_document_teams_teams_id_17146b17_fk_teams_teams_id` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_document_teams`
--

LOCK TABLES `common_document_teams` WRITE;
/*!40000 ALTER TABLE `common_document_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_document_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_google`
--

DROP TABLE IF EXISTS `common_google`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_google` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `google_id` varchar(200) NOT NULL,
  `google_url` varchar(1000) NOT NULL,
  `verified_email` varchar(200) NOT NULL,
  `family_name` varchar(200) NOT NULL,
  `name` varchar(200) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `dob` varchar(50) NOT NULL,
  `given_name` varchar(200) NOT NULL,
  `email` varchar(200) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `common_google_user_id_83499ce5_fk_common_user_id` (`user_id`),
  KEY `common_google_email_cc75d7a4` (`email`),
  CONSTRAINT `common_google_user_id_83499ce5_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_google`
--

LOCK TABLES `common_google` WRITE;
/*!40000 ALTER TABLE `common_google` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_google` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_profile`
--

DROP TABLE IF EXISTS `common_profile`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_profile` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activation_key` varchar(50) NOT NULL,
  `key_expires` datetime(6) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `common_profile_user_id_8573ee5c_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_profile`
--

LOCK TABLES `common_profile` WRITE;
/*!40000 ALTER TABLE `common_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_profile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_user`
--

DROP TABLE IF EXISTS `common_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(100) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(255) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `is_admin` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `role` varchar(50) NOT NULL,
  `profile_pic` varchar(1000) DEFAULT NULL,
  `has_marketing_access` tinyint(1) NOT NULL,
  `has_sales_access` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_user`
--

LOCK TABLES `common_user` WRITE;
/*!40000 ALTER TABLE `common_user` DISABLE KEYS */;
INSERT INTO `common_user` VALUES (1,'pbkdf2_sha256$150000$op6hKR7ImmYr$S1wZ3v30ydgSbJWCYbngRC9R3Lkscg1+x9Kcud09QwU=','2020-06-18 12:37:56.302486',1,'admin','','','admin@gmail.com',1,0,1,'2020-05-04 04:47:41.452915','','',0,0),(2,'pbkdf2_sha256$150000$oL9SOMZhziTF$v2IUqALxl78dhEXsOcwMLyrPDAHur4/XskgPemJ61T0=','2020-06-18 12:34:37.139385',0,'naren','naren','r','naren@gmail.com',1,0,0,'2020-06-01 10:35:42.525430','USER','',1,1),(3,'pbkdf2_sha256$150000$GTi3zhwBbwET$eH591vbhNH9QvOEJjwR7D5cd9UxwwbRDNbXP4gDxbRQ=',NULL,0,'raj','rajesh','s','rajesh@gmail.com',1,0,0,'2020-06-01 10:37:36.780913','USER','',1,1);
/*!40000 ALTER TABLE `common_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_user_groups`
--

DROP TABLE IF EXISTS `common_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `common_user_groups_user_id_group_id_ba201ca9_uniq` (`user_id`,`group_id`),
  KEY `common_user_groups_group_id_27a26245_fk_auth_group_id` (`group_id`),
  CONSTRAINT `common_user_groups_group_id_27a26245_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `common_user_groups_user_id_92ddbe7a_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_user_groups`
--

LOCK TABLES `common_user_groups` WRITE;
/*!40000 ALTER TABLE `common_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `common_user_user_permissions`
--

DROP TABLE IF EXISTS `common_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `common_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `common_user_user_permissions_user_id_permission_id_5694f4c4_uniq` (`user_id`,`permission_id`),
  KEY `common_user_user_per_permission_id_a6da427c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `common_user_user_per_permission_id_a6da427c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `common_user_user_permissions_user_id_56b84879_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_user_user_permissions`
--

LOCK TABLES `common_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `common_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `common_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts_contact`
--

DROP TABLE IF EXISTS `contacts_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts_contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `description` longtext,
  `created_on` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `address_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `phone1` varchar(10) DEFAULT NULL,
  `phone2` varchar(10) DEFAULT NULL,
  `company_name` varchar(220) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone1` (`phone1`),
  UNIQUE KEY `phone2` (`phone2`),
  KEY `contacts_contact_address_id_0dbb18a0_fk_common_address_id` (`address_id`),
  KEY `contacts_contact_created_by_id_57537352_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `contacts_contact_address_id_0dbb18a0_fk_common_address_id` FOREIGN KEY (`address_id`) REFERENCES `common_address` (`id`),
  CONSTRAINT `contacts_contact_created_by_id_57537352_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts_contact`
--

LOCK TABLES `contacts_contact` WRITE;
/*!40000 ALTER TABLE `contacts_contact` DISABLE KEYS */;
INSERT INTO `contacts_contact` VALUES (1,'raj','kumar','raj@gmail.com','','2020-05-04 05:39:59.622266',0,1,1,'9764974567','9678987656','zoora'),(2,'bhavani','priya','bhavani@gmail.com','','2020-05-18 06:29:10.529267',0,2,1,'9876789876','9098755677',NULL),(3,'sakthi','vel','sakthi@gmail.com','','2020-05-19 03:48:23.260127',0,3,1,'9023456121','8901298879','tcs'),(4,'def','a','def@gmail.com','','2020-06-04 09:43:14.928084',0,4,1,'9678956789','9456785678','zoo'),(5,'abc','a','ascdf@gmail.com','','2020-06-08 04:33:27.934632',0,5,1,'9878909890','9878967895','abcd'),(6,'abcd','s','','','2020-06-09 06:35:06.114819',0,6,1,'9678967890','8907667894','xyz');
/*!40000 ALTER TABLE `contacts_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts_contact_assigned_to`
--

DROP TABLE IF EXISTS `contacts_contact_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts_contact_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contacts_contact_assigned_to_contact_id_user_id_145bff71_uniq` (`contact_id`,`user_id`),
  KEY `contacts_contact_assigned_to_user_id_727306dd_fk_common_user_id` (`user_id`),
  CONSTRAINT `contacts_contact_ass_contact_id_0269bc5d_fk_contacts_` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `contacts_contact_assigned_to_user_id_727306dd_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts_contact_assigned_to`
--

LOCK TABLES `contacts_contact_assigned_to` WRITE;
/*!40000 ALTER TABLE `contacts_contact_assigned_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacts_contact_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contacts_contact_teams`
--

DROP TABLE IF EXISTS `contacts_contact_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts_contact_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) NOT NULL,
  `teams_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contacts_contact_teams_contact_id_teams_id_70cea3c6_uniq` (`contact_id`,`teams_id`),
  KEY `contacts_contact_teams_teams_id_b69a29e7_fk_teams_teams_id` (`teams_id`),
  CONSTRAINT `contacts_contact_tea_contact_id_76009c86_fk_contacts_` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `contacts_contact_teams_teams_id_b69a29e7_fk_teams_teams_id` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts_contact_teams`
--

LOCK TABLES `contacts_contact_teams` WRITE;
/*!40000 ALTER TABLE `contacts_contact_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacts_contact_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (14,'accounts','account'),(16,'accounts','email'),(17,'accounts','emaillog'),(15,'accounts','tags'),(2,'auth','group'),(1,'auth','permission'),(18,'cases','case'),(19,'cases','sla'),(20,'cases','slaemail'),(21,'cases','slavoice'),(22,'cases','updatedcase'),(6,'common','address'),(12,'common','apisettings'),(7,'common','attachments'),(8,'common','comment'),(9,'common','comment_files'),(10,'common','document'),(11,'common','google'),(13,'common','profile'),(5,'common','user'),(23,'contacts','contact'),(25,'contacts','emailinfo'),(24,'contacts','multimail'),(3,'contenttypes','contenttype'),(26,'emails','email'),(51,'events','event'),(49,'invoices','invoice'),(50,'invoices','invoicehistory'),(27,'leads','lead'),(47,'marketing','blockeddomain'),(46,'marketing','blockedemail'),(32,'marketing','campaign'),(42,'marketing','campaigncompleted'),(33,'marketing','campaignlinkclick'),(34,'marketing','campaignlog'),(35,'marketing','campaignopen'),(36,'marketing','contact'),(44,'marketing','contactemailcampaign'),(37,'marketing','contactlist'),(43,'marketing','contactunsubscribedcampaign'),(45,'marketing','duplicatecontacts'),(38,'marketing','emailtemplate'),(41,'marketing','failedcontact'),(39,'marketing','link'),(40,'marketing','tag'),(28,'opportunity','opportunity'),(29,'planner','event'),(30,'planner','reminder'),(4,'sessions','session'),(48,'tasks','task'),(52,'teams','teams'),(31,'thumbnail','kvstore');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=124 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'accounts','0001_initial','2020-05-04 04:39:25.283783'),(2,'cases','0001_initial','2020-05-04 04:39:25.908220'),(3,'common','0001_initial','2020-05-04 04:39:31.205757'),(4,'teams','0001_initial','2020-05-04 04:39:39.082119'),(5,'teams','0002_auto_20190624_1250','2020-05-04 04:39:43.158372'),(6,'teams','0003_auto_20190909_1621','2020-05-04 04:39:44.147458'),(7,'contacts','0001_initial','2020-05-04 04:39:45.825280'),(8,'contacts','0002_auto_20190212_1334','2020-05-04 04:39:58.881846'),(9,'contacts','0002_auto_20190210_1810','2020-05-04 04:39:58.946644'),(10,'contacts','0003_merge_20190214_1427','2020-05-04 04:39:58.997417'),(11,'leads','0001_initial','2020-05-04 04:40:00.608594'),(12,'accounts','0002_auto_20190128_1237','2020-05-04 04:40:11.462934'),(13,'accounts','0003_auto_20190201_1840','2020-05-04 04:40:20.270144'),(14,'leads','0002_lead_tags','2020-05-04 04:40:23.221087'),(15,'leads','0003_auto_20190211_1142','2020-05-04 04:40:26.612002'),(16,'leads','0004_auto_20190212_1334','2020-05-04 04:40:30.752943'),(17,'accounts','0004_account_status','2020-05-04 04:40:34.033093'),(18,'accounts','0005_auto_20190212_1334','2020-05-04 04:40:37.822543'),(19,'accounts','0006_auto_20190212_1708','2020-05-04 04:40:49.091355'),(20,'accounts','0007_email','2020-05-04 04:40:49.752781'),(21,'accounts','0008_account_assigned_to','2020-05-04 04:40:51.998899'),(22,'accounts','0009_auto_20190809_1659','2020-05-04 04:41:03.774413'),(23,'accounts','0010_account_teams','2020-05-04 04:41:08.432668'),(24,'contenttypes','0001_initial','2020-05-04 04:41:12.361316'),(25,'contenttypes','0002_remove_content_type_name','2020-05-04 04:41:13.709076'),(26,'auth','0001_initial','2020-05-04 04:41:17.805258'),(27,'auth','0002_alter_permission_name_max_length','2020-05-04 04:41:22.253567'),(28,'auth','0003_alter_user_email_max_length','2020-05-04 04:41:22.322337'),(29,'auth','0004_alter_user_username_opts','2020-05-04 04:41:22.391499'),(30,'auth','0005_alter_user_last_login_null','2020-05-04 04:41:22.459347'),(31,'auth','0006_require_contenttypes_0002','2020-05-04 04:41:22.527464'),(32,'auth','0007_alter_validators_add_error_messages','2020-05-04 04:41:22.629664'),(33,'auth','0008_alter_user_username_max_length','2020-05-04 04:41:22.695270'),(34,'auth','0009_alter_user_last_name_max_length','2020-05-04 04:41:22.762955'),(35,'auth','0010_alter_group_name_max_length','2020-05-04 04:41:22.925653'),(36,'auth','0011_update_proxy_permissions','2020-05-04 04:41:23.006930'),(37,'auth','0012_auto_20200208_0939','2020-05-04 04:41:24.031741'),(38,'auth','0013_auto_20200217_0648','2020-05-04 04:41:24.241241'),(39,'cases','0002_auto_20190128_1237','2020-05-04 04:41:26.560636'),(40,'cases','0003_auto_20190212_1334','2020-05-04 04:41:37.834226'),(41,'cases','0004_case_teams','2020-05-04 04:41:38.376833'),(42,'cases','0005_case_phone1','2020-05-04 04:41:41.373150'),(43,'cases','0006_auto_20200127_1814','2020-05-04 04:41:41.759104'),(44,'cases','0007_auto_20200424_1725','2020-05-04 04:41:53.114509'),(45,'cases','0008_auto_20200425_2002','2020-05-04 04:41:56.001488'),(46,'events','0001_initial','2020-05-04 04:41:57.439264'),(47,'events','0002_event_date_of_meeting','2020-05-04 04:42:05.033770'),(48,'tasks','0001_initial','2020-05-04 04:42:06.470321'),(49,'tasks','0002_task_created_by','2020-05-04 04:42:12.807999'),(50,'opportunity','0001_initial','2020-05-04 04:42:15.672019'),(51,'common','0002_auto_20190128_1237','2020-05-04 04:42:33.923748'),(52,'planner','0001_initial','2020-05-04 04:42:53.512774'),(53,'planner','0002_auto_20190212_1334','2020-05-04 04:43:15.561899'),(54,'opportunity','0002_opportunity_tags','2020-05-04 04:43:16.122917'),(55,'opportunity','0003_auto_20190212_1334','2020-05-04 04:43:21.843312'),(56,'common','0003_document','2020-05-04 04:43:22.414685'),(57,'common','0004_attachments_case','2020-05-04 04:43:24.173536'),(58,'common','0005_auto_20190204_1400','2020-05-04 04:43:26.270197'),(59,'common','0006_comment_user','2020-05-04 04:43:27.200964'),(60,'common','0007_auto_20190212_1334','2020-05-04 04:43:33.181044'),(61,'common','0008_google','2020-05-04 04:43:33.752881'),(62,'common','0009_document_shared_to','2020-05-04 04:43:35.470080'),(63,'common','0010_apisettings','2020-05-04 04:43:39.145922'),(64,'common','0011_auto_20190218_1230','2020-05-04 04:43:45.413603'),(65,'common','0012_apisettings_website','2020-05-04 04:43:46.261335'),(66,'common','0013_auto_20190508_1540','2020-05-04 04:43:48.155301'),(67,'invoices','0001_initial','2020-05-04 04:43:51.573769'),(68,'invoices','0002_auto_20190524_1113','2020-05-04 04:43:57.005239'),(69,'common','0014_auto_20190524_1113','2020-05-04 04:43:58.889095'),(70,'common','0015_auto_20190604_1830','2020-05-04 04:44:03.403365'),(71,'common','0016_auto_20190624_1816','2020-05-04 04:44:08.826290'),(72,'common','0017_auto_20190722_1443','2020-05-04 04:44:09.577778'),(73,'common','0018_document_teams','2020-05-04 04:44:11.225772'),(74,'contacts','0004_contact_teams','2020-05-04 04:44:14.396798'),(75,'contacts','0005_auto_20200125_2131','2020-05-04 04:44:21.719858'),(76,'contacts','0006_auto_20200424_1725','2020-05-04 04:44:23.597210'),(77,'contacts','0007_auto_20200424_1728','2020-05-04 04:44:25.024536'),(78,'contacts','0008_auto_20200425_2002','2020-05-04 04:44:27.230674'),(79,'contacts','0009_emailinfo','2020-05-04 04:44:27.601054'),(80,'emails','0001_initial','2020-05-04 04:44:28.028170'),(81,'events','0003_event_teams','2020-05-04 04:44:28.673071'),(82,'invoices','0003_auto_20190527_1620','2020-05-04 04:44:32.636629'),(83,'invoices','0004_auto_20190603_1844','2020-05-04 04:44:32.751180'),(84,'invoices','0005_invoicehistory','2020-05-04 04:44:33.854554'),(85,'invoices','0006_invoice_account','2020-05-04 04:44:41.030007'),(86,'invoices','0007_auto_20190909_1621','2020-05-04 04:44:43.589907'),(87,'invoices','0008_invoice_teams','2020-05-04 04:44:44.262541'),(88,'leads','0005_auto_20190212_1708','2020-05-04 04:44:52.549531'),(89,'leads','0006_auto_20190218_1217','2020-05-04 04:44:52.695260'),(90,'leads','0007_auto_20190306_1226','2020-05-04 04:44:52.975672'),(91,'leads','0008_auto_20190315_1503','2020-05-04 04:44:55.392377'),(92,'leads','0009_lead_created_from_site','2020-05-04 04:44:56.307988'),(93,'leads','0010_lead_teams','2020-05-04 04:44:56.828938'),(94,'leads','0011_auto_20200425_1938','2020-05-04 04:45:00.330592'),(95,'marketing','0001_initial','2020-05-04 04:45:11.940396'),(96,'marketing','0002_auto_20190307_1227','2020-05-04 04:45:40.411971'),(97,'marketing','0003_failedcontact','2020-05-04 04:45:41.414204'),(98,'marketing','0004_auto_20190315_1443','2020-05-04 04:45:45.059132'),(99,'marketing','0005_campaign_timezone','2020-05-04 04:45:45.902276'),(100,'marketing','0006_campaign_attachment','2020-05-04 04:45:46.779007'),(101,'marketing','0007_auto_20190611_1226','2020-05-04 04:45:48.962992'),(102,'marketing','0008_auto_20190612_1905','2020-05-04 04:45:53.521078'),(103,'marketing','0009_auto_20190618_1144','2020-05-04 04:45:58.085387'),(104,'marketing','0010_auto_20190805_1038','2020-05-04 04:46:03.329667'),(105,'marketing','0011_auto_20190904_1143','2020-05-04 04:46:05.054312'),(106,'marketing','0012_auto_20190909_1621','2020-05-04 04:46:07.090950'),(107,'marketing','0013_blockeddomain_blockedemail','2020-05-04 04:46:08.246703'),(108,'marketing','0014_auto_20200504_0951','2020-05-04 04:46:11.667682'),(109,'marketing','0015_auto_20200504_0952','2020-05-04 04:46:13.355537'),(110,'marketing','0016_auto_20200504_1004','2020-05-04 04:46:13.954696'),(111,'opportunity','0004_opportunity_teams','2020-05-04 04:46:14.445268'),(112,'planner','0003_auto_20200424_1725','2020-05-04 04:46:18.260403'),(113,'planner','0004_auto_20200424_2040','2020-05-04 04:46:19.785290'),(114,'planner','0005_auto_20200425_1436','2020-05-04 04:46:21.200041'),(115,'planner','0006_auto_20200425_1945','2020-05-04 04:46:22.494791'),(116,'sessions','0001_initial','2020-05-04 04:46:23.645814'),(117,'tasks','0003_task_created_on','2020-05-04 04:46:24.879811'),(118,'tasks','0004_task_teams','2020-05-04 04:46:25.544438'),(119,'thumbnail','0001_initial','2020-05-04 04:46:28.408002'),(120,'cases','0009_auto_20200519_1141','2020-05-19 06:12:04.556007'),(121,'cases','0010_case_parent_case','2020-06-01 03:49:44.430893'),(122,'cases','0011_case_parent_description','2020-06-05 06:26:13.947358'),(123,'cases','0012_auto_20200605_1159','2020-06-05 06:29:44.801113');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('0wdoe2jmuewazrdmat2d9hyrdce6e21s','MGU0ODY3NDAzZmFkZTQ1MTIyZTFmOTM0ZjU1ZDYyZTNjMjBmNWM1Nzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIiwicGsiOjQ5fQ==','2020-06-19 09:45:41.644892'),('1x99wxabgtrlskagnwl92c3lc6y0c7fv','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-05-22 05:35:56.271611'),('240s6fyju4ba93jgxpmyrk391w9rqouc','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-05-27 04:16:30.844027'),('3fwhdtdoekqyp20bvxhy60jq366w8pxp','NTFmMzViODQ1MGJlMGQwNjU2NDA4MzczZjIxZTc3ZmQyMTEzZWViNTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIiwicGsiOjJ9','2020-05-19 05:56:19.398236'),('55vg97krl58su1bfre4skao4gfuyt1ht','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-06-16 03:50:18.792655'),('78swii80vbeuxc1k7lr9zgd690w61aqf','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-05-26 03:52:40.354429'),('95gh9nj90i7ukjwzl3j6cq3jtkundoer','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-06-13 05:16:24.244033'),('abhuc83iysgkzjdwm4zlt7iqxuo5fhs2','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-06-05 16:01:08.229356'),('ap3ah1sfsgcb7dirzx8mb1q23mpg60wc','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-05-21 04:05:15.391549'),('bqtelorormjn8hnmtiow43mb3mao9wi1','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-05-20 09:49:40.220101'),('buopfv6gmrwtgxh0giw6n0ruckbz4p92','YWQ5MjIzYzczMDcwYTk5ZWI5OGRiNmNlYjE3NTRiMjljOGE4ZGVmMjp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZWE4MTYzNmNhZGRlODFjNTMwZDIwZmUyMzcyYTU2YjhlNzZiYmE0In0=','2020-06-18 04:05:11.730310'),('ckjlh6r6nnd18uxjxgxy4tjpzwl0hdn9','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-05-21 04:23:11.703232'),('fc0j3izs31phsysxjh37m5rvujbnqasu','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-07-02 12:37:56.354888'),('g8joc36963x1z0eyrewpqrvm651lcsg7','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-07-02 04:16:05.166501'),('gd5e0n6lmudggo99pn2zkebq9r8dtmwq','MDNiN2FkYjI5MDkzMDkxNzVjZDkzN2Q0NjliYmQ5ZTg5NGExNThiZDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIiwicGsiOjI5fQ==','2020-06-15 12:08:19.938742'),('gmgkxhi4utuutxkwrng8jr6bpysq3ft2','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-07-01 09:51:37.794029'),('jagwy9vlybh9fpn9lx7pqicair9kva6m','MGU0ODY3NDAzZmFkZTQ1MTIyZTFmOTM0ZjU1ZDYyZTNjMjBmNWM1Nzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIiwicGsiOjQ5fQ==','2020-06-23 06:38:11.449248'),('jtbckuce32kp9od4cf4c3nlyarhgrkpw','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-06-13 05:15:43.828528'),('kjwrpol23plszcy2yiv53ltat30h7f2y','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-06-23 07:30:34.913962'),('kojyb2hkgouihn42krfnc1s3y8vnvitz','ZDEzOWUwYmM5ZWIzOTAzM2E4NmI3ZDlmYjU1NDNkNTViMmQ4YjcxZDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIiwicGsiOjIzfQ==','2020-06-05 12:20:40.866436'),('or69a5ty25g7926ny5lqrbj2nx4dtxuf','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-06-02 05:56:06.838605'),('p3ej6s4fgqf26bkrdet05mngdhc4z7gm','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-06-23 07:13:48.339767'),('qoiolx0cecrg4e97bq620sbzas9at7r6','NDgwZjEwNDhiMmUyODE2NDNiZGQzODNiNWYwNjEzNjVlMTAyZTc5Yjp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIiwicGsiOjU2fQ==','2020-06-26 06:50:38.015211'),('ta23kpqzlmke2kdis2j9j0l0kyxizzhn','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-05-27 04:45:58.011891'),('wvx2zv5denp4yuz2r86anxyt64yofo45','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-05-20 07:18:33.039726'),('y0srdg1m4hoj9mhmnnfr27furet0rv9x','ZmU4NGUxMTNkNzI2MGE1ODAzN2Q4MDBmYTE0Nzc3NDU5MWEwZTRkNTp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIiwicGsiOjQ2fQ==','2020-07-01 08:38:22.671920'),('y273w12fwiih490pjg5ao8lrxhwbjlpw','YTQ5NjBkOTc3ZTUyZGVhM2I0MmE4MmU1NGEwMDEwZDNiNDE2YjM1Njp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIiwicGsiOjEyfQ==','2020-06-01 05:31:30.741567'),('zro53loahbyd6egfayfufj0u911gx2ma','Y2I2NGRmZGFiNmVjZWMxMGIyYjRlZjIxOWM2MjBmNTM2MGVkNWViMzp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI2MDNmNjdhMDFjY2FhN2VjYmM1ZDc2YTEwYjcyNWU3MjQ0NjkxYzFiIn0=','2020-06-13 10:41:03.513235');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emailinfo`
--

DROP TABLE IF EXISTS `emailinfo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emailinfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject_inbox` longtext NOT NULL,
  `description` longtext NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `from_address` varchar(50) NOT NULL,
  `to_address` varchar(50) NOT NULL,
  `status` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emailinfo`
--

LOCK TABLES `emailinfo` WRITE;
/*!40000 ALTER TABLE `emailinfo` DISABLE KEYS */;
/*!40000 ALTER TABLE `emailinfo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `emails_email`
--

DROP TABLE IF EXISTS `emails_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emails_email` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `from_email` varchar(200) NOT NULL,
  `to_email` varchar(200) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `message` varchar(200) NOT NULL,
  `file` varchar(100) DEFAULT NULL,
  `send_time` datetime(6) NOT NULL,
  `status` varchar(200) NOT NULL,
  `important` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `emails_email`
--

LOCK TABLES `emails_email` WRITE;
/*!40000 ALTER TABLE `emails_email` DISABLE KEYS */;
/*!40000 ALTER TABLE `emails_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events_event`
--

DROP TABLE IF EXISTS `events_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `event_type` varchar(20) NOT NULL,
  `status` varchar(64) DEFAULT NULL,
  `start_date` date NOT NULL,
  `start_time` time(6) NOT NULL,
  `end_date` date NOT NULL,
  `end_time` time(6) DEFAULT NULL,
  `description` longtext,
  `created_on` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `disabled` tinyint(1) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `date_of_meeting` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `events_event_created_by_id_2c28ea90_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `events_event_created_by_id_2c28ea90_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events_event`
--

LOCK TABLES `events_event` WRITE;
/*!40000 ALTER TABLE `events_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `events_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events_event_assigned_to`
--

DROP TABLE IF EXISTS `events_event_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events_event_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `events_event_assigned_to_event_id_user_id_8d2e75e1_uniq` (`event_id`,`user_id`),
  KEY `events_event_assigned_to_user_id_88f9a1f0_fk_common_user_id` (`user_id`),
  CONSTRAINT `events_event_assigned_to_event_id_211aebd2_fk_events_event_id` FOREIGN KEY (`event_id`) REFERENCES `events_event` (`id`),
  CONSTRAINT `events_event_assigned_to_user_id_88f9a1f0_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events_event_assigned_to`
--

LOCK TABLES `events_event_assigned_to` WRITE;
/*!40000 ALTER TABLE `events_event_assigned_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `events_event_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events_event_contacts`
--

DROP TABLE IF EXISTS `events_event_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events_event_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `events_event_contacts_event_id_contact_id_a262e2d5_uniq` (`event_id`,`contact_id`),
  KEY `events_event_contacts_contact_id_de30d576_fk_contacts_contact_id` (`contact_id`),
  CONSTRAINT `events_event_contacts_contact_id_de30d576_fk_contacts_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `events_event_contacts_event_id_3da8569b_fk_events_event_id` FOREIGN KEY (`event_id`) REFERENCES `events_event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events_event_contacts`
--

LOCK TABLES `events_event_contacts` WRITE;
/*!40000 ALTER TABLE `events_event_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `events_event_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events_event_teams`
--

DROP TABLE IF EXISTS `events_event_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `events_event_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `teams_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `events_event_teams_event_id_teams_id_8c426c0e_uniq` (`event_id`,`teams_id`),
  KEY `events_event_teams_teams_id_8c21a9a0_fk_teams_teams_id` (`teams_id`),
  CONSTRAINT `events_event_teams_event_id_ebaa210d_fk_events_event_id` FOREIGN KEY (`event_id`) REFERENCES `events_event` (`id`),
  CONSTRAINT `events_event_teams_teams_id_8c21a9a0_fk_teams_teams_id` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events_event_teams`
--

LOCK TABLES `events_event_teams` WRITE;
/*!40000 ALTER TABLE `events_event_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `events_event_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices_invoice`
--

DROP TABLE IF EXISTS `invoices_invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices_invoice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_title` varchar(50) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `quantity` int(10) unsigned NOT NULL,
  `rate` decimal(12,2) NOT NULL,
  `total_amount` decimal(12,2) DEFAULT NULL,
  `currency` varchar(3) DEFAULT NULL,
  `phone` varchar(128) DEFAULT NULL,
  `created_on` datetime(6) NOT NULL,
  `amount_due` decimal(12,2) DEFAULT NULL,
  `amount_paid` decimal(12,2) DEFAULT NULL,
  `is_email_sent` tinyint(1) NOT NULL,
  `status` varchar(15) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `from_address_id` int(11) DEFAULT NULL,
  `to_address_id` int(11) DEFAULT NULL,
  `details` longtext,
  `due_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoices_invoice_created_by_id_9b878bcd_fk_common_user_id` (`created_by_id`),
  KEY `invoices_invoice_from_address_id_c42db748_fk_common_address_id` (`from_address_id`),
  KEY `invoices_invoice_to_address_id_d9360206_fk_common_address_id` (`to_address_id`),
  CONSTRAINT `invoices_invoice_created_by_id_9b878bcd_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`),
  CONSTRAINT `invoices_invoice_from_address_id_c42db748_fk_common_address_id` FOREIGN KEY (`from_address_id`) REFERENCES `common_address` (`id`),
  CONSTRAINT `invoices_invoice_to_address_id_d9360206_fk_common_address_id` FOREIGN KEY (`to_address_id`) REFERENCES `common_address` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices_invoice`
--

LOCK TABLES `invoices_invoice` WRITE;
/*!40000 ALTER TABLE `invoices_invoice` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices_invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices_invoice_accounts`
--

DROP TABLE IF EXISTS `invoices_invoice_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices_invoice_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoices_invoice_accounts_invoice_id_account_id_7141208e_uniq` (`invoice_id`,`account_id`),
  KEY `invoices_invoice_acc_account_id_2cd6197c_fk_accounts_` (`account_id`),
  CONSTRAINT `invoices_invoice_acc_account_id_2cd6197c_fk_accounts_` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `invoices_invoice_acc_invoice_id_535cf2cb_fk_invoices_` FOREIGN KEY (`invoice_id`) REFERENCES `invoices_invoice` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices_invoice_accounts`
--

LOCK TABLES `invoices_invoice_accounts` WRITE;
/*!40000 ALTER TABLE `invoices_invoice_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices_invoice_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices_invoice_assigned_to`
--

DROP TABLE IF EXISTS `invoices_invoice_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices_invoice_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoices_invoice_assigned_to_invoice_id_user_id_dd2062db_uniq` (`invoice_id`,`user_id`),
  KEY `invoices_invoice_assigned_to_user_id_0aa3df96_fk_common_user_id` (`user_id`),
  CONSTRAINT `invoices_invoice_ass_invoice_id_8b0ff865_fk_invoices_` FOREIGN KEY (`invoice_id`) REFERENCES `invoices_invoice` (`id`),
  CONSTRAINT `invoices_invoice_assigned_to_user_id_0aa3df96_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices_invoice_assigned_to`
--

LOCK TABLES `invoices_invoice_assigned_to` WRITE;
/*!40000 ALTER TABLE `invoices_invoice_assigned_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices_invoice_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices_invoice_teams`
--

DROP TABLE IF EXISTS `invoices_invoice_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices_invoice_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_id` int(11) NOT NULL,
  `teams_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoices_invoice_teams_invoice_id_teams_id_82e5289d_uniq` (`invoice_id`,`teams_id`),
  KEY `invoices_invoice_teams_teams_id_b51618e6_fk_teams_teams_id` (`teams_id`),
  CONSTRAINT `invoices_invoice_tea_invoice_id_a15c151f_fk_invoices_` FOREIGN KEY (`invoice_id`) REFERENCES `invoices_invoice` (`id`),
  CONSTRAINT `invoices_invoice_teams_teams_id_b51618e6_fk_teams_teams_id` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices_invoice_teams`
--

LOCK TABLES `invoices_invoice_teams` WRITE;
/*!40000 ALTER TABLE `invoices_invoice_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices_invoice_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices_invoicehistory`
--

DROP TABLE IF EXISTS `invoices_invoicehistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices_invoicehistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoice_title` varchar(50) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `quantity` int(10) unsigned NOT NULL,
  `rate` decimal(12,2) NOT NULL,
  `total_amount` decimal(12,2) DEFAULT NULL,
  `currency` varchar(3) DEFAULT NULL,
  `phone` varchar(128) DEFAULT NULL,
  `created_on` datetime(6) NOT NULL,
  `amount_due` decimal(12,2) DEFAULT NULL,
  `amount_paid` decimal(12,2) DEFAULT NULL,
  `is_email_sent` tinyint(1) NOT NULL,
  `status` varchar(15) NOT NULL,
  `details` longtext,
  `due_date` date DEFAULT NULL,
  `from_address_id` int(11) DEFAULT NULL,
  `invoice_id` int(11) NOT NULL,
  `to_address_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `invoices_invoicehist_from_address_id_cffac1b5_fk_common_ad` (`from_address_id`),
  KEY `invoices_invoicehist_invoice_id_05ee6eb8_fk_invoices_` (`invoice_id`),
  KEY `invoices_invoicehist_to_address_id_492fbb02_fk_common_ad` (`to_address_id`),
  KEY `invoices_invoicehistory_updated_by_id_2ccd68d8_fk_common_user_id` (`updated_by_id`),
  CONSTRAINT `invoices_invoicehist_from_address_id_cffac1b5_fk_common_ad` FOREIGN KEY (`from_address_id`) REFERENCES `common_address` (`id`),
  CONSTRAINT `invoices_invoicehist_invoice_id_05ee6eb8_fk_invoices_` FOREIGN KEY (`invoice_id`) REFERENCES `invoices_invoice` (`id`),
  CONSTRAINT `invoices_invoicehist_to_address_id_492fbb02_fk_common_ad` FOREIGN KEY (`to_address_id`) REFERENCES `common_address` (`id`),
  CONSTRAINT `invoices_invoicehistory_updated_by_id_2ccd68d8_fk_common_user_id` FOREIGN KEY (`updated_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices_invoicehistory`
--

LOCK TABLES `invoices_invoicehistory` WRITE;
/*!40000 ALTER TABLE `invoices_invoicehistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices_invoicehistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices_invoicehistory_assigned_to`
--

DROP TABLE IF EXISTS `invoices_invoicehistory_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invoices_invoicehistory_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `invoicehistory_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoices_invoicehistory__invoicehistory_id_user_i_1b9adc64_uniq` (`invoicehistory_id`,`user_id`),
  KEY `invoices_invoicehist_user_id_7b1e7786_fk_common_us` (`user_id`),
  CONSTRAINT `invoices_invoicehist_invoicehistory_id_02417412_fk_invoices_` FOREIGN KEY (`invoicehistory_id`) REFERENCES `invoices_invoicehistory` (`id`),
  CONSTRAINT `invoices_invoicehist_user_id_7b1e7786_fk_common_us` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices_invoicehistory_assigned_to`
--

LOCK TABLES `invoices_invoicehistory_assigned_to` WRITE;
/*!40000 ALTER TABLE `invoices_invoicehistory_assigned_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `invoices_invoicehistory_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads_lead`
--

DROP TABLE IF EXISTS `leads_lead`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leads_lead` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `description` longtext,
  `account_name` varchar(255) DEFAULT NULL,
  `opportunity_amount` decimal(12,2) DEFAULT NULL,
  `created_on` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `enquery_type` varchar(255) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `address_line` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `country` varchar(3) DEFAULT NULL,
  `postcode` varchar(64) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `street` varchar(55) DEFAULT NULL,
  `created_from_site` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `leads_lead_created_by_id_bd2e8097_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `leads_lead_created_by_id_bd2e8097_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads_lead`
--

LOCK TABLES `leads_lead` WRITE;
/*!40000 ALTER TABLE `leads_lead` DISABLE KEYS */;
INSERT INTO `leads_lead` VALUES (2,'event','abi','naya','abi@gmail.com','9702345678','in process','partner','www.zoo.com','','zoo',NULL,'2020-05-18 06:36:37.294424',0,NULL,1,NULL,'chennai','IN',NULL,'tamil nadu',NULL,0),(3,'event','reshu','rai','abcd@gmail.com',NULL,'converted','compaign','www.abcd.com','','abcd',NULL,'2020-05-19 04:23:26.133311',0,NULL,1,NULL,NULL,'IN',NULL,NULL,NULL,0),(4,'asd','mani','a','mani@gmail.com','9845678956','converted','email','www.def.com','','abc',NULL,'2020-06-04 09:47:30.451742',0,NULL,1,NULL,'chennai','IN',NULL,NULL,NULL,0),(5,'bavg','abc',NULL,'abc@gmail.com',NULL,'in process','existing customer','www.abc.com','',NULL,NULL,'2020-06-04 09:50:43.625072',0,NULL,1,NULL,NULL,'IN',NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `leads_lead` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads_lead_assigned_to`
--

DROP TABLE IF EXISTS `leads_lead_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leads_lead_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lead_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leads_lead_assigned_to_lead_id_user_id_96e37802_uniq` (`lead_id`,`user_id`),
  KEY `leads_lead_assigned_to_user_id_e9de5cbf_fk_common_user_id` (`user_id`),
  CONSTRAINT `leads_lead_assigned_to_lead_id_b43e64b4_fk_leads_lead_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_lead` (`id`),
  CONSTRAINT `leads_lead_assigned_to_user_id_e9de5cbf_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads_lead_assigned_to`
--

LOCK TABLES `leads_lead_assigned_to` WRITE;
/*!40000 ALTER TABLE `leads_lead_assigned_to` DISABLE KEYS */;
INSERT INTO `leads_lead_assigned_to` VALUES (1,2,1),(3,3,1);
/*!40000 ALTER TABLE `leads_lead_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads_lead_contacts`
--

DROP TABLE IF EXISTS `leads_lead_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leads_lead_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lead_id` int(11) NOT NULL,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leads_lead_contacts_lead_id_contact_id_9282b1c1_uniq` (`lead_id`,`contact_id`),
  KEY `leads_lead_contacts_contact_id_643d700d_fk_contacts_contact_id` (`contact_id`),
  CONSTRAINT `leads_lead_contacts_contact_id_643d700d_fk_contacts_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `leads_lead_contacts_lead_id_e9cd308e_fk_leads_lead_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_lead` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads_lead_contacts`
--

LOCK TABLES `leads_lead_contacts` WRITE;
/*!40000 ALTER TABLE `leads_lead_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `leads_lead_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads_lead_tags`
--

DROP TABLE IF EXISTS `leads_lead_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leads_lead_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lead_id` int(11) NOT NULL,
  `tags_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leads_lead_tags_lead_id_tags_id_36f26eff_uniq` (`lead_id`,`tags_id`),
  KEY `leads_lead_tags_tags_id_fa4a2366_fk_accounts_tags_id` (`tags_id`),
  CONSTRAINT `leads_lead_tags_lead_id_873b102c_fk_leads_lead_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_lead` (`id`),
  CONSTRAINT `leads_lead_tags_tags_id_fa4a2366_fk_accounts_tags_id` FOREIGN KEY (`tags_id`) REFERENCES `accounts_tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads_lead_tags`
--

LOCK TABLES `leads_lead_tags` WRITE;
/*!40000 ALTER TABLE `leads_lead_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `leads_lead_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `leads_lead_teams`
--

DROP TABLE IF EXISTS `leads_lead_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `leads_lead_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lead_id` int(11) NOT NULL,
  `teams_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `leads_lead_teams_lead_id_teams_id_e2392e4d_uniq` (`lead_id`,`teams_id`),
  KEY `leads_lead_teams_teams_id_9753bcb3_fk_teams_teams_id` (`teams_id`),
  CONSTRAINT `leads_lead_teams_lead_id_fb912735_fk_leads_lead_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_lead` (`id`),
  CONSTRAINT `leads_lead_teams_teams_id_9753bcb3_fk_teams_teams_id` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads_lead_teams`
--

LOCK TABLES `leads_lead_teams` WRITE;
/*!40000 ALTER TABLE `leads_lead_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `leads_lead_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_blockeddomain`
--

DROP TABLE IF EXISTS `marketing_blockeddomain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_blockeddomain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(200) NOT NULL,
  `created_on` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_blockeddomain_created_by_id_a4cbe960_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `marketing_blockeddomain_created_by_id_a4cbe960_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_blockeddomain`
--

LOCK TABLES `marketing_blockeddomain` WRITE;
/*!40000 ALTER TABLE `marketing_blockeddomain` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_blockeddomain` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_blockedemail`
--

DROP TABLE IF EXISTS `marketing_blockedemail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_blockedemail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `created_on` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_blockedemail_created_by_id_7f859478_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `marketing_blockedemail_created_by_id_7f859478_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_blockedemail`
--

LOCK TABLES `marketing_blockedemail` WRITE;
/*!40000 ALTER TABLE `marketing_blockedemail` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_blockedemail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_campaign`
--

DROP TABLE IF EXISTS `marketing_campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_campaign` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(5000) NOT NULL,
  `created_on` datetime(6) NOT NULL,
  `schedule_date_time` datetime(6) DEFAULT NULL,
  `reply_to_email` varchar(254) DEFAULT NULL,
  `subject` varchar(5000) NOT NULL,
  `html` longtext NOT NULL,
  `html_processed` longtext NOT NULL,
  `from_email` varchar(254) DEFAULT NULL,
  `from_name` varchar(254) DEFAULT NULL,
  `sent` int(11) NOT NULL,
  `opens` int(11) NOT NULL,
  `opens_unique` int(11) NOT NULL,
  `bounced` int(11) NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `email_template_id` int(11) DEFAULT NULL,
  `updated_on` datetime(6) NOT NULL,
  `timezone` varchar(100) NOT NULL,
  `attachment` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_campaign_created_by_id_c4d2ec89_fk_common_user_id` (`created_by_id`),
  KEY `marketing_campaign_email_template_id_16ed1ee5_fk_marketing` (`email_template_id`),
  CONSTRAINT `marketing_campaign_created_by_id_c4d2ec89_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`),
  CONSTRAINT `marketing_campaign_email_template_id_16ed1ee5_fk_marketing` FOREIGN KEY (`email_template_id`) REFERENCES `marketing_emailtemplate` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaign`
--

LOCK TABLES `marketing_campaign` WRITE;
/*!40000 ALTER TABLE `marketing_campaign` DISABLE KEYS */;
INSERT INTO `marketing_campaign` VALUES (5,'marketing-temp','2020-05-13 04:57:12.421969',NULL,'manju24zoo@gmail.com','sample text','<pre class=\"ql-syntax\" spellcheck=\"false\" style=\"background-color: rgb(35, 36, 31); color: rgb(248, 248, 242); overflow: visible; border-radius: 3px; white-space: pre-wrap; margin-bottom: 5px; margin-top: 5px; padding: 5px 10px;\">hi,\n   ghjkdxfc\\\njm,.\ngvjb.\ngvhjb.\ngvhjb\ncgvhjb\n\nthnaku\n</pre>','<pre class=\"ql-syntax\" spellcheck=\"false\" style=\"background-color: rgb(35, 36, 31); color: rgb(248, 248, 242); overflow: visible; border-radius: 3px; white-space: pre-wrap; margin-bottom: 5px; margin-top: 5px; padding: 5px 10px;\">hi,\n   ghjkdxfc\\\njm,.\ngvjb.\ngvhjb.\ngvhjb\ncgvhjb\n\nthnaku\n</pre>','manjusakthi70@gmail.com','Manju',0,0,0,0,'Preparing',1,5,'2020-05-13 04:57:12.827628','UTC',''),(6,'Tamil_Language','2020-05-14 04:07:08.134628',NULL,'ragini@gmail.com','list of languages','<pre class=\"ql-syntax\" spellcheck=\"false\" style=\"background-color: rgb(35, 36, 31); color: rgb(248, 248, 242); overflow: visible; border-radius: 3px; white-space: pre-wrap; margin-bottom: 5px; margin-top: 5px; padding: 5px 10px;\">Hi everyone,\n\nTamil language, member of the&nbsp;Dravidian language&nbsp;family, spoken primarily in&nbsp;India. \n It is the official language of the Indian state of&nbsp;Tamil Nadu&nbsp;and the union territory of&nbsp;Puducherry&nbsp;(Pondicherry). \n It is also an official language in&nbsp;Sri Lanka&nbsp;and&nbsp;Singapore&nbsp;and has significant numbers of speakers in&nbsp;Malaysia,&nbsp;Mauritius,&nbsp;Fiji, and&nbsp;South Africa. \n In 2004 Tamil was declared a classical language of India, meaning that it met three criteria: its origins are ancient; it has an independent tradition; and it possesses a considerable body of ancient literature. \n In the early 21st century more than 66 million people were Tamil speakers.\n The earliest Tamil writing is attested in inscriptions and potsherds from the 5th century&nbsp;BCE. \n Three periods have been distinguished through analyses of grammatical and lexical changes: Old Tamil (from about 450&nbsp;BCE&nbsp;to 700&nbsp;CE), Middle Tamil (700–1600), and Modern Tamil (from 1600). \n The Tamil writing system evolved from the&nbsp;Brahmi&nbsp;script. \n The shape of the letters changed enormously over time, eventually stabilizing when printing was introduced in the 16th century&nbsp;CE. \n The major addition to the alphabet was the incorporation of&nbsp;Grantha&nbsp;letters to write unassimilated Sanskrit words, although a few letters with irregular shapes were standardized during the modern period. \n A script known as Vatteluttu (“Round Script”) is also in common use.\n Spoken Tamil has changed substantially over time, including changes in the phonological structure of words. \n This has created&nbsp;diglossia—a system in which there are distinct differences between&nbsp;colloquial&nbsp;forms of a language and those that are used in formal and written&nbsp;contexts. \n The major regional variation is between the form spoken in India and that spoken in&nbsp;Jaffna&nbsp;(Sri Lanka), capital of a former Tamil city-state, and its surrounds. \n Within Tamil Nadu there are phonological differences between the northern, western, and southern speech. \n Regional varieties of the language intersect with varieties that are based on&nbsp;social class&nbsp;or&nbsp;caste.\n\nThanksyou.\n</pre>','<pre class=\"ql-syntax\" spellcheck=\"false\" style=\"background-color: rgb(35, 36, 31); color: rgb(248, 248, 242); overflow: visible; border-radius: 3px; white-space: pre-wrap; margin-bottom: 5px; margin-top: 5px; padding: 5px 10px;\">Hi everyone,\n\nTamil language, member of the&nbsp;Dravidian language&nbsp;family, spoken primarily in&nbsp;India. \n It is the official language of the Indian state of&nbsp;Tamil Nadu&nbsp;and the union territory of&nbsp;Puducherry&nbsp;(Pondicherry). \n It is also an official language in&nbsp;Sri Lanka&nbsp;and&nbsp;Singapore&nbsp;and has significant numbers of speakers in&nbsp;Malaysia,&nbsp;Mauritius,&nbsp;Fiji, and&nbsp;South Africa. \n In 2004 Tamil was declared a classical language of India, meaning that it met three criteria: its origins are ancient; it has an independent tradition; and it possesses a considerable body of ancient literature. \n In the early 21st century more than 66 million people were Tamil speakers.\n The earliest Tamil writing is attested in inscriptions and potsherds from the 5th century&nbsp;BCE. \n Three periods have been distinguished through analyses of grammatical and lexical changes: Old Tamil (from about 450&nbsp;BCE&nbsp;to 700&nbsp;CE), Middle Tamil (700–1600), and Modern Tamil (from 1600). \n The Tamil writing system evolved from the&nbsp;Brahmi&nbsp;script. \n The shape of the letters changed enormously over time, eventually stabilizing when printing was introduced in the 16th century&nbsp;CE. \n The major addition to the alphabet was the incorporation of&nbsp;Grantha&nbsp;letters to write unassimilated Sanskrit words, although a few letters with irregular shapes were standardized during the modern period. \n A script known as Vatteluttu (“Round Script”) is also in common use.\n Spoken Tamil has changed substantially over time, including changes in the phonological structure of words. \n This has created&nbsp;diglossia—a system in which there are distinct differences between&nbsp;colloquial&nbsp;forms of a language and those that are used in formal and written&nbsp;contexts. \n The major regional variation is between the form spoken in India and that spoken in&nbsp;Jaffna&nbsp;(Sri Lanka), capital of a former Tamil city-state, and its surrounds. \n Within Tamil Nadu there are phonological differences between the northern, western, and southern speech. \n Regional varieties of the language intersect with varieties that are based on&nbsp;social class&nbsp;or&nbsp;caste.\n\nThanksyou.\n</pre>','meenusha@gmail.com','Pavithra',0,0,0,0,'Preparing',1,4,'2020-05-14 04:07:08.464796','UTC',''),(7,'About Python','2020-05-18 05:41:13.499261',NULL,'manjusakthi70@gmail.com','courses for python','<p><br></p><p>Dear students,</p><p><br></p><p>      Python is an interpreted, high-level, general-purpose programming language. </p><p>      Created by Guido van Rossum and first released in 1991, </p><p>      Python\'s design philosophy emphasizes code readability with its notable use of significant whitespace.</p><p><br></p><p>      Learn&nbsp;Python&nbsp;Programming as a Complete Beginner by Smart Academy Tech Mahindra. </p><p>      We Provide Training on Live Project with 100% Job Guarantee. </p><p>      Become an expert web Dev. </p><p>      Certified Trainers. Advanced Project Training. </p><p>      100% Placement Assistance. </p><p>      Backup Support.</p><p><br></p><p><br></p><p>Thankyou.</p>','<p><br></p><p>Dear students,</p><p><br></p><p>      Python is an interpreted, high-level, general-purpose programming language. </p><p>      Created by Guido van Rossum and first released in 1991, </p><p>      Python\'s design philosophy emphasizes code readability with its notable use of significant whitespace.</p><p><br></p><p>      Learn&nbsp;Python&nbsp;Programming as a Complete Beginner by Smart Academy Tech Mahindra. </p><p>      We Provide Training on Live Project with 100% Job Guarantee. </p><p>      Become an expert web Dev. </p><p>      Certified Trainers. Advanced Project Training. </p><p>      100% Placement Assistance. </p><p>      Backup Support.</p><p><br></p><p><br></p><p>Thankyou.</p>','manju24zoo@gmil.com','Kanmani',0,0,0,0,'Preparing',1,2,'2020-05-18 05:41:13.853999','UTC',''),(8,'About tamil','2020-05-18 05:42:51.121725',NULL,'manju24zoo@gmail.com','list of languages','<pre class=\"ql-syntax\" spellcheck=\"false\" style=\"background-color: rgb(35, 36, 31); color: rgb(248, 248, 242); overflow: visible; border-radius: 3px; white-space: pre-wrap; margin-bottom: 5px; margin-top: 5px; padding: 5px 10px;\">Hi everyone,\n\nTamil language, member of the&nbsp;Dravidian language&nbsp;family, spoken primarily in&nbsp;India. \n It is the official language of the Indian state of&nbsp;Tamil Nadu&nbsp;and the union territory of&nbsp;Puducherry&nbsp;(Pondicherry). \n It is also an official language in&nbsp;Sri Lanka&nbsp;and&nbsp;Singapore&nbsp;and has significant numbers of speakers in&nbsp;Malaysia,&nbsp;Mauritius,&nbsp;Fiji, and&nbsp;South Africa. \n In 2004 Tamil was declared a classical language of India, meaning that it met three criteria: its origins are ancient; it has an independent tradition; and it possesses a considerable body of ancient literature. \n In the early 21st century more than 66 million people were Tamil speakers.\n The earliest Tamil writing is attested in inscriptions and potsherds from the 5th century&nbsp;BCE. \n Three periods have been distinguished through analyses of grammatical and lexical changes: Old Tamil (from about 450&nbsp;BCE&nbsp;to 700&nbsp;CE), Middle Tamil (700–1600), and Modern Tamil (from 1600). \n The Tamil writing system evolved from the&nbsp;Brahmi&nbsp;script. \n The shape of the letters changed enormously over time, eventually stabilizing when printing was introduced in the 16th century&nbsp;CE. \n The major addition to the alphabet was the incorporation of&nbsp;Grantha&nbsp;letters to write unassimilated Sanskrit words, although a few letters with irregular shapes were standardized during the modern period. \n A script known as Vatteluttu (“Round Script”) is also in common use.\n Spoken Tamil has changed substantially over time, including changes in the phonological structure of words. \n This has created&nbsp;diglossia—a system in which there are distinct differences between&nbsp;colloquial&nbsp;forms of a language and those that are used in formal and written&nbsp;contexts. \n The major regional variation is between the form spoken in India and that spoken in&nbsp;Jaffna&nbsp;(Sri Lanka), capital of a former Tamil city-state, and its surrounds. \n Within Tamil Nadu there are phonological differences between the northern, western, and southern speech. \n Regional varieties of the language intersect with varieties that are based on&nbsp;social class&nbsp;or&nbsp;caste.\n\nThanksyou.\n</pre>','<pre class=\"ql-syntax\" spellcheck=\"false\" style=\"background-color: rgb(35, 36, 31); color: rgb(248, 248, 242); overflow: visible; border-radius: 3px; white-space: pre-wrap; margin-bottom: 5px; margin-top: 5px; padding: 5px 10px;\">Hi everyone,\n\nTamil language, member of the&nbsp;Dravidian language&nbsp;family, spoken primarily in&nbsp;India. \n It is the official language of the Indian state of&nbsp;Tamil Nadu&nbsp;and the union territory of&nbsp;Puducherry&nbsp;(Pondicherry). \n It is also an official language in&nbsp;Sri Lanka&nbsp;and&nbsp;Singapore&nbsp;and has significant numbers of speakers in&nbsp;Malaysia,&nbsp;Mauritius,&nbsp;Fiji, and&nbsp;South Africa. \n In 2004 Tamil was declared a classical language of India, meaning that it met three criteria: its origins are ancient; it has an independent tradition; and it possesses a considerable body of ancient literature. \n In the early 21st century more than 66 million people were Tamil speakers.\n The earliest Tamil writing is attested in inscriptions and potsherds from the 5th century&nbsp;BCE. \n Three periods have been distinguished through analyses of grammatical and lexical changes: Old Tamil (from about 450&nbsp;BCE&nbsp;to 700&nbsp;CE), Middle Tamil (700–1600), and Modern Tamil (from 1600). \n The Tamil writing system evolved from the&nbsp;Brahmi&nbsp;script. \n The shape of the letters changed enormously over time, eventually stabilizing when printing was introduced in the 16th century&nbsp;CE. \n The major addition to the alphabet was the incorporation of&nbsp;Grantha&nbsp;letters to write unassimilated Sanskrit words, although a few letters with irregular shapes were standardized during the modern period. \n A script known as Vatteluttu (“Round Script”) is also in common use.\n Spoken Tamil has changed substantially over time, including changes in the phonological structure of words. \n This has created&nbsp;diglossia—a system in which there are distinct differences between&nbsp;colloquial&nbsp;forms of a language and those that are used in formal and written&nbsp;contexts. \n The major regional variation is between the form spoken in India and that spoken in&nbsp;Jaffna&nbsp;(Sri Lanka), capital of a former Tamil city-state, and its surrounds. \n Within Tamil Nadu there are phonological differences between the northern, western, and southern speech. \n Regional varieties of the language intersect with varieties that are based on&nbsp;social class&nbsp;or&nbsp;caste.\n\nThanksyou.\n</pre>','manjusakthi70@gmail.com','Sandeep',0,0,0,0,'Preparing',1,4,'2020-05-18 05:42:51.486210','UTC',''),(9,'Python Learners','2020-05-30 05:25:14.070582',NULL,'manjusakthi70@gmail.com','courses for python','<p><br></p><p>Dear students,</p><p><br></p><p>      Python is an interpreted, high-level, general-purpose programming language. </p><p>      Created by Guido van Rossum and first released in 1991, </p><p>      Python\'s design philosophy emphasizes code readability with its notable use of significant whitespace.</p><p><br></p><p>      Learn&nbsp;Python&nbsp;Programming as a Complete Beginner by Smart Academy Tech Mahindra. </p><p>      We Provide Training on Live Project with 100% Job Guarantee. </p><p>      Become an expert web Dev. </p><p>      Certified Trainers. Advanced Project Training. </p><p>      100% Placement Assistance. </p><p>      Backup Support.</p><p><br></p><p><br></p><p>Thankyou.</p>','<p><br></p><p>Dear students,</p><p><br></p><p>      Python is an interpreted, high-level, general-purpose programming language. </p><p>      Created by Guido van Rossum and first released in 1991, </p><p>      Python\'s design philosophy emphasizes code readability with its notable use of significant whitespace.</p><p><br></p><p>      Learn&nbsp;Python&nbsp;Programming as a Complete Beginner by Smart Academy Tech Mahindra. </p><p>      We Provide Training on Live Project with 100% Job Guarantee. </p><p>      Become an expert web Dev. </p><p>      Certified Trainers. Advanced Project Training. </p><p>      100% Placement Assistance. </p><p>      Backup Support.</p><p><br></p><p><br></p><p>Thankyou.</p>','manju24zoo@gmail.com','Reenu',0,0,0,0,'Preparing',1,2,'2020-05-30 05:25:14.407304','UTC','');
/*!40000 ALTER TABLE `marketing_campaign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_campaign_contact_lists`
--

DROP TABLE IF EXISTS `marketing_campaign_contact_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_campaign_contact_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) NOT NULL,
  `contactlist_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `marketing_campaign_conta_campaign_id_contactlist__020d6f66_uniq` (`campaign_id`,`contactlist_id`),
  KEY `marketing_campaign_c_contactlist_id_f870c4d0_fk_marketing` (`contactlist_id`),
  CONSTRAINT `marketing_campaign_c_campaign_id_47b7ad3f_fk_marketing` FOREIGN KEY (`campaign_id`) REFERENCES `marketing_campaign` (`id`),
  CONSTRAINT `marketing_campaign_c_contactlist_id_f870c4d0_fk_marketing` FOREIGN KEY (`contactlist_id`) REFERENCES `marketing_contactlist` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaign_contact_lists`
--

LOCK TABLES `marketing_campaign_contact_lists` WRITE;
/*!40000 ALTER TABLE `marketing_campaign_contact_lists` DISABLE KEYS */;
INSERT INTO `marketing_campaign_contact_lists` VALUES (5,5,4),(6,6,2),(7,7,2),(8,8,3),(9,9,5);
/*!40000 ALTER TABLE `marketing_campaign_contact_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_campaign_tags`
--

DROP TABLE IF EXISTS `marketing_campaign_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_campaign_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `marketing_campaign_tags_campaign_id_tag_id_83900b94_uniq` (`campaign_id`,`tag_id`),
  KEY `marketing_campaign_tags_tag_id_973530fe_fk_marketing_tag_id` (`tag_id`),
  CONSTRAINT `marketing_campaign_t_campaign_id_4a5b98e2_fk_marketing` FOREIGN KEY (`campaign_id`) REFERENCES `marketing_campaign` (`id`),
  CONSTRAINT `marketing_campaign_tags_tag_id_973530fe_fk_marketing_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `marketing_tag` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaign_tags`
--

LOCK TABLES `marketing_campaign_tags` WRITE;
/*!40000 ALTER TABLE `marketing_campaign_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_campaign_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_campaigncompleted`
--

DROP TABLE IF EXISTS `marketing_campaigncompleted`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_campaigncompleted` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_completed` tinyint(1) NOT NULL,
  `campaign_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `campaign_id` (`campaign_id`),
  CONSTRAINT `marketing_campaignco_campaign_id_8722a42c_fk_marketing` FOREIGN KEY (`campaign_id`) REFERENCES `marketing_campaign` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaigncompleted`
--

LOCK TABLES `marketing_campaigncompleted` WRITE;
/*!40000 ALTER TABLE `marketing_campaigncompleted` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_campaigncompleted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_campaignlinkclick`
--

DROP TABLE IF EXISTS `marketing_campaignlinkclick`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_campaignlinkclick` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` char(39) NOT NULL,
  `created_on` datetime(6) NOT NULL,
  `user_agent` varchar(2000) DEFAULT NULL,
  `campaign_id` int(11) NOT NULL,
  `contact_id` int(11) DEFAULT NULL,
  `link_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_campaignli_contact_id_a20f4980_fk_marketing` (`contact_id`),
  KEY `marketing_campaignli_link_id_df848b66_fk_marketing` (`link_id`),
  KEY `marketing_campaignli_campaign_id_bad5722a_fk_marketing` (`campaign_id`),
  CONSTRAINT `marketing_campaignli_campaign_id_bad5722a_fk_marketing` FOREIGN KEY (`campaign_id`) REFERENCES `marketing_campaign` (`id`),
  CONSTRAINT `marketing_campaignli_contact_id_a20f4980_fk_marketing` FOREIGN KEY (`contact_id`) REFERENCES `marketing_contact` (`id`),
  CONSTRAINT `marketing_campaignli_link_id_df848b66_fk_marketing` FOREIGN KEY (`link_id`) REFERENCES `marketing_link` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaignlinkclick`
--

LOCK TABLES `marketing_campaignlinkclick` WRITE;
/*!40000 ALTER TABLE `marketing_campaignlinkclick` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_campaignlinkclick` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_campaignlog`
--

DROP TABLE IF EXISTS `marketing_campaignlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_campaignlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime(6) NOT NULL,
  `message_id` varchar(1000) DEFAULT NULL,
  `campaign_id` int(11) NOT NULL,
  `contact_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_campaignlo_contact_id_757a80df_fk_marketing` (`contact_id`),
  KEY `marketing_campaignlo_campaign_id_0a5d9b5a_fk_marketing` (`campaign_id`),
  CONSTRAINT `marketing_campaignlo_campaign_id_0a5d9b5a_fk_marketing` FOREIGN KEY (`campaign_id`) REFERENCES `marketing_campaign` (`id`),
  CONSTRAINT `marketing_campaignlo_contact_id_757a80df_fk_marketing` FOREIGN KEY (`contact_id`) REFERENCES `marketing_contact` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaignlog`
--

LOCK TABLES `marketing_campaignlog` WRITE;
/*!40000 ALTER TABLE `marketing_campaignlog` DISABLE KEYS */;
INSERT INTO `marketing_campaignlog` VALUES (5,'2020-05-13 04:57:12.908341',NULL,5,10),(6,'2020-05-14 04:07:08.845852',NULL,6,4),(7,'2020-05-14 04:07:14.500198',NULL,6,5),(8,'2020-05-18 05:41:13.958817',NULL,7,4),(9,'2020-05-18 05:41:19.023350',NULL,7,5),(10,'2020-05-18 05:42:51.595658',NULL,8,6),(11,'2020-05-18 05:42:55.492065',NULL,8,8),(12,'2020-05-18 05:42:59.113198',NULL,8,9),(13,'2020-05-30 05:25:14.488608',NULL,9,11),(14,'2020-05-30 05:25:20.081937',NULL,9,12),(15,'2020-05-30 05:25:23.815089',NULL,9,13);
/*!40000 ALTER TABLE `marketing_campaignlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_campaignopen`
--

DROP TABLE IF EXISTS `marketing_campaignopen`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_campaignopen` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` char(39) NOT NULL,
  `created_on` datetime(6) NOT NULL,
  `user_agent` varchar(2000) DEFAULT NULL,
  `campaign_id` int(11) NOT NULL,
  `contact_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_campaignop_campaign_id_18fc81d4_fk_marketing` (`campaign_id`),
  KEY `marketing_campaignop_contact_id_f1813fb0_fk_marketing` (`contact_id`),
  CONSTRAINT `marketing_campaignop_campaign_id_18fc81d4_fk_marketing` FOREIGN KEY (`campaign_id`) REFERENCES `marketing_campaign` (`id`),
  CONSTRAINT `marketing_campaignop_contact_id_f1813fb0_fk_marketing` FOREIGN KEY (`contact_id`) REFERENCES `marketing_contact` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaignopen`
--

LOCK TABLES `marketing_campaignopen` WRITE;
/*!40000 ALTER TABLE `marketing_campaignopen` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_campaignopen` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_contact`
--

DROP TABLE IF EXISTS `marketing_contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_contact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime(6) NOT NULL,
  `name` varchar(500) NOT NULL,
  `email` varchar(254) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `is_unsubscribed` tinyint(1) NOT NULL,
  `is_bounced` tinyint(1) NOT NULL,
  `company_name` varchar(500) DEFAULT NULL,
  `last_name` varchar(500) DEFAULT NULL,
  `city` varchar(500) DEFAULT NULL,
  `state` varchar(500) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_on` datetime(6) NOT NULL,
  `country` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_contact_created_by_id_c5fc4040_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `marketing_contact_created_by_id_c5fc4040_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contact`
--

LOCK TABLES `marketing_contact` WRITE;
/*!40000 ALTER TABLE `marketing_contact` DISABLE KEYS */;
INSERT INTO `marketing_contact` VALUES (1,'2020-05-04 04:48:45.035974','rajesh','rajesh@gmail.com',NULL,0,0,'wipro','sakthi','chennai','tamilnadu',1,'2020-05-04 04:49:49.912857',NULL),(2,'2020-05-04 04:48:45.614208','janani','janani@gmail.com',NULL,0,0,'tcs','k','pondy','pondy',1,'2020-05-04 04:48:45.919807',NULL),(3,'2020-05-04 04:48:46.202656','vijay','vijay@gmail.com',NULL,0,0,'cts','sankar','banglore','karnataka',1,'2020-05-04 04:48:46.411247',NULL),(4,'2020-05-04 05:32:39.855452','manju','manjula@zoogle.com.sg',NULL,0,0,'abc','sakti','pondycherry','pondycherry',1,'2020-05-05 09:39:28.237540',NULL),(5,'2020-05-04 05:32:46.202871','janani','janani@zoogle.com.sg',NULL,0,0,'def','karunanathi','banglore','karnataka',1,'2020-05-05 10:14:18.285971',NULL),(6,'2020-05-07 04:32:21.201378','ragul','rajeshsakthi645@gmail.com',NULL,0,0,'tcs','dravid','pondicherry','pondicherry',1,'2020-05-07 04:35:41.205840',NULL),(8,'2020-05-07 04:32:22.871283','radha','trishacrush21@gmail.com',NULL,0,0,'cts','bai','pondy','pondy',1,'2020-05-13 04:54:36.474093',NULL),(9,'2020-05-07 04:32:23.686926','renu','priyedarshini21@gmail.com',NULL,0,0,'wipro','priya','kochi','kerala',1,'2020-05-07 04:32:23.944478',NULL),(10,'2020-05-13 04:52:52.108466','pavithra','dimplecuties12345@gmail.com',NULL,0,0,'wipro','mani','chennai','tamilnadu',1,'2020-05-13 04:52:53.441933',NULL),(11,'2020-05-30 05:22:45.975550','rajesh','rajesh@zoogle.com.sg',NULL,0,0,'wipro','sakthi','chennai','tamilnadu',1,'2020-05-30 05:22:48.875798',NULL),(12,'2020-05-30 05:22:49.117823','janani','priyedarshini@zoogle.com.sg',NULL,0,0,'tcs','k','pondy','pondy',1,'2020-05-30 05:22:49.282655',NULL),(13,'2020-05-30 05:22:49.581794','vijay','vijay@zoogle.com.sg',NULL,0,0,'cts','sankar','banglore','karnataka',1,'2020-05-30 05:22:49.808755',NULL),(15,'2020-05-30 10:46:44.903416','monisha','manju24zoo@gmail.com',NULL,0,0,'abc','k','pondy','pondy',1,'2020-06-17 09:12:44.258817',NULL),(16,'2020-05-30 10:46:45.285532','vj','sankarmass619@gmail.com',NULL,0,0,'efg','sankar','banglore','karnataka',1,'2020-05-30 10:46:45.542890',NULL);
/*!40000 ALTER TABLE `marketing_contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_contact_contact_list`
--

DROP TABLE IF EXISTS `marketing_contact_contact_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_contact_contact_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) NOT NULL,
  `contactlist_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `marketing_contact_contac_contact_id_contactlist_i_a64027db_uniq` (`contact_id`,`contactlist_id`),
  KEY `marketing_contact_co_contactlist_id_51f313b1_fk_marketing` (`contactlist_id`),
  CONSTRAINT `marketing_contact_co_contact_id_23181bed_fk_marketing` FOREIGN KEY (`contact_id`) REFERENCES `marketing_contact` (`id`),
  CONSTRAINT `marketing_contact_co_contactlist_id_51f313b1_fk_marketing` FOREIGN KEY (`contactlist_id`) REFERENCES `marketing_contactlist` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contact_contact_list`
--

LOCK TABLES `marketing_contact_contact_list` WRITE;
/*!40000 ALTER TABLE `marketing_contact_contact_list` DISABLE KEYS */;
INSERT INTO `marketing_contact_contact_list` VALUES (1,1,1),(2,2,1),(3,3,1),(4,4,2),(5,5,2),(6,6,3),(8,8,3),(9,9,3),(10,10,4),(11,11,5),(12,12,5),(13,13,5),(15,15,6),(16,16,6);
/*!40000 ALTER TABLE `marketing_contact_contact_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_contactemailcampaign`
--

DROP TABLE IF EXISTS `marketing_contactemailcampaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_contactemailcampaign` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `email` varchar(254) NOT NULL,
  `last_name` varchar(500) DEFAULT NULL,
  `created_on` datetime(6) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_contactema_created_by_id_49bdc16d_fk_common_us` (`created_by_id`),
  CONSTRAINT `marketing_contactema_created_by_id_49bdc16d_fk_common_us` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contactemailcampaign`
--

LOCK TABLES `marketing_contactemailcampaign` WRITE;
/*!40000 ALTER TABLE `marketing_contactemailcampaign` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_contactemailcampaign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_contactlist`
--

DROP TABLE IF EXISTS `marketing_contactlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_contactlist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime(6) NOT NULL,
  `name` varchar(500) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_on` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_contactlist_created_by_id_ca6d9a00_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `marketing_contactlist_created_by_id_ca6d9a00_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contactlist`
--

LOCK TABLES `marketing_contactlist` WRITE;
/*!40000 ALTER TABLE `marketing_contactlist` DISABLE KEYS */;
INSERT INTO `marketing_contactlist` VALUES (1,'2020-05-04 04:48:44.725489','marketing',1,'2020-05-04 04:48:44.725532'),(2,'2020-05-04 05:32:37.559623','market_list',1,'2020-05-04 05:32:37.559706'),(3,'2020-05-07 04:19:59.332730','list_of_contacts',1,'2020-05-07 04:24:32.832632'),(4,'2020-05-13 04:51:42.764432','test_contact',1,'2020-05-13 04:52:51.602299'),(5,'2020-05-30 05:22:45.655114','group-members',1,'2020-05-30 05:22:45.655184'),(6,'2020-05-30 10:45:58.169466','commity_members',1,'2020-06-17 09:13:45.417037');
/*!40000 ALTER TABLE `marketing_contactlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_contactlist_tags`
--

DROP TABLE IF EXISTS `marketing_contactlist_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_contactlist_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contactlist_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `marketing_contactlist_tags_contactlist_id_tag_id_a157ecf0_uniq` (`contactlist_id`,`tag_id`),
  KEY `marketing_contactlist_tags_tag_id_d2d98941_fk_marketing_tag_id` (`tag_id`),
  CONSTRAINT `marketing_contactlis_contactlist_id_d5b1120c_fk_marketing` FOREIGN KEY (`contactlist_id`) REFERENCES `marketing_contactlist` (`id`),
  CONSTRAINT `marketing_contactlist_tags_tag_id_d2d98941_fk_marketing_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `marketing_tag` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contactlist_tags`
--

LOCK TABLES `marketing_contactlist_tags` WRITE;
/*!40000 ALTER TABLE `marketing_contactlist_tags` DISABLE KEYS */;
INSERT INTO `marketing_contactlist_tags` VALUES (1,1,1),(2,2,2),(5,3,2),(7,4,4);
/*!40000 ALTER TABLE `marketing_contactlist_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_contactlist_visible_to`
--

DROP TABLE IF EXISTS `marketing_contactlist_visible_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_contactlist_visible_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contactlist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `marketing_contactlist_vi_contactlist_id_user_id_4ab3b57e_uniq` (`contactlist_id`,`user_id`),
  KEY `marketing_contactlis_user_id_55499a9a_fk_common_us` (`user_id`),
  CONSTRAINT `marketing_contactlis_contactlist_id_239ee189_fk_marketing` FOREIGN KEY (`contactlist_id`) REFERENCES `marketing_contactlist` (`id`),
  CONSTRAINT `marketing_contactlis_user_id_55499a9a_fk_common_us` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contactlist_visible_to`
--

LOCK TABLES `marketing_contactlist_visible_to` WRITE;
/*!40000 ALTER TABLE `marketing_contactlist_visible_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_contactlist_visible_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_contactunsubscribedcampaign`
--

DROP TABLE IF EXISTS `marketing_contactunsubscribedcampaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_contactunsubscribedcampaign` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `is_unsubscribed` tinyint(1) NOT NULL,
  `campaigns_id` int(11) NOT NULL,
  `contacts_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_contactuns_campaigns_id_631325bd_fk_marketing` (`campaigns_id`),
  KEY `marketing_contactuns_contacts_id_0a7bbbe4_fk_marketing` (`contacts_id`),
  CONSTRAINT `marketing_contactuns_campaigns_id_631325bd_fk_marketing` FOREIGN KEY (`campaigns_id`) REFERENCES `marketing_campaign` (`id`),
  CONSTRAINT `marketing_contactuns_contacts_id_0a7bbbe4_fk_marketing` FOREIGN KEY (`contacts_id`) REFERENCES `marketing_contact` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contactunsubscribedcampaign`
--

LOCK TABLES `marketing_contactunsubscribedcampaign` WRITE;
/*!40000 ALTER TABLE `marketing_contactunsubscribedcampaign` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_contactunsubscribedcampaign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_duplicatecontacts`
--

DROP TABLE IF EXISTS `marketing_duplicatecontacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_duplicatecontacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_list_id` int(11) DEFAULT NULL,
  `contacts_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_duplicatec_contact_list_id_eb57a05e_fk_marketing` (`contact_list_id`),
  KEY `marketing_duplicatec_contacts_id_0cd30367_fk_marketing` (`contacts_id`),
  CONSTRAINT `marketing_duplicatec_contact_list_id_eb57a05e_fk_marketing` FOREIGN KEY (`contact_list_id`) REFERENCES `marketing_contactlist` (`id`),
  CONSTRAINT `marketing_duplicatec_contacts_id_0cd30367_fk_marketing` FOREIGN KEY (`contacts_id`) REFERENCES `marketing_contact` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_duplicatecontacts`
--

LOCK TABLES `marketing_duplicatecontacts` WRITE;
/*!40000 ALTER TABLE `marketing_duplicatecontacts` DISABLE KEYS */;
INSERT INTO `marketing_duplicatecontacts` VALUES (1,3,6),(2,3,NULL),(3,3,8),(4,3,9),(5,4,8);
/*!40000 ALTER TABLE `marketing_duplicatecontacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_emailtemplate`
--

DROP TABLE IF EXISTS `marketing_emailtemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_emailtemplate` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime(6) NOT NULL,
  `title` varchar(5000) NOT NULL,
  `subject` varchar(5000) NOT NULL,
  `html` longtext NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_on` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_emailtemplate_created_by_id_6641e947_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `marketing_emailtemplate_created_by_id_6641e947_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_emailtemplate`
--

LOCK TABLES `marketing_emailtemplate` WRITE;
/*!40000 ALTER TABLE `marketing_emailtemplate` DISABLE KEYS */;
INSERT INTO `marketing_emailtemplate` VALUES (2,'2020-05-04 08:53:36.909280','python','courses for python','<p><br></p><p>Dear students,</p><p><br></p><p>      Python is an interpreted, high-level, general-purpose programming language. </p><p>      Created by Guido van Rossum and first released in 1991, </p><p>      Python\'s design philosophy emphasizes code readability with its notable use of significant whitespace.</p><p><br></p><p>      Learn&nbsp;Python&nbsp;Programming as a Complete Beginner by Smart Academy Tech Mahindra. </p><p>      We Provide Training on Live Project with 100% Job Guarantee. </p><p>      Become an expert web Dev. </p><p>      Certified Trainers. Advanced Project Training. </p><p>      100% Placement Assistance. </p><p>      Backup Support.</p><p><br></p><p><br></p><p>Thankyou.</p>',1,'2020-05-07 06:45:08.659699'),(3,'2020-05-04 08:54:45.622871','test','testing','<p>Dear students,</p><p><br></p><p>Python is an interpreted, high-level, general-purpose programming language.</p><p>Created by Guido van Rossum and first released in 1991,</p><p>Python\'s design philosophy emphasizes code readability with its notable use of significant whitespace.</p><p><br></p><p>Learn&nbsp;Python&nbsp;Programming as a Complete Beginner by Smart Academy Tech Mahindra.</p><p>We Provide Training on Live Project with 100% Job Guarantee.</p><p>Become an expert web Dev.</p><p>Certified Trainers. Advanced Project Training.</p><p>100% Placement Assistance.</p><p>Backup Support.</p><p><br></p><p><br></p><p>Thankyou.</p><p><br></p>',1,'2020-05-07 06:44:55.996801'),(4,'2020-05-07 04:57:33.923501','value_list','list of languages','<pre class=\"ql-syntax\" spellcheck=\"false\" style=\"background-color: rgb(35, 36, 31); color: rgb(248, 248, 242); overflow: visible; border-radius: 3px; white-space: pre-wrap; margin-bottom: 5px; margin-top: 5px; padding: 5px 10px;\">Hi everyone,\n\nTamil language, member of the&nbsp;Dravidian language&nbsp;family, spoken primarily in&nbsp;India. \n It is the official language of the Indian state of&nbsp;Tamil Nadu&nbsp;and the union territory of&nbsp;Puducherry&nbsp;(Pondicherry). \n It is also an official language in&nbsp;Sri Lanka&nbsp;and&nbsp;Singapore&nbsp;and has significant numbers of speakers in&nbsp;Malaysia,&nbsp;Mauritius,&nbsp;Fiji, and&nbsp;South Africa. \n In 2004 Tamil was declared a classical language of India, meaning that it met three criteria: its origins are ancient; it has an independent tradition; and it possesses a considerable body of ancient literature. \n In the early 21st century more than 66 million people were Tamil speakers.\n The earliest Tamil writing is attested in inscriptions and potsherds from the 5th century&nbsp;BCE. \n Three periods have been distinguished through analyses of grammatical and lexical changes: Old Tamil (from about 450&nbsp;BCE&nbsp;to 700&nbsp;CE), Middle Tamil (700–1600), and Modern Tamil (from 1600). \n The Tamil writing system evolved from the&nbsp;Brahmi&nbsp;script. \n The shape of the letters changed enormously over time, eventually stabilizing when printing was introduced in the 16th century&nbsp;CE. \n The major addition to the alphabet was the incorporation of&nbsp;Grantha&nbsp;letters to write unassimilated Sanskrit words, although a few letters with irregular shapes were standardized during the modern period. \n A script known as Vatteluttu (“Round Script”) is also in common use.\n Spoken Tamil has changed substantially over time, including changes in the phonological structure of words. \n This has created&nbsp;diglossia—a system in which there are distinct differences between&nbsp;colloquial&nbsp;forms of a language and those that are used in formal and written&nbsp;contexts. \n The major regional variation is between the form spoken in India and that spoken in&nbsp;Jaffna&nbsp;(Sri Lanka), capital of a former Tamil city-state, and its surrounds. \n Within Tamil Nadu there are phonological differences between the northern, western, and southern speech. \n Regional varieties of the language intersect with varieties that are based on&nbsp;social class&nbsp;or&nbsp;caste.\n\nThanksyou.\n</pre>',1,'2020-05-07 06:45:56.625871'),(5,'2020-05-07 07:27:24.177926','text','sample text','<pre class=\"ql-syntax\" spellcheck=\"false\" style=\"background-color: rgb(35, 36, 31); color: rgb(248, 248, 242); overflow: visible; border-radius: 3px; white-space: pre-wrap; margin-bottom: 5px; margin-top: 5px; padding: 5px 10px;\">hi,\n   ghjkdxfc\\\njm,.\ngvjb.\ngvhjb.\ngvhjb\ncgvhjb\n\nthnaku\n</pre>',1,'2020-05-07 07:27:24.177977');
/*!40000 ALTER TABLE `marketing_emailtemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_failedcontact`
--

DROP TABLE IF EXISTS `marketing_failedcontact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_failedcontact` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_on` datetime(6) NOT NULL,
  `name` varchar(500) DEFAULT NULL,
  `email` varchar(254) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `company_name` varchar(500) DEFAULT NULL,
  `last_name` varchar(500) DEFAULT NULL,
  `city` varchar(500) DEFAULT NULL,
  `state` varchar(500) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `country` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_failedcontact_created_by_id_69df0cfc_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `marketing_failedcontact_created_by_id_69df0cfc_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_failedcontact`
--

LOCK TABLES `marketing_failedcontact` WRITE;
/*!40000 ALTER TABLE `marketing_failedcontact` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_failedcontact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_failedcontact_contact_list`
--

DROP TABLE IF EXISTS `marketing_failedcontact_contact_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_failedcontact_contact_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `failedcontact_id` int(11) NOT NULL,
  `contactlist_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `marketing_failedcontact__failedcontact_id_contact_d1cdb0d5_uniq` (`failedcontact_id`,`contactlist_id`),
  KEY `marketing_failedcont_contactlist_id_0774af5c_fk_marketing` (`contactlist_id`),
  CONSTRAINT `marketing_failedcont_contactlist_id_0774af5c_fk_marketing` FOREIGN KEY (`contactlist_id`) REFERENCES `marketing_contactlist` (`id`),
  CONSTRAINT `marketing_failedcont_failedcontact_id_2ec42ab1_fk_marketing` FOREIGN KEY (`failedcontact_id`) REFERENCES `marketing_failedcontact` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_failedcontact_contact_list`
--

LOCK TABLES `marketing_failedcontact_contact_list` WRITE;
/*!40000 ALTER TABLE `marketing_failedcontact_contact_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_failedcontact_contact_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_link`
--

DROP TABLE IF EXISTS `marketing_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_link` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `original` varchar(2100) NOT NULL,
  `clicks` int(11) NOT NULL,
  `unique` int(11) NOT NULL,
  `campaign_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_link_campaign_id_87874449_fk_marketing_campaign_id` (`campaign_id`),
  CONSTRAINT `marketing_link_campaign_id_87874449_fk_marketing_campaign_id` FOREIGN KEY (`campaign_id`) REFERENCES `marketing_campaign` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_link`
--

LOCK TABLES `marketing_link` WRITE;
/*!40000 ALTER TABLE `marketing_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `marketing_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marketing_tag`
--

DROP TABLE IF EXISTS `marketing_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `marketing_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(500) NOT NULL,
  `color` varchar(20) NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `created_on` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_tag_created_by_id_e0e8f0cb_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `marketing_tag_created_by_id_e0e8f0cb_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_tag`
--

LOCK TABLES `marketing_tag` WRITE;
/*!40000 ALTER TABLE `marketing_tag` DISABLE KEYS */;
INSERT INTO `marketing_tag` VALUES (1,'contact','#999999',1,'2020-05-04 04:48:44.791818'),(2,'contacts','#999999',1,'2020-05-04 05:32:38.025489'),(3,'language','#999999',1,'2020-05-07 05:53:04.178414'),(4,'list_of_contact','#999999',1,'2020-05-13 04:51:42.893161');
/*!40000 ALTER TABLE `marketing_tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opportunity_opportunity`
--

DROP TABLE IF EXISTS `opportunity_opportunity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `opportunity_opportunity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `stage` varchar(64) NOT NULL,
  `currency` varchar(3) DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `lead_source` varchar(255) DEFAULT NULL,
  `probability` int(11) DEFAULT NULL,
  `closed_on` date DEFAULT NULL,
  `description` longtext,
  `created_on` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `closed_by_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `opportunity_opportun_account_id_fc820cad_fk_accounts_` (`account_id`),
  KEY `opportunity_opportunity_closed_by_id_7399917f_fk_common_user_id` (`closed_by_id`),
  KEY `opportunity_opportunity_created_by_id_89d5f804_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `opportunity_opportun_account_id_fc820cad_fk_accounts_` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `opportunity_opportunity_closed_by_id_7399917f_fk_common_user_id` FOREIGN KEY (`closed_by_id`) REFERENCES `common_user` (`id`),
  CONSTRAINT `opportunity_opportunity_created_by_id_89d5f804_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opportunity_opportunity`
--

LOCK TABLES `opportunity_opportunity` WRITE;
/*!40000 ALTER TABLE `opportunity_opportunity` DISABLE KEYS */;
INSERT INTO `opportunity_opportunity` VALUES (12,'nmo','QUALIFICATION','INR',35.00,'PARTNER',10,NULL,'','2020-06-04 09:54:50.261537',0,3,NULL,1),(13,'nju','NEEDS ANALYSIS','INR',32.00,'CALL',10,NULL,'','2020-06-04 09:55:25.301714',0,1,NULL,1);
/*!40000 ALTER TABLE `opportunity_opportunity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opportunity_opportunity_assigned_to`
--

DROP TABLE IF EXISTS `opportunity_opportunity_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `opportunity_opportunity_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `opportunity_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `opportunity_opportunity__opportunity_id_user_id_b1055494_uniq` (`opportunity_id`,`user_id`),
  KEY `opportunity_opportun_user_id_ce65565d_fk_common_us` (`user_id`),
  CONSTRAINT `opportunity_opportun_opportunity_id_1c8df51a_fk_opportuni` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity_opportunity` (`id`),
  CONSTRAINT `opportunity_opportun_user_id_ce65565d_fk_common_us` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opportunity_opportunity_assigned_to`
--

LOCK TABLES `opportunity_opportunity_assigned_to` WRITE;
/*!40000 ALTER TABLE `opportunity_opportunity_assigned_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `opportunity_opportunity_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opportunity_opportunity_contacts`
--

DROP TABLE IF EXISTS `opportunity_opportunity_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `opportunity_opportunity_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `opportunity_id` int(11) NOT NULL,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `opportunity_opportunity__opportunity_id_contact_i_0184536a_uniq` (`opportunity_id`,`contact_id`),
  KEY `opportunity_opportun_contact_id_64ee0712_fk_contacts_` (`contact_id`),
  CONSTRAINT `opportunity_opportun_contact_id_64ee0712_fk_contacts_` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `opportunity_opportun_opportunity_id_01fbf845_fk_opportuni` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity_opportunity` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opportunity_opportunity_contacts`
--

LOCK TABLES `opportunity_opportunity_contacts` WRITE;
/*!40000 ALTER TABLE `opportunity_opportunity_contacts` DISABLE KEYS */;
INSERT INTO `opportunity_opportunity_contacts` VALUES (11,12,2),(12,13,3);
/*!40000 ALTER TABLE `opportunity_opportunity_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opportunity_opportunity_tags`
--

DROP TABLE IF EXISTS `opportunity_opportunity_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `opportunity_opportunity_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `opportunity_id` int(11) NOT NULL,
  `tags_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `opportunity_opportunity__opportunity_id_tags_id_c03dc1e3_uniq` (`opportunity_id`,`tags_id`),
  KEY `opportunity_opportun_tags_id_89b307a4_fk_accounts_` (`tags_id`),
  CONSTRAINT `opportunity_opportun_opportunity_id_98683361_fk_opportuni` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity_opportunity` (`id`),
  CONSTRAINT `opportunity_opportun_tags_id_89b307a4_fk_accounts_` FOREIGN KEY (`tags_id`) REFERENCES `accounts_tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opportunity_opportunity_tags`
--

LOCK TABLES `opportunity_opportunity_tags` WRITE;
/*!40000 ALTER TABLE `opportunity_opportunity_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `opportunity_opportunity_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `opportunity_opportunity_teams`
--

DROP TABLE IF EXISTS `opportunity_opportunity_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `opportunity_opportunity_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `opportunity_id` int(11) NOT NULL,
  `teams_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `opportunity_opportunity__opportunity_id_teams_id_5963d744_uniq` (`opportunity_id`,`teams_id`),
  KEY `opportunity_opportun_teams_id_4f8d4a54_fk_teams_tea` (`teams_id`),
  CONSTRAINT `opportunity_opportun_opportunity_id_81eab463_fk_opportuni` FOREIGN KEY (`opportunity_id`) REFERENCES `opportunity_opportunity` (`id`),
  CONSTRAINT `opportunity_opportun_teams_id_4f8d4a54_fk_teams_tea` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opportunity_opportunity_teams`
--

LOCK TABLES `opportunity_opportunity_teams` WRITE;
/*!40000 ALTER TABLE `opportunity_opportunity_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `opportunity_opportunity_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planner_event`
--

DROP TABLE IF EXISTS `planner_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planner_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `event_type` varchar(7) NOT NULL,
  `object_id` int(10) unsigned DEFAULT NULL,
  `status` varchar(64) NOT NULL,
  `direction` varchar(20) NOT NULL,
  `start_date` date NOT NULL,
  `close_date` date DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `priority` varchar(10) NOT NULL,
  `updated_on` datetime(6) NOT NULL,
  `created_on` datetime(6) NOT NULL,
  `description` longtext,
  `is_active` tinyint(1) NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `planner_event_created_by_id_ff507edf_fk_common_user_id` (`created_by_id`),
  KEY `planner_event_updated_by_id_1a3b400a_fk_common_user_id` (`updated_by_id`),
  KEY `planner_event_content_type_id_e1697281_fk_django_content_type_id` (`content_type_id`),
  CONSTRAINT `planner_event_content_type_id_e1697281_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `planner_event_created_by_id_ff507edf_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`),
  CONSTRAINT `planner_event_updated_by_id_1a3b400a_fk_common_user_id` FOREIGN KEY (`updated_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planner_event`
--

LOCK TABLES `planner_event` WRITE;
/*!40000 ALTER TABLE `planner_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `planner_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planner_event_assigned_to`
--

DROP TABLE IF EXISTS `planner_event_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planner_event_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `planner_event_assigned_to_event_id_user_id_a9857a09_uniq` (`event_id`,`user_id`),
  KEY `planner_event_assigned_to_user_id_3d65f14a_fk_common_user_id` (`user_id`),
  CONSTRAINT `planner_event_assigned_to_event_id_467b0d2b_fk_planner_event_id` FOREIGN KEY (`event_id`) REFERENCES `planner_event` (`id`),
  CONSTRAINT `planner_event_assigned_to_user_id_3d65f14a_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planner_event_assigned_to`
--

LOCK TABLES `planner_event_assigned_to` WRITE;
/*!40000 ALTER TABLE `planner_event_assigned_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `planner_event_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planner_event_attendees_contacts`
--

DROP TABLE IF EXISTS `planner_event_attendees_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planner_event_attendees_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `planner_event_attendees__event_id_contact_id_a1abf61b_uniq` (`event_id`,`contact_id`),
  KEY `planner_event_attend_contact_id_2c29dbd4_fk_contacts_` (`contact_id`),
  CONSTRAINT `planner_event_attend_contact_id_2c29dbd4_fk_contacts_` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `planner_event_attend_event_id_7a6e26bc_fk_planner_e` FOREIGN KEY (`event_id`) REFERENCES `planner_event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planner_event_attendees_contacts`
--

LOCK TABLES `planner_event_attendees_contacts` WRITE;
/*!40000 ALTER TABLE `planner_event_attendees_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `planner_event_attendees_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planner_event_attendees_leads`
--

DROP TABLE IF EXISTS `planner_event_attendees_leads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planner_event_attendees_leads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `lead_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `planner_event_attendees_leads_event_id_lead_id_2f4d367c_uniq` (`event_id`,`lead_id`),
  KEY `planner_event_attendees_leads_lead_id_b543353a_fk_leads_lead_id` (`lead_id`),
  CONSTRAINT `planner_event_attend_event_id_05e9c4f9_fk_planner_e` FOREIGN KEY (`event_id`) REFERENCES `planner_event` (`id`),
  CONSTRAINT `planner_event_attendees_leads_lead_id_b543353a_fk_leads_lead_id` FOREIGN KEY (`lead_id`) REFERENCES `leads_lead` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planner_event_attendees_leads`
--

LOCK TABLES `planner_event_attendees_leads` WRITE;
/*!40000 ALTER TABLE `planner_event_attendees_leads` DISABLE KEYS */;
/*!40000 ALTER TABLE `planner_event_attendees_leads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planner_event_attendees_user`
--

DROP TABLE IF EXISTS `planner_event_attendees_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planner_event_attendees_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `planner_event_attendees_user_event_id_user_id_89db87fa_uniq` (`event_id`,`user_id`),
  KEY `planner_event_attendees_user_user_id_d6b53a5e_fk_common_user_id` (`user_id`),
  CONSTRAINT `planner_event_attend_event_id_f806e2a6_fk_planner_e` FOREIGN KEY (`event_id`) REFERENCES `planner_event` (`id`),
  CONSTRAINT `planner_event_attendees_user_user_id_d6b53a5e_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planner_event_attendees_user`
--

LOCK TABLES `planner_event_attendees_user` WRITE;
/*!40000 ALTER TABLE `planner_event_attendees_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `planner_event_attendees_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planner_event_reminders`
--

DROP TABLE IF EXISTS `planner_event_reminders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planner_event_reminders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL,
  `reminder_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `planner_event_reminders_event_id_reminder_id_ee1ba293_uniq` (`event_id`,`reminder_id`),
  KEY `planner_event_remind_reminder_id_a980f736_fk_planner_r` (`reminder_id`),
  CONSTRAINT `planner_event_remind_reminder_id_a980f736_fk_planner_r` FOREIGN KEY (`reminder_id`) REFERENCES `planner_reminder` (`id`),
  CONSTRAINT `planner_event_reminders_event_id_9c33650c_fk_planner_event_id` FOREIGN KEY (`event_id`) REFERENCES `planner_event` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planner_event_reminders`
--

LOCK TABLES `planner_event_reminders` WRITE;
/*!40000 ALTER TABLE `planner_event_reminders` DISABLE KEYS */;
/*!40000 ALTER TABLE `planner_event_reminders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `planner_reminder`
--

DROP TABLE IF EXISTS `planner_reminder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `planner_reminder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reminder_type` varchar(5) DEFAULT NULL,
  `reminder_time` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `planner_reminder`
--

LOCK TABLES `planner_reminder` WRITE;
/*!40000 ALTER TABLE `planner_reminder` DISABLE KEYS */;
/*!40000 ALTER TABLE `planner_reminder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sla`
--

DROP TABLE IF EXISTS `sla`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sla` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `voiceopen_status` varchar(64) NOT NULL,
  `voiceopen_respond_within` time(6) DEFAULT NULL,
  `voiceopen_escalate_mail` varchar(255) NOT NULL,
  `voiceprogress_status` varchar(64) NOT NULL,
  `voiceprogress_respond_within` time(6) DEFAULT NULL,
  `voiceprogress_escalate_mail` varchar(255) NOT NULL,
  `emailopen_status` varchar(64) NOT NULL,
  `emailopen_respond_within` time(6) DEFAULT NULL,
  `emailopen_escalate_mail` varchar(255) NOT NULL,
  `emailprogress_status` varchar(64) NOT NULL,
  `emailprogress_respond_within` varchar(255) NOT NULL,
  `emailprogress_escalate_mail` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sla`
--

LOCK TABLES `sla` WRITE;
/*!40000 ALTER TABLE `sla` DISABLE KEYS */;
INSERT INTO `sla` VALUES (2,'Open','00:30:00.000000','','In Progress','00:40:00.000000','','Open','01:00:00.000000','','In Progress','1','');
/*!40000 ALTER TABLE `sla` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slaemail`
--

DROP TABLE IF EXISTS `slaemail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `slaemail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(64) NOT NULL,
  `respond_within` time(6) DEFAULT NULL,
  `escalate_email` varchar(255) NOT NULL,
  `escalate_to_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `slaemail_escalate_to_id_d0ab44d3_fk_common_user_id` (`escalate_to_id`),
  CONSTRAINT `slaemail_escalate_to_id_d0ab44d3_fk_common_user_id` FOREIGN KEY (`escalate_to_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slaemail`
--

LOCK TABLES `slaemail` WRITE;
/*!40000 ALTER TABLE `slaemail` DISABLE KEYS */;
/*!40000 ALTER TABLE `slaemail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `slavoice`
--

DROP TABLE IF EXISTS `slavoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `slavoice` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(64) NOT NULL,
  `respond_within` time(6) DEFAULT NULL,
  `escalate_mail` varchar(255) NOT NULL,
  `escalate_to_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `slavoice_escalate_to_id_96cbcef5_fk_common_user_id` (`escalate_to_id`),
  CONSTRAINT `slavoice_escalate_to_id_96cbcef5_fk_common_user_id` FOREIGN KEY (`escalate_to_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `slavoice`
--

LOCK TABLES `slavoice` WRITE;
/*!40000 ALTER TABLE `slavoice` DISABLE KEYS */;
/*!40000 ALTER TABLE `slavoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks_task`
--

DROP TABLE IF EXISTS `tasks_task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `status` varchar(50) NOT NULL,
  `priority` varchar(50) NOT NULL,
  `due_date` date DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `created_on` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `tasks_task_account_id_b76993dd_fk_accounts_account_id` (`account_id`),
  KEY `tasks_task_created_by_id_1345568a_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `tasks_task_account_id_b76993dd_fk_accounts_account_id` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `tasks_task_created_by_id_1345568a_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks_task`
--

LOCK TABLES `tasks_task` WRITE;
/*!40000 ALTER TABLE `tasks_task` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks_task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks_task_assigned_to`
--

DROP TABLE IF EXISTS `tasks_task_assigned_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks_task_assigned_to` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tasks_task_assigned_to_task_id_user_id_5e8e7fa1_uniq` (`task_id`,`user_id`),
  KEY `tasks_task_assigned_to_user_id_a003647a_fk_common_user_id` (`user_id`),
  CONSTRAINT `tasks_task_assigned_to_task_id_daf1a7ac_fk_tasks_task_id` FOREIGN KEY (`task_id`) REFERENCES `tasks_task` (`id`),
  CONSTRAINT `tasks_task_assigned_to_user_id_a003647a_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks_task_assigned_to`
--

LOCK TABLES `tasks_task_assigned_to` WRITE;
/*!40000 ALTER TABLE `tasks_task_assigned_to` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks_task_assigned_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks_task_contacts`
--

DROP TABLE IF EXISTS `tasks_task_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks_task_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) NOT NULL,
  `contact_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tasks_task_contacts_task_id_contact_id_7a2e8081_uniq` (`task_id`,`contact_id`),
  KEY `tasks_task_contacts_contact_id_29ef4ac7_fk_contacts_contact_id` (`contact_id`),
  CONSTRAINT `tasks_task_contacts_contact_id_29ef4ac7_fk_contacts_contact_id` FOREIGN KEY (`contact_id`) REFERENCES `contacts_contact` (`id`),
  CONSTRAINT `tasks_task_contacts_task_id_90df7d53_fk_tasks_task_id` FOREIGN KEY (`task_id`) REFERENCES `tasks_task` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks_task_contacts`
--

LOCK TABLES `tasks_task_contacts` WRITE;
/*!40000 ALTER TABLE `tasks_task_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks_task_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tasks_task_teams`
--

DROP TABLE IF EXISTS `tasks_task_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks_task_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) NOT NULL,
  `teams_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `tasks_task_teams_task_id_teams_id_b550c90f_uniq` (`task_id`,`teams_id`),
  KEY `tasks_task_teams_teams_id_69d613d1_fk_teams_teams_id` (`teams_id`),
  CONSTRAINT `tasks_task_teams_task_id_d1e3d547_fk_tasks_task_id` FOREIGN KEY (`task_id`) REFERENCES `tasks_task` (`id`),
  CONSTRAINT `tasks_task_teams_teams_id_69d613d1_fk_teams_teams_id` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tasks_task_teams`
--

LOCK TABLES `tasks_task_teams` WRITE;
/*!40000 ALTER TABLE `tasks_task_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `tasks_task_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams_teams`
--

DROP TABLE IF EXISTS `teams_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teams_teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `created_on` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `teams_teams_created_by_id_c6e9aee3_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `teams_teams_created_by_id_c6e9aee3_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams_teams`
--

LOCK TABLES `teams_teams` WRITE;
/*!40000 ALTER TABLE `teams_teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `teams_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams_teams_users`
--

DROP TABLE IF EXISTS `teams_teams_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teams_teams_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `teams_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `teams_teams_users_teams_id_user_id_d2c2dd7b_uniq` (`teams_id`,`user_id`),
  KEY `teams_teams_users_user_id_f834347a_fk_common_user_id` (`user_id`),
  CONSTRAINT `teams_teams_users_teams_id_14b49914_fk_teams_teams_id` FOREIGN KEY (`teams_id`) REFERENCES `teams_teams` (`id`),
  CONSTRAINT `teams_teams_users_user_id_f834347a_fk_common_user_id` FOREIGN KEY (`user_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams_teams_users`
--

LOCK TABLES `teams_teams_users` WRITE;
/*!40000 ALTER TABLE `teams_teams_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `teams_teams_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `thumbnail_kvstore`
--

DROP TABLE IF EXISTS `thumbnail_kvstore`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `thumbnail_kvstore` (
  `key` varchar(200) NOT NULL,
  `value` longtext NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `thumbnail_kvstore`
--

LOCK TABLES `thumbnail_kvstore` WRITE;
/*!40000 ALTER TABLE `thumbnail_kvstore` DISABLE KEYS */;
/*!40000 ALTER TABLE `thumbnail_kvstore` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `updatecase`
--

DROP TABLE IF EXISTS `updatecase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `updatecase` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `field` varchar(100) NOT NULL,
  `oldvalue` varchar(100) NOT NULL,
  `newvalue` varchar(100) NOT NULL,
  `changedate` datetime(6) NOT NULL,
  `changedby` varchar(100) NOT NULL,
  `case_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `updatecase_case_id_6bb144f8_fk_cases_case_id` (`case_id`),
  CONSTRAINT `updatecase_case_id_6bb144f8_fk_cases_case_id` FOREIGN KEY (`case_id`) REFERENCES `cases_case` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `updatecase`
--

LOCK TABLES `updatecase` WRITE;
/*!40000 ALTER TABLE `updatecase` DISABLE KEYS */;
INSERT INTO `updatecase` VALUES (16,'status','Open','In Progress','2020-06-05 09:18:49.684585','admin',49),(17,'status','Open','In Progress','2020-06-09 11:24:55.847721','admin',51),(18,'status','Open','In Progress','2020-06-10 04:07:58.674927','admin',53),(19,'status','In Progress','Closed','2020-06-10 11:44:54.745213','admin',49),(20,'status','Open','In Progress','2020-06-18 12:34:11.873907','admin',58),(21,'status','Open','In Progress','2020-06-18 12:36:00.202502','naren',61),(22,'status','Open','Closed','2020-06-18 12:37:02.339041','naren',62);
/*!40000 ALTER TABLE `updatecase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `useremail`
--

DROP TABLE IF EXISTS `useremail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `useremail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `useremail_category_id_543ab536_fk_contacts_contact_id` (`category_id`),
  CONSTRAINT `useremail_category_id_543ab536_fk_contacts_contact_id` FOREIGN KEY (`category_id`) REFERENCES `contacts_contact` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `useremail`
--

LOCK TABLES `useremail` WRITE;
/*!40000 ALTER TABLE `useremail` DISABLE KEYS */;
INSERT INTO `useremail` VALUES (1,'raj@gmail.com',1),(2,'bhavani@gmail.com',2),(3,'sakthi@gmail.com',3),(4,'def@gmail.com',4),(7,'ascdf@gmail.com',5),(8,'nmk@gmail.com',5);
/*!40000 ALTER TABLE `useremail` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-06-19 10:44:19
