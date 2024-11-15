CREATE DATABASE  IF NOT EXISTS `dev_apautomation_common` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `dev_apautomation_common`;
-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: auroratest.cluster-caridxswhlir.us-east-1.rds.amazonaws.com    Database: dev_apautomation_common
-- ------------------------------------------------------
-- Server version	5.6.10

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `apai_document_model_status`
--

DROP TABLE IF EXISTS `apai_document_model_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apai_document_model_status` (
  `document_model_status_id` int(10) unsigned NOT NULL,
  `document_model_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`document_model_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apai_document_model_status`
--

LOCK TABLES `apai_document_model_status` WRITE;
/*!40000 ALTER TABLE `apai_document_model_status` DISABLE KEYS */;
INSERT INTO `apai_document_model_status` VALUES (10,'Not Mapped'),(20,'Incomplete Mapping'),(30,'Fully Mapped'),(40,'Forced Mapping');
/*!40000 ALTER TABLE `apai_document_model_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apai_invoice_document_status`
--

DROP TABLE IF EXISTS `apai_invoice_document_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apai_invoice_document_status` (
  `invoice_document_status_id` int(10) unsigned NOT NULL,
  `invoice_document_status_name` varchar(64) NOT NULL,
  PRIMARY KEY (`invoice_document_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apai_invoice_document_status`
--

LOCK TABLES `apai_invoice_document_status` WRITE;
/*!40000 ALTER TABLE `apai_invoice_document_status` DISABLE KEYS */;
INSERT INTO `apai_invoice_document_status` VALUES (10,'Unrecognized'),(20,'Routed for Manual Processing'),(30,'Mapping Requested'),(35,'Missing Vendor Assignment'),(40,'Missing Info'),(50,'Verified Successfully'),(60,'Verified with Errors'),(70,'First Level Approved'),(80,'First Level Rejected'),(90,'Second Level Approved'),(100,'Second Level Rejected'),(110,'Third Level Approved'),(120,'Third Level Rejected'),(130,'Posted');
/*!40000 ALTER TABLE `apai_invoice_document_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apai_model_def`
--

DROP TABLE IF EXISTS `apai_model_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apai_model_def` (
  `model_def_id` int(10) unsigned NOT NULL,
  `master_def_name` varchar(64) NOT NULL,
  PRIMARY KEY (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apai_model_def`
--

LOCK TABLES `apai_model_def` WRITE;
/*!40000 ALTER TABLE `apai_model_def` DISABLE KEYS */;
INSERT INTO `apai_model_def` VALUES (1,'AP Invoice');
/*!40000 ALTER TABLE `apai_model_def` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apai_model_def_field_alignment_type`
--

DROP TABLE IF EXISTS `apai_model_def_field_alignment_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apai_model_def_field_alignment_type` (
  `model_def_field_alignment_type_id` int(10) unsigned NOT NULL,
  `model_def_field_alignment_type_name` varchar(64) NOT NULL,
  PRIMARY KEY (`model_def_field_alignment_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apai_model_def_field_alignment_type`
--

LOCK TABLES `apai_model_def_field_alignment_type` WRITE;
/*!40000 ALTER TABLE `apai_model_def_field_alignment_type` DISABLE KEYS */;
INSERT INTO `apai_model_def_field_alignment_type` VALUES (10,'Left'),(20,'Center'),(30,'Right');
/*!40000 ALTER TABLE `apai_model_def_field_alignment_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apai_model_def_field_parse_type`
--

DROP TABLE IF EXISTS `apai_model_def_field_parse_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apai_model_def_field_parse_type` (
  `model_def_field_parse_type_id` int(10) unsigned NOT NULL,
  `model_def_field_parse_type_name` varchar(64) NOT NULL,
  PRIMARY KEY (`model_def_field_parse_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apai_model_def_field_parse_type`
--

LOCK TABLES `apai_model_def_field_parse_type` WRITE;
/*!40000 ALTER TABLE `apai_model_def_field_parse_type` DISABLE KEYS */;
INSERT INTO `apai_model_def_field_parse_type` VALUES (10,'Lines'),(20,'Words'),(30,'Tables'),(40,'NVPairs');
/*!40000 ALTER TABLE `apai_model_def_field_parse_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apai_model_def_field_source`
--

DROP TABLE IF EXISTS `apai_model_def_field_source`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apai_model_def_field_source` (
  `model_def_field_source_id` int(10) unsigned NOT NULL,
  `model_def_field_source_name` varchar(64) NOT NULL,
  PRIMARY KEY (`model_def_field_source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apai_model_def_field_source`
--

LOCK TABLES `apai_model_def_field_source` WRITE;
/*!40000 ALTER TABLE `apai_model_def_field_source` DISABLE KEYS */;
INSERT INTO `apai_model_def_field_source` VALUES (10,'Label'),(20,'Value'),(30,'Label-Table-Header'),(40,'Value-Table-Header'),(50,'Label-Table-Detail'),(60,'Value-Table-Detail'),(70,'Label-Table-Footer'),(80,'Value-Table-Footer'),(90,'Key-Value-Pair (Single)'),(100,'Key-Value-Pair (Multi)');
/*!40000 ALTER TABLE `apai_model_def_field_source` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apai_model_def_field_type`
--

DROP TABLE IF EXISTS `apai_model_def_field_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apai_model_def_field_type` (
  `model_def_field_type_id` int(10) unsigned NOT NULL,
  `model_def_field_type_name` varchar(64) NOT NULL,
  PRIMARY KEY (`model_def_field_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apai_model_def_field_type`
--

LOCK TABLES `apai_model_def_field_type` WRITE;
/*!40000 ALTER TABLE `apai_model_def_field_type` DISABLE KEYS */;
INSERT INTO `apai_model_def_field_type` VALUES (10,'Classifier'),(20,'Text'),(30,'Date'),(40,'Date Range'),(50,'Lookup'),(60,'Number');
/*!40000 ALTER TABLE `apai_model_def_field_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apai_model_field_def`
--

DROP TABLE IF EXISTS `apai_model_field_def`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apai_model_field_def` (
  `model_def_id` int(10) unsigned NOT NULL,
  `model_def_field_id` int(10) unsigned NOT NULL,
  `model_def_field_name` varchar(64) NOT NULL,
  `model_def_screen_label_name` varchar(64) NOT NULL,
  `model_def_field_order` int(10) unsigned NOT NULL,
  `model_def_field_required` char(1) NOT NULL,
  `model_def_field_type_id` int(10) unsigned NOT NULL,
  `target_db_table_name` varchar(128) DEFAULT NULL,
  `target_db_field_name` varchar(128) DEFAULT NULL,
  `lookup_sql_view_name` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`model_def_id`,`model_def_field_id`),
  KEY `FK_apai_model_field_def__apai_model_def_field_type` (`model_def_field_type_id`),
  CONSTRAINT `FK_apai_model_field_def__apai_model_def` FOREIGN KEY (`model_def_id`) REFERENCES `apai_model_def` (`model_def_id`),
  CONSTRAINT `FK_apai_model_field_def__apai_model_def_field_type` FOREIGN KEY (`model_def_field_type_id`) REFERENCES `apai_model_def_field_type` (`model_def_field_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apai_model_field_def`
--

LOCK TABLES `apai_model_field_def` WRITE;
/*!40000 ALTER TABLE `apai_model_field_def` DISABLE KEYS */;
INSERT INTO `apai_model_field_def` VALUES (1,1,'Vendor Classifier','Vendor Classifier',10,'Y',10,NULL,NULL,NULL),(1,2,'Vendor Invoice Number','Vendor Invoice Number',20,'Y',20,'apad_invoice_document','invoice_number',NULL),(1,3,'Vendor Invoice Date','Vendor Invoice Date',30,'Y',30,'apad_invoice_document','invoice_date',NULL),(1,4,'Due Date','Due Date',40,'Y',30,'apad_invoice_document','due_date',NULL),(1,5,'Service Term','Service Term (Start/End Dates)',50,'Y',40,'apad_invoice_document','service_term_start_date~service_term_end_date',NULL),(1,6,'Payment Term','Payment Term',60,'Y',50,'apad_invoice_document','payment_term_code','v_lookup_apam_payment_terms'),(1,7,'Currency','Currency',70,'Y',50,'apad_invoice_document','currency_code','v_lookup_apam_currencies'),(1,8,'IO Number','IO/PO Number',80,'Y',20,'apad_invoice_document_detail','io_number',NULL),(1,9,'IO Description','IO/PO Description',90,'Y',20,'apad_invoice_document_detail','io_description',NULL),(1,10,'IO Net Amount','IO/PO Net Amount',100,'Y',60,'apad_invoice_document_detail','io_invoice_amount',NULL);
/*!40000 ALTER TABLE `apai_model_field_def` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_master_document_model`
--

DROP TABLE IF EXISTS `apam_master_document_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_master_document_model` (
  `master_document_model_id` int(10) unsigned NOT NULL,
  `document_model_name` varchar(64) NOT NULL,
  `document_model_name_tag` varchar(32) DEFAULT NULL,
  `model_def_id` int(10) unsigned NOT NULL,
  `master_document_model_comments` varchar(512) DEFAULT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`master_document_model_id`),
  UNIQUE KEY `apam_master_document_model_I1` (`document_model_name`,`document_model_name_tag`),
  KEY `FK_apam_master_document_model__apai_model_def` (`model_def_id`),
  CONSTRAINT `FK_apam_master_document_model__apai_model_def` FOREIGN KEY (`model_def_id`) REFERENCES `apai_model_def` (`model_def_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_master_document_model`
--

LOCK TABLES `apam_master_document_model` WRITE;
/*!40000 ALTER TABLE `apam_master_document_model` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_master_document_model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_master_document_model_field`
--

DROP TABLE IF EXISTS `apam_master_document_model_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_master_document_model_field` (
  `master_document_model_id` int(10) unsigned NOT NULL,
  `master_document_model_field_id` int(10) unsigned NOT NULL,
  `model_def_id` int(10) unsigned NOT NULL,
  `model_def_field_id` int(10) unsigned NOT NULL,
  `model_def_field_parse_type_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`master_document_model_id`,`master_document_model_field_id`),
  KEY `FK_apam_model_field__apai_model_def_field_parse_type` (`model_def_field_parse_type_id`),
  CONSTRAINT `FK_apam_model_field__apai_model_def_field_parse_type` FOREIGN KEY (`model_def_field_parse_type_id`) REFERENCES `apai_model_def_field_parse_type` (`model_def_field_parse_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_master_document_model_field`
--

LOCK TABLES `apam_master_document_model_field` WRITE;
/*!40000 ALTER TABLE `apam_master_document_model_field` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_master_document_model_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_master_document_model_field_detail`
--

DROP TABLE IF EXISTS `apam_master_document_model_field_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_master_document_model_field_detail` (
  `master_document_model_id` int(10) unsigned NOT NULL,
  `master_document_model_field_id` int(10) unsigned NOT NULL,
  `master_document_model_field_seq_id` int(10) unsigned NOT NULL,
  `model_def_field_source_id` int(10) unsigned NOT NULL,
  `model_def_field_alignment_type_id` int(10) unsigned NOT NULL,
  `field_format` varchar(128) DEFAULT NULL,
  `vendor_classifier_text` varchar(128) DEFAULT NULL,
  `page_number` int(10) unsigned DEFAULT NULL,
  `table_number` int(10) unsigned DEFAULT NULL,
  `table_row_index` int(10) unsigned DEFAULT NULL,
  `table_col_index` int(10) unsigned DEFAULT NULL,
  `boundingbox_left` decimal(24,20) DEFAULT NULL,
  `boundingbox_top` decimal(24,20) DEFAULT NULL,
  `boundingbox_width` decimal(24,20) DEFAULT NULL,
  `boundingbox_height` decimal(24,20) DEFAULT NULL,
  PRIMARY KEY (`master_document_model_id`,`master_document_model_field_id`,`master_document_model_field_seq_id`),
  KEY `FK_apam_master_document_model_field_detail_1` (`master_document_model_id`,`master_document_model_field_id`),
  KEY `FK_apam_master_document_model_field_detail_2` (`model_def_field_source_id`),
  KEY `FK_apam_master_document_model_field_detail_3` (`model_def_field_alignment_type_id`),
  CONSTRAINT `FK_apam_master_document_model_field_detail_1` FOREIGN KEY (`master_document_model_id`, `master_document_model_field_id`) REFERENCES `apam_master_document_model_field` (`master_document_model_id`, `master_document_model_field_id`),
  CONSTRAINT `FK_apam_master_document_model_field_detail_2` FOREIGN KEY (`model_def_field_source_id`) REFERENCES `apai_model_def_field_source` (`model_def_field_source_id`),
  CONSTRAINT `FK_apam_master_document_model_field_detail_3` FOREIGN KEY (`model_def_field_alignment_type_id`) REFERENCES `apai_model_def_field_alignment_type` (`model_def_field_alignment_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_master_document_model_field_detail`
--

LOCK TABLES `apam_master_document_model_field_detail` WRITE;
/*!40000 ALTER TABLE `apam_master_document_model_field_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_master_document_model_field_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'dev_apautomation_common'
--

--
-- Dumping routines for database 'dev_apautomation_common'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-23 11:30:05
CREATE DATABASE  IF NOT EXISTS `dev_apautomation_360i` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `dev_apautomation_360i`;
-- MySQL dump 10.13  Distrib 8.0.17, for Win64 (x86_64)
--
-- Host: auroratest.cluster-caridxswhlir.us-east-1.rds.amazonaws.com    Database: dev_apautomation_360i
-- ------------------------------------------------------
-- Server version	5.6.10

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `apad_invoice_document`
--

DROP TABLE IF EXISTS `apad_invoice_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apad_invoice_document` (
  `company_code` int(11) NOT NULL,
  `invoice_document_id` int(10) unsigned NOT NULL,
  `invoice_document_file_location` varchar(1024) NOT NULL,
  `invoice_document_status_id` int(10) unsigned NOT NULL,
  `invoice_document_status_attribute` char(1) DEFAULT NULL,
  `master_document_model_id` int(10) unsigned DEFAULT NULL,
  `invoice_number` varchar(32) DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `service_term_start_date` date DEFAULT NULL,
  `service_term_end_date` date DEFAULT NULL,
  `payment_term_code` varchar(32) DEFAULT NULL,
  `currency_code` varchar(32) DEFAULT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`invoice_document_id`),
  KEY `FK_apad_invoice_document_1` (`invoice_document_status_id`),
  KEY `FK_apad_invoice_document_2` (`master_document_model_id`),
  CONSTRAINT `FK_apad_invoice_document_1` FOREIGN KEY (`invoice_document_status_id`) REFERENCES `apautomation_common`.`apai_invoice_document_status` (`invoice_document_status_id`),
  CONSTRAINT `FK_apad_invoice_document_2` FOREIGN KEY (`master_document_model_id`) REFERENCES `apautomation_common`.`apam_master_document_model` (`master_document_model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apad_invoice_document`
--

LOCK TABLES `apad_invoice_document` WRITE;
/*!40000 ALTER TABLE `apad_invoice_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `apad_invoice_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apad_invoice_document_detail`
--

DROP TABLE IF EXISTS `apad_invoice_document_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apad_invoice_document_detail` (
  `company_code` int(11) NOT NULL,
  `invoice_document_id` int(10) unsigned NOT NULL,
  `seq_id` int(10) unsigned NOT NULL,
  `io_number` varchar(64) DEFAULT NULL,
  `io_description` varchar(128) DEFAULT NULL,
  `io_invoice_amount` double DEFAULT NULL,
  PRIMARY KEY (`company_code`,`invoice_document_id`,`seq_id`),
  CONSTRAINT `FK_apad_invoice_document_detail_1` FOREIGN KEY (`company_code`, `invoice_document_id`) REFERENCES `apad_invoice_document` (`company_code`, `invoice_document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apad_invoice_document_detail`
--

LOCK TABLES `apad_invoice_document_detail` WRITE;
/*!40000 ALTER TABLE `apad_invoice_document_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `apad_invoice_document_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apad_po_resources`
--

DROP TABLE IF EXISTS `apad_po_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apad_po_resources` (
  `company_code` int(11) NOT NULL,
  `po_code` varchar(32) NOT NULL,
  `resource_id` char(16) NOT NULL,
  `position_category_code` int(11) NOT NULL,
  PRIMARY KEY (`company_code`,`po_code`,`resource_id`),
  KEY `FK_apad_po_resources_2` (`company_code`,`resource_id`),
  KEY `FK_apad_po_resources_1` (`company_code`,`position_category_code`),
  CONSTRAINT `FK_apad_po_resources_1` FOREIGN KEY (`company_code`, `position_category_code`) REFERENCES `apam_position_category` (`company_code`, `position_category_code`),
  CONSTRAINT `FK_apad_po_resources_2` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported as join query from pdd_po_dtl, pdd_level3_resource';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apad_po_resources`
--

LOCK TABLES `apad_po_resources` WRITE;
/*!40000 ALTER TABLE `apad_po_resources` DISABLE KEYS */;
/*!40000 ALTER TABLE `apad_po_resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apad_resources`
--

DROP TABLE IF EXISTS `apad_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apad_resources` (
  `company_code` int(11) NOT NULL,
  `resource_id` char(16) NOT NULL,
  `name_last` varchar(32) NOT NULL,
  `name_first` varchar(32) NOT NULL,
  `name_init` varchar(1) DEFAULT NULL,
  `title` varchar(64) DEFAULT NULL,
  `login_id` varchar(64) DEFAULT NULL,
  `res_password` varchar(256) DEFAULT NULL,
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdd_resources';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apad_resources`
--

LOCK TABLES `apad_resources` WRITE;
/*!40000 ALTER TABLE `apad_resources` DISABLE KEYS */;
/*!40000 ALTER TABLE `apad_resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apad_user_role_position_categories`
--

DROP TABLE IF EXISTS `apad_user_role_position_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apad_user_role_position_categories` (
  `company_code` int(11) NOT NULL,
  `user_role_id` int(11) NOT NULL,
  `position_category_code` int(11) NOT NULL DEFAULT '0',
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`,`position_category_code`),
  KEY `FK_apad_user_role_position_categories_1` (`company_code`,`position_category_code`),
  CONSTRAINT `FK_apad_user_role_position_categories_1` FOREIGN KEY (`company_code`, `position_category_code`) REFERENCES `apam_position_category` (`company_code`, `position_category_code`),
  CONSTRAINT `FK_apad_user_role_position_categories_2` FOREIGN KEY (`company_code`, `user_role_id`) REFERENCES `apad_user_roles` (`company_code`, `user_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apad_user_role_position_categories`
--

LOCK TABLES `apad_user_role_position_categories` WRITE;
/*!40000 ALTER TABLE `apad_user_role_position_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `apad_user_role_position_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apad_user_roles`
--

DROP TABLE IF EXISTS `apad_user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apad_user_roles` (
  `company_code` int(11) NOT NULL,
  `user_role_id` int(11) NOT NULL,
  `user_role_name` varchar(64) DEFAULT NULL,
  `allow_non_mapped_invoices_request_processing` char(1) NOT NULL,
  `allow_invoice_model_mapping` char(1) NOT NULL,
  `allow_invoice_manual_processing` char(1) NOT NULL,
  `allow_invoice_correction` char(1) NOT NULL,
  `allow_routing_setup` char(1) NOT NULL,
  `allow_invoice_level_1_approval` char(1) NOT NULL,
  `allow_invoice_level_2_approval` char(1) DEFAULT NULL,
  `allow_invoice_level_3_approval` char(1) DEFAULT NULL,
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apad_user_roles`
--

LOCK TABLES `apad_user_roles` WRITE;
/*!40000 ALTER TABLE `apad_user_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `apad_user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apad_user_roles_resource`
--

DROP TABLE IF EXISTS `apad_user_roles_resource`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apad_user_roles_resource` (
  `company_code` int(11) NOT NULL,
  `user_role_id` int(11) NOT NULL,
  `resource_id` char(16) NOT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`user_role_id`,`resource_id`),
  KEY `FK_apad_resource_groups_resource_2` (`company_code`,`resource_id`),
  CONSTRAINT `FK_apad_user_roles_resource_1` FOREIGN KEY (`company_code`, `user_role_id`) REFERENCES `apad_user_roles` (`company_code`, `user_role_id`),
  CONSTRAINT `FK_apad_user_roles_resource_2` FOREIGN KEY (`company_code`, `resource_id`) REFERENCES `apad_resources` (`company_code`, `resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apad_user_roles_resource`
--

LOCK TABLES `apad_user_roles_resource` WRITE;
/*!40000 ALTER TABLE `apad_user_roles_resource` DISABLE KEYS */;
/*!40000 ALTER TABLE `apad_user_roles_resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_company`
--

DROP TABLE IF EXISTS `apam_company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_company` (
  `company_code` int(11) NOT NULL,
  `co_short_name` varchar(16) NOT NULL,
  `co_name` varchar(64) NOT NULL,
  `currency_code` char(8) NOT NULL,
  `addr_street1` varchar(64) DEFAULT NULL,
  `addr_street2` varchar(64) DEFAULT NULL,
  `addr_street3` varchar(64) DEFAULT NULL,
  `addr_city` varchar(64) DEFAULT NULL,
  `addr_state_province` varchar(16) DEFAULT NULL,
  `addr_zip_postcode` varchar(16) DEFAULT NULL,
  `tel_area` varchar(64) DEFAULT NULL,
  `tel_number` varchar(64) DEFAULT NULL,
  `nexelus_s3_storage_connection_string` varchar(512) DEFAULT NULL,
  `s3_storage_invoices_scan_folder` varchar(1024) DEFAULT NULL,
  `s3_storage_invoices_archive_root_folder` varchar(1024) DEFAULT NULL,
  `invoice_collection_email` varchar(128) DEFAULT NULL,
  `nexelus_owned_storage_flag` char(1) NOT NULL,
  `client_owned_storage_flag` char(1) NOT NULL,
  `client_ftp_site_connection_string` varchar(1024) NOT NULL,
  `routing_number_of_approval_levels` int(11) DEFAULT NULL,
  `approval_level_1_short_name` varchar(64) NOT NULL,
  `approval_level_1_name` varchar(64) NOT NULL,
  `approval_level_1_status_name` varchar(64) NOT NULL,
  `approval_level_1_accept_name` varchar(64) NOT NULL,
  `approval_level_1_reject_name` varchar(64) NOT NULL,
  `approval_level_1_allow_invoice_editing_flag` char(1) NOT NULL,
  `approval_level_2_short_name` varchar(64) DEFAULT NULL,
  `approval_level_2_name` varchar(64) DEFAULT NULL,
  `approval_level_2_status_name` varchar(64) DEFAULT NULL,
  `approval_level_2_accept_name` varchar(64) DEFAULT NULL,
  `approval_level_2_reject_name` varchar(64) DEFAULT NULL,
  `approval_level_2_allow_invoice_editing_flag` char(1) DEFAULT NULL,
  `approval_level_3_short_name` varchar(64) DEFAULT NULL,
  `approval_level_3_name` varchar(64) DEFAULT NULL,
  `approval_level_3_status_name` varchar(64) DEFAULT NULL,
  `approval_level_3_accept_name` varchar(64) DEFAULT NULL,
  `approval_level_3_reject_name` varchar(64) DEFAULT NULL,
  `approval_level_3_allow_invoice_editing_flag` char(1) DEFAULT NULL,
  `create_id` varchar(32) DEFAULT NULL,
  `create_date` datetime DEFAULT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_company`
--

LOCK TABLES `apam_company` WRITE;
/*!40000 ALTER TABLE `apam_company` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_currencies`
--

DROP TABLE IF EXISTS `apam_currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_currencies` (
  `currency_code` char(8) NOT NULL,
  `currency_name` varchar(16) NOT NULL,
  PRIMARY KEY (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdm_currencies';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_currencies`
--

LOCK TABLES `apam_currencies` WRITE;
/*!40000 ALTER TABLE `apam_currencies` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_currencies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_currencies_map`
--

DROP TABLE IF EXISTS `apam_currencies_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_currencies_map` (
  `apam_invoice_currency_code` char(64) NOT NULL,
  `currency_code` char(8) NOT NULL,
  PRIMARY KEY (`apam_invoice_currency_code`),
  KEY `FK_apam_currencies_map_1` (`currency_code`),
  CONSTRAINT `FK_apam_currencies_map_1` FOREIGN KEY (`currency_code`) REFERENCES `apam_currencies` (`currency_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_currencies_map`
--

LOCK TABLES `apam_currencies_map` WRITE;
/*!40000 ALTER TABLE `apam_currencies_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_currencies_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_document_model`
--

DROP TABLE IF EXISTS `apam_document_model`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_document_model` (
  `company_code` int(11) NOT NULL,
  `master_document_model_id` int(10) unsigned NOT NULL,
  `vendor_code` varchar(12) DEFAULT NULL,
  `site_id` varchar(32) DEFAULT NULL,
  `invoice_document_sample_file_location` varchar(1024) NOT NULL,
  `document_model_status_id` int(10) unsigned NOT NULL,
  `document_model_is_active` char(1) NOT NULL,
  `document_model_comments` varchar(512) DEFAULT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`master_document_model_id`),
  KEY `FK_apam_document_model_1` (`master_document_model_id`),
  KEY `FK_apam_document_model_2` (`document_model_status_id`),
  CONSTRAINT `FK_apam_document_model_1` FOREIGN KEY (`master_document_model_id`) REFERENCES `apautomation_common`.`apam_master_document_model` (`master_document_model_id`),
  CONSTRAINT `FK_apam_document_model_2` FOREIGN KEY (`document_model_status_id`) REFERENCES `apautomation_common`.`apai_document_model_status` (`document_model_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_document_model`
--

LOCK TABLES `apam_document_model` WRITE;
/*!40000 ALTER TABLE `apam_document_model` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_document_model` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_document_model_field`
--

DROP TABLE IF EXISTS `apam_document_model_field`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_document_model_field` (
  `company_code` int(11) NOT NULL,
  `master_document_model_id` int(10) unsigned NOT NULL,
  `master_document_model_field_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`company_code`,`master_document_model_id`,`master_document_model_field_id`),
  CONSTRAINT `FK_apam_document_model_field_1` FOREIGN KEY (`company_code`, `master_document_model_id`) REFERENCES `apam_document_model` (`company_code`, `master_document_model_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_document_model_field`
--

LOCK TABLES `apam_document_model_field` WRITE;
/*!40000 ALTER TABLE `apam_document_model_field` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_document_model_field` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_document_model_field_detail`
--

DROP TABLE IF EXISTS `apam_document_model_field_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_document_model_field_detail` (
  `company_code` int(11) NOT NULL,
  `master_document_model_id` int(10) unsigned NOT NULL,
  `master_document_model_field_id` int(10) unsigned NOT NULL,
  `master_document_model_field_seq_id` int(10) unsigned NOT NULL,
  `field_sample_value` varchar(128) NOT NULL,
  PRIMARY KEY (`company_code`,`master_document_model_id`,`master_document_model_field_id`,`master_document_model_field_seq_id`),
  CONSTRAINT `FK_apam_document_model_field_detail_1` FOREIGN KEY (`company_code`, `master_document_model_id`, `master_document_model_field_id`) REFERENCES `apam_document_model_field` (`company_code`, `master_document_model_id`, `master_document_model_field_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_document_model_field_detail`
--

LOCK TABLES `apam_document_model_field_detail` WRITE;
/*!40000 ALTER TABLE `apam_document_model_field_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_document_model_field_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_document_model_request`
--

DROP TABLE IF EXISTS `apam_document_model_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_document_model_request` (
  `company_code` int(11) NOT NULL,
  `document_model_request_id` int(10) unsigned NOT NULL,
  `invoice_document_file_location` varchar(1024) NOT NULL,
  `request_to_map` char(1) NOT NULL,
  `manual_processing` char(1) NOT NULL,
  `request_completed` char(1) NOT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`company_code`,`document_model_request_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_document_model_request`
--

LOCK TABLES `apam_document_model_request` WRITE;
/*!40000 ALTER TABLE `apam_document_model_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_document_model_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_payment_terms`
--

DROP TABLE IF EXISTS `apam_payment_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_payment_terms` (
  `terms_code` varchar(64) NOT NULL,
  `terms_desc` varchar(64) NOT NULL,
  `days_due` int(11) NOT NULL,
  PRIMARY KEY (`terms_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdv_terms';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_payment_terms`
--

LOCK TABLES `apam_payment_terms` WRITE;
/*!40000 ALTER TABLE `apam_payment_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_payment_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_payment_terms_map`
--

DROP TABLE IF EXISTS `apam_payment_terms_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_payment_terms_map` (
  `apam_invoice_terms_code` varchar(64) NOT NULL,
  `terms_code` varchar(64) NOT NULL,
  PRIMARY KEY (`apam_invoice_terms_code`),
  KEY `FK_apam_payment_terms_map_1` (`terms_code`),
  CONSTRAINT `FK_apam_payment_terms_map_1` FOREIGN KEY (`terms_code`) REFERENCES `apam_payment_terms` (`terms_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_payment_terms_map`
--

LOCK TABLES `apam_payment_terms_map` WRITE;
/*!40000 ALTER TABLE `apam_payment_terms_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_payment_terms_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_position_category`
--

DROP TABLE IF EXISTS `apam_position_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_position_category` (
  `company_code` int(11) NOT NULL,
  `position_category_code` int(11) NOT NULL,
  `position_category_name` varchar(64) NOT NULL,
  PRIMARY KEY (`company_code`,`position_category_code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='imported from pdm_position_category';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_position_category`
--

LOCK TABLES `apam_position_category` WRITE;
/*!40000 ALTER TABLE `apam_position_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_position_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apam_registration_record`
--

DROP TABLE IF EXISTS `apam_registration_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `apam_registration_record` (
  `registration_record_id` int(11) NOT NULL,
  `registration_business_name` varchar(128) NOT NULL,
  `registration_business_addr1` varchar(128) DEFAULT NULL,
  `registration_business_addr2` varchar(128) DEFAULT NULL,
  `registration_business_city` varchar(128) DEFAULT NULL,
  `registration_business_state` varchar(32) DEFAULT NULL,
  `registration_business_zip` varchar(128) DEFAULT NULL,
  `registration_business_phone` varchar(128) DEFAULT NULL,
  `registration_business_email` varchar(128) DEFAULT NULL,
  `admin_login` varchar(128) NOT NULL,
  `admin_password` varchar(128) DEFAULT NULL,
  `is_trial_flag` char(1) NOT NULL,
  `trial_expiration_date` date DEFAULT NULL,
  `license_key` varchar(256) DEFAULT NULL,
  `create_id` varchar(32) NOT NULL,
  `create_date` datetime NOT NULL,
  `modify_id` varchar(32) DEFAULT NULL,
  `modify_date` datetime DEFAULT NULL,
  PRIMARY KEY (`registration_record_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apam_registration_record`
--

LOCK TABLES `apam_registration_record` WRITE;
/*!40000 ALTER TABLE `apam_registration_record` DISABLE KEYS */;
/*!40000 ALTER TABLE `apam_registration_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_lookup_apam_currencies`
--

DROP TABLE IF EXISTS `v_lookup_apam_currencies`;
/*!50001 DROP VIEW IF EXISTS `v_lookup_apam_currencies`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_lookup_apam_currencies` AS SELECT 
 1 AS `apa_code`,
 1 AS `erp_code`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_lookup_apam_payment_terms`
--

DROP TABLE IF EXISTS `v_lookup_apam_payment_terms`;
/*!50001 DROP VIEW IF EXISTS `v_lookup_apam_payment_terms`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_lookup_apam_payment_terms` AS SELECT 
 1 AS `apa_code`,
 1 AS `erp_code`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping events for database 'dev_apautomation_360i'
--

--
-- Dumping routines for database 'dev_apautomation_360i'
--

--
-- Final view structure for view `v_lookup_apam_currencies`
--

/*!50001 DROP VIEW IF EXISTS `v_lookup_apam_currencies`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`administrator`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_lookup_apam_currencies` AS select `apam_currencies_map`.`apam_invoice_currency_code` AS `apa_code`,`apam_currencies_map`.`currency_code` AS `erp_code` from `apam_currencies_map` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_lookup_apam_payment_terms`
--

/*!50001 DROP VIEW IF EXISTS `v_lookup_apam_payment_terms`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`administrator`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `v_lookup_apam_payment_terms` AS select `apam_payment_terms_map`.`apam_invoice_terms_code` AS `apa_code`,`apam_payment_terms_map`.`terms_code` AS `erp_code` from `apam_payment_terms_map` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-01-23 11:30:10
