-- MySQL dump 10.13  Distrib 5.7.28, for Linux (x86_64)
--
-- Host: localhost    Database: dj_crm
-- ------------------------------------------------------
-- Server version	5.7.28-0ubuntu0.18.04.4

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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_account`
--

LOCK TABLES `accounts_account` WRITE;
/*!40000 ALTER TABLE `accounts_account` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_account_assigned_to`
--

LOCK TABLES `accounts_account_assigned_to` WRITE;
/*!40000 ALTER TABLE `accounts_account_assigned_to` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts_account_contacts`
--

LOCK TABLES `accounts_account_contacts` WRITE;
/*!40000 ALTER TABLE `accounts_account_contacts` DISABLE KEYS */;
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
INSERT INTO `auth_permission` VALUES (1,'Can add permission',1,'add_permission'),(2,'Can change permission',1,'change_permission'),(3,'Can delete permission',1,'delete_permission'),(4,'Can view permission',1,'view_permission'),(5,'Can add group',2,'add_group'),(6,'Can change group',2,'change_group'),(7,'Can delete group',2,'delete_group'),(8,'Can view group',2,'view_group'),(9,'Can add content type',3,'add_contenttype'),(10,'Can change content type',3,'change_contenttype'),(11,'Can delete content type',3,'delete_contenttype'),(12,'Can view content type',3,'view_contenttype'),(13,'Can add session',4,'add_session'),(14,'Can change session',4,'change_session'),(15,'Can delete session',4,'delete_session'),(16,'Can view session',4,'view_session'),(17,'Can add user',5,'add_user'),(18,'Can change user',5,'change_user'),(19,'Can delete user',5,'delete_user'),(20,'Can view user',5,'view_user'),(21,'Can add address',6,'add_address'),(22,'Can change address',6,'change_address'),(23,'Can delete address',6,'delete_address'),(24,'Can view address',6,'view_address'),(25,'Can add attachments',7,'add_attachments'),(26,'Can change attachments',7,'change_attachments'),(27,'Can delete attachments',7,'delete_attachments'),(28,'Can view attachments',7,'view_attachments'),(29,'Can add comment',8,'add_comment'),(30,'Can change comment',8,'change_comment'),(31,'Can delete comment',8,'delete_comment'),(32,'Can view comment',8,'view_comment'),(33,'Can add comment_ files',9,'add_comment_files'),(34,'Can change comment_ files',9,'change_comment_files'),(35,'Can delete comment_ files',9,'delete_comment_files'),(36,'Can view comment_ files',9,'view_comment_files'),(37,'Can add document',10,'add_document'),(38,'Can change document',10,'change_document'),(39,'Can delete document',10,'delete_document'),(40,'Can view document',10,'view_document'),(41,'Can add google',11,'add_google'),(42,'Can change google',11,'change_google'),(43,'Can delete google',11,'delete_google'),(44,'Can view google',11,'view_google'),(45,'Can add api settings',12,'add_apisettings'),(46,'Can change api settings',12,'change_apisettings'),(47,'Can delete api settings',12,'delete_apisettings'),(48,'Can view api settings',12,'view_apisettings'),(49,'Can add profile',13,'add_profile'),(50,'Can change profile',13,'change_profile'),(51,'Can delete profile',13,'delete_profile'),(52,'Can view profile',13,'view_profile'),(53,'Can add account',14,'add_account'),(54,'Can change account',14,'change_account'),(55,'Can delete account',14,'delete_account'),(56,'Can view account',14,'view_account'),(57,'Can add tags',15,'add_tags'),(58,'Can change tags',15,'change_tags'),(59,'Can delete tags',15,'delete_tags'),(60,'Can view tags',15,'view_tags'),(61,'Can add email',16,'add_email'),(62,'Can change email',16,'change_email'),(63,'Can delete email',16,'delete_email'),(64,'Can view email',16,'view_email'),(65,'Can add email log',17,'add_emaillog'),(66,'Can change email log',17,'change_emaillog'),(67,'Can delete email log',17,'delete_emaillog'),(68,'Can view email log',17,'view_emaillog'),(69,'Can add case',18,'add_case'),(70,'Can change case',18,'change_case'),(71,'Can delete case',18,'delete_case'),(72,'Can view case',18,'view_case'),(73,'Can add contact',19,'add_contact'),(74,'Can change contact',19,'change_contact'),(75,'Can delete contact',19,'delete_contact'),(76,'Can view contact',19,'view_contact'),(77,'Can add email',20,'add_email'),(78,'Can change email',20,'change_email'),(79,'Can delete email',20,'delete_email'),(80,'Can view email',20,'view_email'),(81,'Can add lead',21,'add_lead'),(82,'Can change lead',21,'change_lead'),(83,'Can delete lead',21,'delete_lead'),(84,'Can view lead',21,'view_lead'),(85,'Can add opportunity',22,'add_opportunity'),(86,'Can change opportunity',22,'change_opportunity'),(87,'Can delete opportunity',22,'delete_opportunity'),(88,'Can view opportunity',22,'view_opportunity'),(89,'Can add event',23,'add_event'),(90,'Can change event',23,'change_event'),(91,'Can delete event',23,'delete_event'),(92,'Can view event',23,'view_event'),(93,'Can add reminder',24,'add_reminder'),(94,'Can change reminder',24,'change_reminder'),(95,'Can delete reminder',24,'delete_reminder'),(96,'Can view reminder',24,'view_reminder'),(97,'Can add kv store',25,'add_kvstore'),(98,'Can change kv store',25,'change_kvstore'),(99,'Can delete kv store',25,'delete_kvstore'),(100,'Can view kv store',25,'view_kvstore'),(101,'Can add campaign',26,'add_campaign'),(102,'Can change campaign',26,'change_campaign'),(103,'Can delete campaign',26,'delete_campaign'),(104,'Can view campaign',26,'view_campaign'),(105,'Can add campaign link click',27,'add_campaignlinkclick'),(106,'Can change campaign link click',27,'change_campaignlinkclick'),(107,'Can delete campaign link click',27,'delete_campaignlinkclick'),(108,'Can view campaign link click',27,'view_campaignlinkclick'),(109,'Can add campaign log',28,'add_campaignlog'),(110,'Can change campaign log',28,'change_campaignlog'),(111,'Can delete campaign log',28,'delete_campaignlog'),(112,'Can view campaign log',28,'view_campaignlog'),(113,'Can add campaign open',29,'add_campaignopen'),(114,'Can change campaign open',29,'change_campaignopen'),(115,'Can delete campaign open',29,'delete_campaignopen'),(116,'Can view campaign open',29,'view_campaignopen'),(117,'Can add contact',30,'add_contact'),(118,'Can change contact',30,'change_contact'),(119,'Can delete contact',30,'delete_contact'),(120,'Can view contact',30,'view_contact'),(121,'Can add contact list',31,'add_contactlist'),(122,'Can change contact list',31,'change_contactlist'),(123,'Can delete contact list',31,'delete_contactlist'),(124,'Can view contact list',31,'view_contactlist'),(125,'Can add email template',32,'add_emailtemplate'),(126,'Can change email template',32,'change_emailtemplate'),(127,'Can delete email template',32,'delete_emailtemplate'),(128,'Can view email template',32,'view_emailtemplate'),(129,'Can add link',33,'add_link'),(130,'Can change link',33,'change_link'),(131,'Can delete link',33,'delete_link'),(132,'Can view link',33,'view_link'),(133,'Can add tag',34,'add_tag'),(134,'Can change tag',34,'change_tag'),(135,'Can delete tag',34,'delete_tag'),(136,'Can view tag',34,'view_tag'),(137,'Can add failed contact',35,'add_failedcontact'),(138,'Can change failed contact',35,'change_failedcontact'),(139,'Can delete failed contact',35,'delete_failedcontact'),(140,'Can view failed contact',35,'view_failedcontact'),(141,'Can add campaign completed',36,'add_campaigncompleted'),(142,'Can change campaign completed',36,'change_campaigncompleted'),(143,'Can delete campaign completed',36,'delete_campaigncompleted'),(144,'Can view campaign completed',36,'view_campaigncompleted'),(145,'Can add contact unsubscribed campaign',37,'add_contactunsubscribedcampaign'),(146,'Can change contact unsubscribed campaign',37,'change_contactunsubscribedcampaign'),(147,'Can delete contact unsubscribed campaign',37,'delete_contactunsubscribedcampaign'),(148,'Can view contact unsubscribed campaign',37,'view_contactunsubscribedcampaign'),(149,'Can add contact email campaign',38,'add_contactemailcampaign'),(150,'Can change contact email campaign',38,'change_contactemailcampaign'),(151,'Can delete contact email campaign',38,'delete_contactemailcampaign'),(152,'Can view contact email campaign',38,'view_contactemailcampaign'),(153,'Can add duplicate contacts',39,'add_duplicatecontacts'),(154,'Can change duplicate contacts',39,'change_duplicatecontacts'),(155,'Can delete duplicate contacts',39,'delete_duplicatecontacts'),(156,'Can view duplicate contacts',39,'view_duplicatecontacts'),(157,'Can add blocked email',40,'add_blockedemail'),(158,'Can change blocked email',40,'change_blockedemail'),(159,'Can delete blocked email',40,'delete_blockedemail'),(160,'Can view blocked email',40,'view_blockedemail'),(161,'Can add blocked domain',41,'add_blockeddomain'),(162,'Can change blocked domain',41,'change_blockeddomain'),(163,'Can delete blocked domain',41,'delete_blockeddomain'),(164,'Can view blocked domain',41,'view_blockeddomain'),(165,'Can add task',42,'add_task'),(166,'Can change task',42,'change_task'),(167,'Can delete task',42,'delete_task'),(168,'Can view task',42,'view_task'),(169,'Can add Invoice',43,'add_invoice'),(170,'Can change Invoice',43,'change_invoice'),(171,'Can delete Invoice',43,'delete_invoice'),(172,'Can view Invoice',43,'view_invoice'),(173,'Can add invoice history',44,'add_invoicehistory'),(174,'Can change invoice history',44,'change_invoicehistory'),(175,'Can delete invoice history',44,'delete_invoicehistory'),(176,'Can view invoice history',44,'view_invoicehistory'),(177,'Can add event',45,'add_event'),(178,'Can change event',45,'change_event'),(179,'Can delete event',45,'delete_event'),(180,'Can view event',45,'view_event'),(181,'Can add teams',46,'add_teams'),(182,'Can change teams',46,'change_teams'),(183,'Can delete teams',46,'delete_teams'),(184,'Can view teams',46,'view_teams'),(185,'Can add contractor',47,'add_contractor'),(186,'Can change contractor',47,'change_contractor'),(187,'Can delete contractor',47,'delete_contractor'),(188,'Can view contractor',47,'view_contractor'),(189,'Can add entry exit',48,'add_entryexit'),(190,'Can change entry exit',48,'change_entryexit'),(191,'Can delete entry exit',48,'delete_entryexit'),(192,'Can view entry exit',48,'view_entryexit'),(193,'Can add staff',49,'add_staff'),(194,'Can change staff',49,'change_staff'),(195,'Can delete staff',49,'delete_staff'),(196,'Can view staff',49,'view_staff'),(197,'Can add visitor',50,'add_visitor'),(198,'Can change visitor',50,'change_visitor'),(199,'Can delete visitor',50,'delete_visitor'),(200,'Can view visitor',50,'view_visitor'),(201,'Can add test',51,'add_test'),(202,'Can change test',51,'change_test'),(203,'Can delete test',51,'delete_test'),(204,'Can view test',51,'view_test'),(205,'Can add sample',52,'add_sample'),(206,'Can change sample',52,'change_sample'),(207,'Can delete sample',52,'delete_sample'),(208,'Can view sample',52,'view_sample');
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
  `status` varchar(64) NOT NULL,
  `priority` varchar(64) NOT NULL,
  `case_type` varchar(255) DEFAULT NULL,
  `closed_on` date NOT NULL,
  `description` longtext,
  `created_on` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `account_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `phone1` varchar(20) DEFAULT NULL,
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone1` (`phone1`),
  KEY `cases_case_account_id_18367a6b_fk_accounts_account_id` (`account_id`),
  KEY `cases_case_created_by_id_91d115ec_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `cases_case_account_id_18367a6b_fk_accounts_account_id` FOREIGN KEY (`account_id`) REFERENCES `accounts_account` (`id`),
  CONSTRAINT `cases_case_created_by_id_91d115ec_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases_case`
--

LOCK TABLES `cases_case` WRITE;
/*!40000 ALTER TABLE `cases_case` DISABLE KEYS */;
INSERT INTO `cases_case` VALUES (7,'Open','Critical','Typhoon','2020-01-18','','2020-01-18 11:51:21.997017',0,NULL,1,'+91-987-567-1234','ragavi'),(8,'Open','Critical',NULL,'2020-01-18','','2020-01-18 11:51:57.933569',0,NULL,1,'+91-987-567-4456','manju'),(9,'In Progress','Not Critical',NULL,'2020-01-18','','2020-01-18 11:52:29.964559',0,NULL,1,'+91-987-123-3657','lakshmi'),(10,'In Progress','Not Critical',NULL,'2020-01-18','','2020-01-18 11:53:05.768719',0,NULL,1,'+91-876-456-1234','rohith'),(11,'Close','Critical','Typhoon','2020-01-18','','2020-01-18 11:53:39.597277',0,NULL,1,'+91-987-567-9998','monika'),(12,'Close','Not Critical','EarthQuake','2020-01-18','','2020-01-18 11:55:14.879184',0,NULL,1,'+91-678-567-9876','nivedha'),(13,'Open','Critical','Fire','2020-01-20','hj','2020-01-18 11:58:30.471451',0,NULL,1,'+90 090-909-9090','test'),(14,'Open','Critical','Fire','2020-01-20','','2020-01-20 05:33:42.441009',0,NULL,1,'+91-987-567-4567','janani'),(37,'Open','Critical',NULL,'2020-01-20','','2020-01-20 12:30:05.312446',0,NULL,2,'+91-987-456-1234','vijay'),(50,'Open','Critical',NULL,'2020-01-21','','2020-01-21 12:15:02.384053',0,NULL,1,'+91-987-567-7654','abc');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases_case_assigned_to`
--

LOCK TABLES `cases_case_assigned_to` WRITE;
/*!40000 ALTER TABLE `cases_case_assigned_to` DISABLE KEYS */;
INSERT INTO `cases_case_assigned_to` VALUES (1,14,2);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cases_case_contacts`
--

LOCK TABLES `cases_case_contacts` WRITE;
/*!40000 ALTER TABLE `cases_case_contacts` DISABLE KEYS */;
INSERT INTO `cases_case_contacts` VALUES (3,13,3);
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
  `address_line` longtext,
  `street` varchar(55) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `postcode` varchar(64) DEFAULT NULL,
  `country` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_address`
--

LOCK TABLES `common_address` WRITE;
/*!40000 ALTER TABLE `common_address` DISABLE KEYS */;
INSERT INTO `common_address` VALUES (1,NULL,NULL,NULL,NULL,NULL,NULL),(2,NULL,NULL,NULL,NULL,NULL,NULL),(3,'no:32','nehru street','pondicherry','pondicherry',NULL,'IN'),(4,NULL,NULL,NULL,NULL,NULL,NULL),(5,'1,abcd street',NULL,'pondicherry','pondicherry','605003','IN');
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_comment`
--

LOCK TABLES `common_comment` WRITE;
/*!40000 ALTER TABLE `common_comment` DISABLE KEYS */;
INSERT INTO `common_comment` VALUES (1,'hi','2020-01-20 05:36:32.653629',NULL,14,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `common_user`
--

LOCK TABLES `common_user` WRITE;
/*!40000 ALTER TABLE `common_user` DISABLE KEYS */;
INSERT INTO `common_user` VALUES (1,'pbkdf2_sha256$150000$hqKRM7NRaxMg$7+nL02aArV5hE5t1fghVXfCspERMO9asd+66+L2XN5M=','2020-01-23 04:09:22.338363',1,'admin','','','admin@gmail.com',1,0,1,'2020-01-18 06:26:53.221000','','',0,0),(2,'pbkdf2_sha256$150000$wYjr2azo8vjO$xj5erdpvaRkzGHBum/SbtbqBHWsVyEjp4lsE6FMi1+E=','2020-01-20 12:29:31.352770',0,'test','test','t','test@gmail.com',1,0,0,'2020-01-20 05:34:40.164211','USER','',0,1);
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
  `phone2` varchar(20) DEFAULT NULL,
  `description` longtext,
  `created_on` datetime(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `address_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `phone1` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone2`),
  UNIQUE KEY `alternate_phone` (`phone1`),
  KEY `contacts_contact_address_id_0dbb18a0_fk_common_address_id` (`address_id`),
  KEY `contacts_contact_created_by_id_57537352_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `contacts_contact_address_id_0dbb18a0_fk_common_address_id` FOREIGN KEY (`address_id`) REFERENCES `common_address` (`id`),
  CONSTRAINT `contacts_contact_created_by_id_57537352_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts_contact`
--

LOCK TABLES `contacts_contact` WRITE;
/*!40000 ALTER TABLE `contacts_contact` DISABLE KEYS */;
INSERT INTO `contacts_contact` VALUES (1,'vijay','v','v@g.com','+91-946-987-0987','','2020-01-18 06:28:53.825329',0,1,1,NULL),(2,'manju','s','manju@gmail.com','+91-946-987-0997','','2020-01-18 06:35:31.993903',0,2,1,NULL),(3,'priya','m','priya@gmail.com','+91-978-098-4321','','2020-01-18 06:38:12.778769',0,3,1,NULL),(4,'abc','a','a@g.com','+91-946-987-8760','','2020-01-18 06:58:09.905743',0,4,1,NULL),(5,'jhone','j','jhone@gmail.com','09876543245','','2020-01-18 07:21:09.622061',0,5,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts_contact_assigned_to`
--

LOCK TABLES `contacts_contact_assigned_to` WRITE;
/*!40000 ALTER TABLE `contacts_contact_assigned_to` DISABLE KEYS */;
INSERT INTO `contacts_contact_assigned_to` VALUES (1,3,1);
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
-- Table structure for table `contractor`
--

DROP TABLE IF EXISTS `contractor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contractor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contractorname` varchar(100) NOT NULL,
  `contractorid` varchar(100) NOT NULL,
  `companyname` varchar(100) NOT NULL,
  `mailid` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `validity` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  `qrimage` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contractor`
--

LOCK TABLES `contractor` WRITE;
/*!40000 ALTER TABLE `contractor` DISABLE KEYS */;
/*!40000 ALTER TABLE `contractor` ENABLE KEYS */;
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
INSERT INTO `django_content_type` VALUES (14,'accounts','account'),(16,'accounts','email'),(17,'accounts','emaillog'),(15,'accounts','tags'),(2,'auth','group'),(1,'auth','permission'),(18,'cases','case'),(6,'common','address'),(12,'common','apisettings'),(7,'common','attachments'),(8,'common','comment'),(9,'common','comment_files'),(10,'common','document'),(11,'common','google'),(13,'common','profile'),(5,'common','user'),(19,'contacts','contact'),(3,'contenttypes','contenttype'),(20,'emails','email'),(45,'events','event'),(43,'invoices','invoice'),(44,'invoices','invoicehistory'),(21,'leads','lead'),(47,'management','contractor'),(48,'management','entryexit'),(52,'management','sample'),(49,'management','staff'),(51,'management','test'),(50,'management','visitor'),(41,'marketing','blockeddomain'),(40,'marketing','blockedemail'),(26,'marketing','campaign'),(36,'marketing','campaigncompleted'),(27,'marketing','campaignlinkclick'),(28,'marketing','campaignlog'),(29,'marketing','campaignopen'),(30,'marketing','contact'),(38,'marketing','contactemailcampaign'),(31,'marketing','contactlist'),(37,'marketing','contactunsubscribedcampaign'),(39,'marketing','duplicatecontacts'),(32,'marketing','emailtemplate'),(35,'marketing','failedcontact'),(33,'marketing','link'),(34,'marketing','tag'),(22,'opportunity','opportunity'),(23,'planner','event'),(24,'planner','reminder'),(4,'sessions','session'),(42,'tasks','task'),(46,'teams','teams'),(25,'thumbnail','kvstore');
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
) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'accounts','0001_initial','2020-01-18 06:15:14.941918'),(2,'cases','0001_initial','2020-01-18 06:15:15.370459'),(3,'common','0001_initial','2020-01-18 06:15:19.925645'),(4,'teams','0001_initial','2020-01-18 06:15:27.268098'),(5,'teams','0002_auto_20190624_1250','2020-01-18 06:15:30.764898'),(6,'teams','0003_auto_20190909_1621','2020-01-18 06:15:31.827465'),(7,'contacts','0001_initial','2020-01-18 06:15:33.110126'),(8,'contacts','0002_auto_20190212_1334','2020-01-18 06:15:44.820321'),(9,'contacts','0002_auto_20190210_1810','2020-01-18 06:15:44.870577'),(10,'contacts','0003_merge_20190214_1427','2020-01-18 06:15:44.928503'),(11,'leads','0001_initial','2020-01-18 06:15:46.473958'),(12,'accounts','0002_auto_20190128_1237','2020-01-18 06:15:58.118206'),(13,'accounts','0003_auto_20190201_1840','2020-01-18 06:16:07.491943'),(14,'leads','0002_lead_tags','2020-01-18 06:16:10.178433'),(15,'leads','0003_auto_20190211_1142','2020-01-18 06:16:13.914892'),(16,'leads','0004_auto_20190212_1334','2020-01-18 06:16:17.525363'),(17,'accounts','0004_account_status','2020-01-18 06:16:20.865272'),(18,'accounts','0005_auto_20190212_1334','2020-01-18 06:16:24.950121'),(19,'accounts','0006_auto_20190212_1708','2020-01-18 06:16:38.356651'),(20,'accounts','0007_email','2020-01-18 06:16:38.779773'),(21,'accounts','0008_account_assigned_to','2020-01-18 06:16:41.229502'),(22,'accounts','0009_auto_20190809_1659','2020-01-18 06:16:51.014891'),(23,'accounts','0010_account_teams','2020-01-18 06:16:56.450499'),(24,'contenttypes','0001_initial','2020-01-18 06:16:59.978400'),(25,'contenttypes','0002_remove_content_type_name','2020-01-18 06:17:01.575916'),(26,'auth','0001_initial','2020-01-18 06:17:03.431933'),(27,'auth','0002_alter_permission_name_max_length','2020-01-18 06:17:08.413275'),(28,'auth','0003_alter_user_email_max_length','2020-01-18 06:17:08.474101'),(29,'auth','0004_alter_user_username_opts','2020-01-18 06:17:08.543120'),(30,'auth','0005_alter_user_last_login_null','2020-01-18 06:17:08.611239'),(31,'auth','0006_require_contenttypes_0002','2020-01-18 06:17:08.662745'),(32,'auth','0007_alter_validators_add_error_messages','2020-01-18 06:17:08.719136'),(33,'auth','0008_alter_user_username_max_length','2020-01-18 06:17:08.776531'),(34,'auth','0009_alter_user_last_name_max_length','2020-01-18 06:17:08.834709'),(35,'auth','0010_alter_group_name_max_length','2020-01-18 06:17:08.989302'),(36,'auth','0011_update_proxy_permissions','2020-01-18 06:17:09.065841'),(37,'cases','0002_auto_20190128_1237','2020-01-18 06:17:10.936736'),(38,'cases','0003_auto_20190212_1334','2020-01-18 06:17:21.901310'),(39,'cases','0004_case_teams','2020-01-18 06:17:22.455669'),(40,'cases','0005_auto_20200118_1142','2020-01-18 06:17:25.328446'),(41,'events','0001_initial','2020-01-18 06:17:26.464413'),(42,'events','0002_event_date_of_meeting','2020-01-18 06:17:33.757202'),(43,'tasks','0001_initial','2020-01-18 06:17:34.957538'),(44,'tasks','0002_task_created_by','2020-01-18 06:17:41.851437'),(45,'opportunity','0001_initial','2020-01-18 06:17:44.967739'),(46,'common','0002_auto_20190128_1237','2020-01-18 06:18:02.419464'),(47,'planner','0001_initial','2020-01-18 06:18:21.888387'),(48,'planner','0002_auto_20190212_1334','2020-01-18 06:18:44.635858'),(49,'opportunity','0002_opportunity_tags','2020-01-18 06:18:45.174277'),(50,'opportunity','0003_auto_20190212_1334','2020-01-18 06:18:51.231378'),(51,'common','0003_document','2020-01-18 06:18:51.821512'),(52,'common','0004_attachments_case','2020-01-18 06:18:53.977759'),(53,'common','0005_auto_20190204_1400','2020-01-18 06:18:56.466774'),(54,'common','0006_comment_user','2020-01-18 06:18:57.641279'),(55,'common','0007_auto_20190212_1334','2020-01-18 06:19:03.732438'),(56,'common','0008_google','2020-01-18 06:19:04.323337'),(57,'common','0009_document_shared_to','2020-01-18 06:19:06.015758'),(58,'common','0010_apisettings','2020-01-18 06:19:09.671085'),(59,'common','0011_auto_20190218_1230','2020-01-18 06:19:15.310291'),(60,'common','0012_apisettings_website','2020-01-18 06:19:16.106258'),(61,'common','0013_auto_20190508_1540','2020-01-18 06:19:18.290660'),(62,'invoices','0001_initial','2020-01-18 06:19:21.826262'),(63,'invoices','0002_auto_20190524_1113','2020-01-18 06:19:27.287089'),(64,'common','0014_auto_20190524_1113','2020-01-18 06:19:29.561393'),(65,'common','0015_auto_20190604_1830','2020-01-18 06:19:35.532077'),(66,'common','0016_auto_20190624_1816','2020-01-18 06:19:41.585326'),(67,'common','0017_auto_20190722_1443','2020-01-18 06:19:42.251514'),(68,'common','0018_document_teams','2020-01-18 06:19:43.666427'),(69,'contacts','0004_contact_teams','2020-01-18 06:19:46.445107'),(70,'contacts','0005_auto_20200113_0956','2020-01-18 06:19:49.914210'),(71,'contacts','0006_auto_20200113_1724','2020-01-18 06:19:51.077314'),(72,'contacts','0007_auto_20200114_1003','2020-01-18 06:19:52.143516'),(73,'emails','0001_initial','2020-01-18 06:19:52.655917'),(74,'events','0003_event_teams','2020-01-18 06:19:53.316300'),(75,'invoices','0003_auto_20190527_1620','2020-01-18 06:19:57.238103'),(76,'invoices','0004_auto_20190603_1844','2020-01-18 06:19:57.349534'),(77,'invoices','0005_invoicehistory','2020-01-18 06:19:58.347125'),(78,'invoices','0006_invoice_account','2020-01-18 06:20:05.579702'),(79,'invoices','0007_auto_20190909_1621','2020-01-18 06:20:08.100028'),(80,'invoices','0008_invoice_teams','2020-01-18 06:20:09.035035'),(81,'leads','0005_auto_20190212_1708','2020-01-18 06:20:17.143786'),(82,'leads','0006_auto_20190218_1217','2020-01-18 06:20:17.281040'),(83,'leads','0007_auto_20190306_1226','2020-01-18 06:20:17.501267'),(84,'leads','0008_auto_20190315_1503','2020-01-18 06:20:19.714238'),(85,'leads','0009_lead_created_from_site','2020-01-18 06:20:20.545171'),(86,'leads','0010_lead_teams','2020-01-18 06:20:21.046689'),(87,'management','0001_initial','2020-01-18 06:20:25.029060'),(88,'management','0002_test','2020-01-18 06:20:25.600842'),(89,'management','0003_sample','2020-01-18 06:20:26.014546'),(90,'marketing','0001_initial','2020-01-18 06:20:36.570730'),(91,'marketing','0002_auto_20190307_1227','2020-01-18 06:21:08.774260'),(92,'marketing','0003_failedcontact','2020-01-18 06:21:09.959155'),(93,'marketing','0004_auto_20190315_1443','2020-01-18 06:21:13.799876'),(94,'marketing','0005_campaign_timezone','2020-01-18 06:21:14.877928'),(95,'marketing','0006_campaign_attachment','2020-01-18 06:21:15.723677'),(96,'marketing','0007_auto_20190611_1226','2020-01-18 06:21:17.866050'),(97,'marketing','0008_auto_20190612_1905','2020-01-18 06:21:22.076744'),(98,'marketing','0009_auto_20190618_1144','2020-01-18 06:21:26.811947'),(99,'marketing','0010_auto_20190805_1038','2020-01-18 06:21:31.433348'),(100,'marketing','0011_auto_20190904_1143','2020-01-18 06:21:33.092386'),(101,'marketing','0012_auto_20190909_1621','2020-01-18 06:21:34.996127'),(102,'marketing','0013_blockeddomain_blockedemail','2020-01-18 06:21:35.974178'),(103,'opportunity','0004_opportunity_teams','2020-01-18 06:21:38.815689'),(104,'sessions','0001_initial','2020-01-18 06:21:42.095058'),(105,'tasks','0003_task_created_on','2020-01-18 06:21:43.434833'),(106,'tasks','0004_task_teams','2020-01-18 06:21:44.209596'),(107,'thumbnail','0001_initial','2020-01-18 06:21:49.969704'),(108,'contacts','0008_auto_20200118_1156','2020-01-18 06:26:19.411862'),(109,'contacts','0009_contact_alternate_phone','2020-01-18 08:58:18.798915'),(110,'contacts','0010_auto_20200118_1552','2020-01-18 10:22:21.785804'),(111,'cases','0006_auto_20200118_1625','2020-01-18 10:55:27.977418'),(112,'cases','0007_case_name','2020-01-18 11:36:43.969132'),(113,'cases','0008_auto_20200118_1707','2020-01-18 11:37:49.146545'),(114,'common','0019_auto_20200118_1748','2020-01-18 12:56:49.427261');
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
INSERT INTO `django_session` VALUES ('0ahmjt8xzren1oyozc6hyhtvl0rgoveu','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-04 03:58:08.156485'),('0omxwes37lktd9k1fdt17vcnztim346a','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-01 12:58:51.690850'),('1a5bja3t7iyvap0wwtxr2uzkejcyt320','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-03 05:00:36.577432'),('2lup5uztuqxt7qn76el5bh0izcuculdd','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-01 07:03:49.359354'),('68lwfms7a9qxb0qj8ftm87982atwv8kj','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-03 05:01:34.812567'),('6bogrp0y46kkpnqmunj7toij0aaduip2','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-03 05:02:01.191233'),('8bi54rqlgi2xw20rr2bx1rd1fc6ogoq5','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-01 07:38:24.130251'),('bd9yawspkzgfyw8jysdf1fcq4r56dd54','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-06 04:09:22.429190'),('jex5fug3dpqrkpmm21as8yh8jni09ahz','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-03 04:54:52.878012'),('k8n9d5yfajdkswwc0xzk20d2mxlx9cv8','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-03 04:55:09.710354'),('kwxo23je9rmv9fq42uawt7v39gk818n5','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-01 06:27:18.162306'),('l6gjutegtfcu9vj5yuz6609csa0bd8s5','Y2QxMmUxMGMxZTZjYmE5ZTIzN2MzYTQ0ODRjZDY1ZGM3MTg5OTFiNDp7Il9hdXRoX3VzZXJfaWQiOiIyIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJlMTgyZjlmZjAyNDIxZDk4MWM4N2E2YjAzZjQ4YjM3NmFiZjQzMTMwIn0=','2020-02-03 12:29:31.440993'),('nlhevbrrjb5cj1q3d2gjl2hgvee7z1qs','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-03 05:00:11.234326'),('tqa86wrk5godb800pd67aebw0ltyz701','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-01 08:50:36.502378'),('vw6jwyy6svwgqg1kvsz3ffcrsrxdmneb','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-01 07:12:56.528947'),('wb5cn6kje8e9g7phvtdus5c1jat1a5nt','ZTdkNjU0NWY0MjlhYTY5ZTAwNjg2YTBkMjIwNmUxY2UzM2RlNzI4MDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiJjZjA0N2E3YTFkOWI5YjI0MzAwYzMxNjIyN2E2YzBmZmYzOWJmNDE2In0=','2020-02-01 06:29:52.380026');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
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
-- Table structure for table `entryexit`
--

DROP TABLE IF EXISTS `entryexit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `entryexit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `category` varchar(100) NOT NULL,
  `intime` varchar(100) NOT NULL,
  `outtime` varchar(100) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `entryexit`
--

LOCK TABLES `entryexit` WRITE;
/*!40000 ALTER TABLE `entryexit` DISABLE KEYS */;
/*!40000 ALTER TABLE `entryexit` ENABLE KEYS */;
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
  `phone` varchar(128) DEFAULT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads_lead`
--

LOCK TABLES `leads_lead` WRITE;
/*!40000 ALTER TABLE `leads_lead` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `leads_lead_assigned_to`
--

LOCK TABLES `leads_lead_assigned_to` WRITE;
/*!40000 ALTER TABLE `leads_lead_assigned_to` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaign`
--

LOCK TABLES `marketing_campaign` WRITE;
/*!40000 ALTER TABLE `marketing_campaign` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaign_contact_lists`
--

LOCK TABLES `marketing_campaign_contact_lists` WRITE;
/*!40000 ALTER TABLE `marketing_campaign_contact_lists` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_campaignlog`
--

LOCK TABLES `marketing_campaignlog` WRITE;
/*!40000 ALTER TABLE `marketing_campaignlog` DISABLE KEYS */;
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
  `contry` varchar(500) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `updated_on` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `marketing_contact_created_by_id_c5fc4040_fk_common_user_id` (`created_by_id`),
  CONSTRAINT `marketing_contact_created_by_id_c5fc4040_fk_common_user_id` FOREIGN KEY (`created_by_id`) REFERENCES `common_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contact`
--

LOCK TABLES `marketing_contact` WRITE;
/*!40000 ALTER TABLE `marketing_contact` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contact_contact_list`
--

LOCK TABLES `marketing_contact_contact_list` WRITE;
/*!40000 ALTER TABLE `marketing_contact_contact_list` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contactlist`
--

LOCK TABLES `marketing_contactlist` WRITE;
/*!40000 ALTER TABLE `marketing_contactlist` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_contactlist_tags`
--

LOCK TABLES `marketing_contactlist_tags` WRITE;
/*!40000 ALTER TABLE `marketing_contactlist_tags` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_duplicatecontacts`
--

LOCK TABLES `marketing_duplicatecontacts` WRITE;
/*!40000 ALTER TABLE `marketing_duplicatecontacts` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_emailtemplate`
--

LOCK TABLES `marketing_emailtemplate` WRITE;
/*!40000 ALTER TABLE `marketing_emailtemplate` DISABLE KEYS */;
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
  `contry` varchar(500) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marketing_tag`
--

LOCK TABLES `marketing_tag` WRITE;
/*!40000 ALTER TABLE `marketing_tag` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opportunity_opportunity`
--

LOCK TABLES `opportunity_opportunity` WRITE;
/*!40000 ALTER TABLE `opportunity_opportunity` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `opportunity_opportunity_contacts`
--

LOCK TABLES `opportunity_opportunity_contacts` WRITE;
/*!40000 ALTER TABLE `opportunity_opportunity_contacts` DISABLE KEYS */;
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
  KEY `planner_event_content_type_id_e1697281_fk_django_content_type_id` (`content_type_id`),
  KEY `planner_event_created_by_id_ff507edf_fk_common_user_id` (`created_by_id`),
  KEY `planner_event_updated_by_id_1a3b400a_fk_common_user_id` (`updated_by_id`),
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
-- Table structure for table `sample`
--

DROP TABLE IF EXISTS `sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sample` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staffname` varchar(100) DEFAULT NULL,
  `phone` varchar(10) DEFAULT NULL,
  `developer` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sample`
--

LOCK TABLES `sample` WRITE;
/*!40000 ALTER TABLE `sample` DISABLE KEYS */;
/*!40000 ALTER TABLE `sample` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `staffname` varchar(100) NOT NULL,
  `staffid` varchar(100) NOT NULL,
  `desgination` varchar(100) NOT NULL,
  `mailid` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `address` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
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
-- Table structure for table `test`
--

DROP TABLE IF EXISTS `test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `test` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `test` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `test`
--

LOCK TABLES `test` WRITE;
/*!40000 ALTER TABLE `test` DISABLE KEYS */;
/*!40000 ALTER TABLE `test` ENABLE KEYS */;
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
-- Table structure for table `visitor`
--

DROP TABLE IF EXISTS `visitor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `visitor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `visitorname` varchar(100) NOT NULL,
  `mailid` varchar(100) NOT NULL,
  `phone` varchar(100) NOT NULL,
  `purpose` varchar(100) DEFAULT NULL,
  `qrimage` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visitor`
--

LOCK TABLES `visitor` WRITE;
/*!40000 ALTER TABLE `visitor` DISABLE KEYS */;
/*!40000 ALTER TABLE `visitor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-23 10:06:32
