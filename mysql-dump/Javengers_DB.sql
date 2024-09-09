DROP DATABASE IF EXISTS `Javengers_DB`;
CREATE DATABASE  IF NOT EXISTS `Javengers_DB` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `Javengers_DB`;
-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: Javengers_DB
-- ------------------------------------------------------
-- Server version	8.0.39-0ubuntu0.24.04.2

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
-- Table structure for table `BLOCKED_USERS`
--

DROP TABLE IF EXISTS `BLOCKED_USERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `BLOCKED_USERS` (
                                 `id` int NOT NULL AUTO_INCREMENT,
                                 `BlockedUser` int NOT NULL,
                                 `BlockerUser` int NOT NULL,
                                 PRIMARY KEY (`id`),
                                 KEY `blocked_user_idx` (`BlockedUser`),
                                 KEY `blocker_user_idx` (`BlockerUser`),
                                 CONSTRAINT `blocked_user` FOREIGN KEY (`BlockedUser`) REFERENCES `USER` (`id`),
                                 CONSTRAINT `blocker_user` FOREIGN KEY (`BlockerUser`) REFERENCES `USER` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `BLOCKED_USERS`
--

LOCK TABLES `BLOCKED_USERS` WRITE;
/*!40000 ALTER TABLE `BLOCKED_USERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `BLOCKED_USERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FOLLOWERS`
--

DROP TABLE IF EXISTS `FOLLOWERS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FOLLOWERS` (
                             `id` int NOT NULL AUTO_INCREMENT,
                             `Followed` int NOT NULL,
                             `Follower` int NOT NULL,
                             PRIMARY KEY (`id`),
                             KEY `fk_FOLLOWERS_1_idx` (`Followed`),
                             KEY `fk_FOLLOWERS_2_idx` (`Follower`),
                             CONSTRAINT `fk_FOLLOWERS_1` FOREIGN KEY (`Followed`) REFERENCES `USER` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
                             CONSTRAINT `fk_FOLLOWERS_2` FOREIGN KEY (`Follower`) REFERENCES `USER` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FOLLOWERS`
--

LOCK TABLES `FOLLOWERS` WRITE;
/*!40000 ALTER TABLE `FOLLOWERS` DISABLE KEYS */;
INSERT INTO `FOLLOWERS` VALUES (4,2,6),(5,1,2),(6,4,2),(8,2,4),(13,2,3),(14,6,2),(15,3,2),(16,3,5);
/*!40000 ALTER TABLE `FOLLOWERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NOTIFICATIONS`
--

DROP TABLE IF EXISTS `NOTIFICATIONS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NOTIFICATIONS` (
                                 `id` int NOT NULL AUTO_INCREMENT,
                                 `UserSRC` int NOT NULL,
                                 `UserDST` int NOT NULL,
                                 `NotificationMessage` varchar(200) DEFAULT NULL,
                                 `NotificationDate` date NOT NULL,
                                 `NotificationTime` time NOT NULL,
                                 `NotificationType` int NOT NULL,
                                 `Viewed` tinyint NOT NULL,
                                 PRIMARY KEY (`id`),
                                 KEY `fk_NOTIFICATIONS_1_idx` (`UserSRC`,`UserDST`),
                                 KEY `fk_NOTIFICATIONS_2_idx` (`UserDST`),
                                 CONSTRAINT `fk_NOTIFICATIONS_1` FOREIGN KEY (`UserSRC`) REFERENCES `USER` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
                                 CONSTRAINT `fk_NOTIFICATIONS_2` FOREIGN KEY (`UserDST`) REFERENCES `USER` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NOTIFICATIONS`
--

LOCK TABLES `NOTIFICATIONS` WRITE;
/*!40000 ALTER TABLE `NOTIFICATIONS` DISABLE KEYS */;
INSERT INTO `NOTIFICATIONS` VALUES (46,2,3,'@<b>marcobianchi00</b> ha cominciato a seguirti','2024-09-08','10:58:15',1,0),(47,5,3,'@<b>chiara0214</b> ha cominciato a seguirti','2024-09-08','11:01:00',1,0);
/*!40000 ALTER TABLE `NOTIFICATIONS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PREFERENCES`
--

DROP TABLE IF EXISTS `PREFERENCES`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PREFERENCES` (
                               `id` int NOT NULL,
                               `messages` tinyint NOT NULL DEFAULT '1',
                               `followers` tinyint NOT NULL DEFAULT '1',
                               `events` tinyint NOT NULL DEFAULT '1',
                               `payments` tinyint NOT NULL DEFAULT '1',
                               PRIMARY KEY (`id`),
                               CONSTRAINT `userId` FOREIGN KEY (`id`) REFERENCES `USER` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PREFERENCES`
--

LOCK TABLES `PREFERENCES` WRITE;
/*!40000 ALTER TABLE `PREFERENCES` DISABLE KEYS */;
INSERT INTO `PREFERENCES` VALUES (1,1,1,1,1),(2,1,1,1,1),(3,1,0,1,1),(4,1,1,1,1),(5,1,1,1,1),(6,1,1,1,1);
/*!40000 ALTER TABLE `PREFERENCES` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER`
--

DROP TABLE IF EXISTS `USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER` (
                        `id` int NOT NULL AUTO_INCREMENT,
                        `Username` varchar(45) NOT NULL,
                        PRIMARY KEY (`id`),
                        UNIQUE KEY `id_UNIQUE` (`id`),
                        UNIQUE KEY `Username_UNIQUE` (`Username`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER`
--

LOCK TABLES `USER` WRITE;
/*!40000 ALTER TABLE `USER` DISABLE KEYS */;
INSERT INTO `USER` VALUES (5,'chiara0214'),(4,'giacomo_98'),(6,'luca_previ0o'),(1,'luigi_neri'),(2,'marcobianchi00'),(3,'xx_antonio_xx');
/*!40000 ALTER TABLE `USER` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-09 11:26:44
