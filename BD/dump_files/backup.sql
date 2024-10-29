CREATE DATABASE IF NOT EXISTS `Torneig_demo` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `Torneig_demo`;
-- MySQL dump 10.13  Distrib 8.0.32, for Win64 (x86_64)
--
-- Host: torneig-db.ctqge8q42h91.eu-south-2.rds.amazonaws.com    Database: Torneig_demo
-- ------------------------------------------------------
-- Server version	8.0.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `Equip`
--

DROP TABLE IF EXISTS `Equip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Equip` (
  `id_equip` bigint NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `curs` varchar(255) DEFAULT NULL,
  `imatge` varchar(255) DEFAULT NULL,
  `guanyador` tinyint(1) DEFAULT '0',
  `id_grup` bigint DEFAULT NULL,
  `id_temporada` bigint DEFAULT NULL,
  `punts` int DEFAULT '0',
  `punts_contra` int DEFAULT '0',
  PRIMARY KEY (`id_equip`),
  KEY `id_grup` (`id_grup`),
  KEY `id_temporada` (`id_temporada`),
  CONSTRAINT `Equip_ibfk_1` FOREIGN KEY (`id_grup`) REFERENCES `Grup` (`id_grup`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Equip_ibfk_2` FOREIGN KEY (`id_temporada`) REFERENCES `Temporada` (`id_temporada`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Equip`
--

LOCK TABLES `Equip` WRITE;
/*!40000 ALTER TABLE `Equip` DISABLE KEYS */;
INSERT INTO `Equip` VALUES (1,'MOLA','3r','assets/icons/escudo.png',0,1,1,1,8),(2,'LOLIS','3r','assets/icons/escudo102.png',0,1,1,8,3),(3,'SENTOS','3r','assets/icons/escudo2.png',0,1,1,5,3),(4,'REICHELS','3r','assets/icons/escudo3.png',0,2,1,4,3),(5,'FURCIOS','4t','assets/icons/escudo4.png',0,2,1,5,2),(6,'NANOS','4t','assets/icons/escudo5.png',0,4,1,4,4),(7,'SIMPSONS','4t','assets/icons/escudo6.png',0,3,1,4,1),(8,'MORTYS','4t','assets/icons/escudo7.png',0,3,1,3,5),(9,'BILIS','5é','assets/icons/escudo8.png',0,1,1,5,1),(10,'NOOBS','5é','assets/icons/escudo9.png',0,2,1,0,5),(11,'PERROS','5é','assets/icons/escudo10.png',0,4,1,4,6),(12,'TRONXITOS','5é','assets/icons/escudo11.png',0,1,1,2,6),(13,'FISTROS','6é','assets/icons/escudo12.png',0,4,1,1,2),(14,'MERLUZOS','6é','assets/icons/escudo13.png',0,2,1,0,5),(15,'TROLLS','6é','assets/icons/escudo14.png',0,3,1,3,5),(16,'VIRRA','6é','assets/icons/escudo52.png',1,4,1,7,0),(17,'XUTAPINSES','3r','assets/icons/escudo16.png',0,2,1,7,1),(18,'TRONQUETS','4t','assets/icons/escudo17.png',0,4,1,1,5),(19,'DORMILONS','5é','assets/icons/escudo18.png',0,3,1,3,2),(20,'ROEDORSITOS','6é','assets/icons/escudo19.png',0,3,1,3,3);
/*!40000 ALTER TABLE `Equip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Fase`
--

DROP TABLE IF EXISTS `Fase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Fase` (
  `id_fase` bigint NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  PRIMARY KEY (`id_fase`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Fase`
--

LOCK TABLES `Fase` WRITE;
/*!40000 ALTER TABLE `Fase` DISABLE KEYS */;
INSERT INTO `Fase` VALUES (1,'GRUPS'),(2,'OCTAUS'),(3,'QUARTS'),(4,'SEMIFINALS'),(5,'FINAL');
/*!40000 ALTER TABLE `Fase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Grup`
--

DROP TABLE IF EXISTS `Grup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Grup` (
  `id_grup` bigint NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  PRIMARY KEY (`id_grup`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Grup`
--

LOCK TABLES `Grup` WRITE;
/*!40000 ALTER TABLE `Grup` DISABLE KEYS */;
INSERT INTO `Grup` VALUES (1,'GRUP A'),(2,'GRUP B'),(3,'GRUP C'),(4,'GRUP D');
/*!40000 ALTER TABLE `Grup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Jugador`
--

DROP TABLE IF EXISTS `Jugador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Jugador` (
  `id_jugador` bigint NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  `edat` int DEFAULT '9',
  `sancionat` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_jugador`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Jugador`
--

LOCK TABLES `Jugador` WRITE;
/*!40000 ALTER TABLE `Jugador` DISABLE KEYS */;
INSERT INTO `Jugador` VALUES (1,'Juan Perez',9,0),(2,'María García',9,0),(3,'Carlos Rodríguez',9,0),(4,'Lola Mostruc',10,0),(5,'Luis Fernández',9,0),(6,'Sofía López',9,0),(7,'Pedro Gómez',9,0),(8,'Laura Sánchez',9,0),(9,'Diego Pérez',9,0),(10,'Paula Rodríguez',9,0),(11,'Javier Martínez',9,0),(12,'Carmen Fernández',9,0),(13,'Mario López',9,0),(14,'Elena Gómez',9,0),(15,'Andrés Sánchez',9,0),(16,'Raquel Pérez',9,0),(17,'Pablo Rodríguez',9,0),(18,'Lucía Martínez',9,0),(19,'Fernando Fernández',9,0),(20,'Isabel López',9,0),(21,'Gabriel Gómez',9,0),(22,'Natalia Sánchez',9,0),(23,'Daniel Pérez',9,0),(24,'Carolina Rodríguez',9,0),(25,'Sergio Martínez',9,0),(26,'Marta Fernández',9,0),(27,'Alejandro López',9,0),(28,'Valeria Gómez',9,0),(29,'Roberto Sánchez',9,0),(30,'Silvia Pérez',9,0),(31,'Víctor Rodríguez',9,0),(32,'Alicia Martínez',9,0),(33,'Hugo Fernández',9,0),(34,'Eva López',9,0),(35,'Jorge Gómez',9,0),(36,'Sara Sánchez',9,0),(37,'Alberto Pérez',9,0),(38,'Nerea Rodríguez',9,0),(39,'Marcos Martínez',9,0),(40,'Cristina Fernández',9,0),(41,'Iván López',9,0),(42,'Beatriz Gómez',9,0),(43,'Manuel Sánchez',9,0),(44,'Nuria Pérez',9,0),(45,'Álvaro Rodríguez',9,0),(46,'Lorena Martínez',9,0),(47,'Raquel Amor',9,0),(48,'Vicent Roselló',9,0),(49,'Lola Indigo',9,0),(50,'Rosalia Zambrano',9,0),(51,'Jesús Artista',9,0),(52,'Juanjo Galdós',9,0),(53,'Isabel Cervantes',9,0),(54,'Felipe Ortega',9,0),(55,'Miguel Ros',9,0),(56,'Ángela Soler',9,0),(57,'Batiste Seba',9,0),(58,'Roqui Almoines',9,0),(59,'Ester Quijano',9,0),(60,'Victor Mendez',9,0);
/*!40000 ALTER TABLE `Jugador` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sentoDev`@`%`*/ /*!50003 TRIGGER `actualitzar_edat_jugador` BEFORE UPDATE ON `Jugador` FOR EACH ROW BEGIN
    -- Verificar si estamos en un año nuevo
    IF YEAR(CURRENT_DATE) > 2024 THEN
        -- Incrementar la edad del jugador en 1
        SET NEW.edat = NEW.edat + 1;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `JugadorEquip`
--

DROP TABLE IF EXISTS `JugadorEquip`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `JugadorEquip` (
  `id_jugador` bigint NOT NULL,
  `id_equip` bigint NOT NULL,
  PRIMARY KEY (`id_jugador`,`id_equip`),
  KEY `id_equip` (`id_equip`),
  CONSTRAINT `JugadorEquip_ibfk_1` FOREIGN KEY (`id_jugador`) REFERENCES `Jugador` (`id_jugador`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `JugadorEquip_ibfk_2` FOREIGN KEY (`id_equip`) REFERENCES `Equip` (`id_equip`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `JugadorEquip`
--

LOCK TABLES `JugadorEquip` WRITE;
/*!40000 ALTER TABLE `JugadorEquip` DISABLE KEYS */;
INSERT INTO `JugadorEquip` VALUES (1,1),(2,1),(3,1),(4,2),(5,2),(6,2),(7,3),(8,3),(9,3),(10,4),(11,4),(12,4),(13,5),(14,5),(15,5),(16,6),(17,6),(18,6),(19,7),(20,7),(21,7),(22,8),(23,8),(24,8),(25,9),(26,9),(27,9),(28,10),(29,10),(30,10),(31,11),(32,11),(33,11),(34,12),(35,12),(36,12),(37,13),(38,13),(39,13),(40,14),(41,14),(42,14),(43,15),(44,15),(45,15),(46,16),(47,16),(48,16),(49,17),(50,17),(51,17),(52,18),(53,18),(54,18),(55,19),(56,19),(57,19),(58,20),(59,20),(60,20);
/*!40000 ALTER TABLE `JugadorEquip` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Partit`
--

DROP TABLE IF EXISTS `Partit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Partit` (
  `id_partit` bigint NOT NULL AUTO_INCREMENT,
  `id_equip_local` bigint NOT NULL,
  `id_equip_visitant` bigint NOT NULL,
  `id_fase` bigint DEFAULT NULL,
  `data_partit` date DEFAULT NULL,
  `resultat_local` int DEFAULT '0',
  `resultat_visitant` int DEFAULT '0',
  `partit_jugat` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_partit`),
  KEY `id_equip_local` (`id_equip_local`),
  KEY `id_equip_visitant` (`id_equip_visitant`),
  KEY `id_fase` (`id_fase`),
  CONSTRAINT `Partit_ibfk_1` FOREIGN KEY (`id_equip_local`) REFERENCES `Equip` (`id_equip`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Partit_ibfk_2` FOREIGN KEY (`id_equip_visitant`) REFERENCES `Equip` (`id_equip`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Partit_ibfk_3` FOREIGN KEY (`id_fase`) REFERENCES `Fase` (`id_fase`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Partit`
--

LOCK TABLES `Partit` WRITE;
/*!40000 ALTER TABLE `Partit` DISABLE KEYS */;
INSERT INTO `Partit` VALUES (1,2,1,1,'2024-04-24',2,0,1),(2,1,3,1,'2024-04-01',1,2,1),(3,1,9,1,'2024-04-03',0,2,1),(4,1,12,1,'2024-04-13',0,2,1),(5,2,3,1,'2024-04-14',2,2,1),(6,9,2,1,'2024-04-26',1,1,1),(7,2,12,1,'2024-04-02',3,0,1),(8,9,3,1,'2024-04-27',0,0,1),(9,12,3,1,'2024-04-25',0,1,1),(10,9,12,1,'2024-04-15',2,0,1),(11,4,5,1,'2024-04-04',1,1,1),(12,10,4,1,'2024-04-17',0,1,1),(13,14,4,1,'2024-04-29',0,2,1),(14,17,4,1,'2024-04-06',2,0,1),(15,10,5,1,'2024-04-28',0,1,1),(16,5,14,1,'2024-04-16',2,0,1),(17,17,5,1,'2024-04-30',1,1,1),(18,14,10,1,'2024-04-05',0,0,1),(19,17,10,1,'2024-05-01',3,0,1),(20,17,14,1,'2024-04-18',1,0,1),(21,7,8,1,'2024-04-07',0,0,1),(22,7,15,1,'2024-04-19',2,0,1),(23,19,7,1,'2024-05-03',0,2,1),(24,20,7,1,'2024-05-04',1,0,1),(25,8,15,1,'2024-05-02',3,0,1),(26,19,8,1,'2024-04-09',3,0,1),(27,8,20,1,'2024-04-20',0,2,1),(28,19,15,1,'2024-04-21',0,0,1),(29,15,20,1,'2024-04-08',3,0,1),(30,19,20,1,'2024-05-03',0,0,1),(31,6,11,1,'2024-04-10',3,0,1),(32,13,6,1,'2024-04-23',0,0,1),(33,16,6,1,'2024-04-12',3,0,1),(34,6,18,1,'2024-04-21',1,1,1),(35,13,11,1,'2024-04-07',0,2,1),(36,11,16,1,'2024-04-22',0,3,1),(37,11,18,1,'2024-04-06',2,0,1),(38,16,13,1,'2024-04-08',0,0,1),(39,13,18,1,'2024-04-11',1,0,1),(40,18,16,1,'2024-04-09',0,1,1),(41,17,13,2,'2024-05-05',3,0,1),(42,9,3,2,'2024-05-06',0,3,1),(43,2,8,2,'2024-05-07',3,0,1),(44,19,4,2,'2024-05-08',0,1,1),(45,7,12,2,'2024-05-09',0,2,1),(46,5,20,2,'2024-05-10',1,0,1),(47,16,10,2,'2024-05-11',3,0,1),(48,6,11,2,'2024-05-12',0,1,1),(49,17,3,3,'2024-05-13',0,3,1),(50,2,4,3,'2024-05-14',1,0,1),(51,12,5,3,'2024-05-15',0,1,1),(52,16,11,3,'2024-05-16',2,0,1),(53,3,2,4,'2024-05-17',0,1,1),(54,5,16,4,'2024-05-18',0,3,1),(55,2,16,5,'2024-05-19',0,1,1);
/*!40000 ALTER TABLE `Partit` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sentoDev`@`%`*/ /*!50003 TRIGGER `actualitzar_puntsEquip_after_insert` AFTER INSERT ON `Partit` FOR EACH ROW BEGIN
	DECLARE fase_id bigint;
	DECLARE resultado_local INT;
	DECLARE resultado_visitant INT;

		-- Obtener el id de la fase de GRUPS del partido insertado
		SELECT id_fase INTO fase_id FROM Fase WHERE id_fase = NEW.id_fase;

		-- Obtener los resultados del partido
		SET resultado_local = NEW.resultat_local;
		SET resultado_visitant = NEW.resultat_visitant;
		
		
		 -- Verificar si la fase es "Grups" y los resultados no son NULL
		IF fase_id = 1 THEN
		
		 -- Actualizar puntuació del equip local
			UPDATE Equip
			SET punts = punts + NEW.resultat_local
			WHERE Equip.id_equip = NEW.id_equip_local;
            
			-- Actualizar puntuació en contra del equip local
            UPDATE Equip
			SET punts_contra = punts_contra + NEW.resultat_visitant
			WHERE Equip.id_equip = NEW.id_equip_local;

		    -- Actualizar puntuació del equipo visitant
			UPDATE Equip
			SET punts = punts + NEW.resultat_visitant
			WHERE Equip.id_equip = NEW.id_equip_visitant;
            
            -- Actualizar puntuació en contra del equip visitant
            UPDATE Equip
			SET punts_contra = punts_contra + NEW.resultat_local
			WHERE Equip.id_equip = NEW.id_equip_visitant;
		END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sentoDev`@`%`*/ /*!50003 TRIGGER `actualitzar_puntsEquip_after_update` AFTER UPDATE ON `Partit` FOR EACH ROW BEGIN
DECLARE fase_id bigint;

    -- Obtener el id de la fase de GRUPS del partido insertado
    SELECT id_fase INTO fase_id FROM Fase WHERE id_fase = NEW.id_fase;
    
    -- Verificar si la fase es "Grups" y los nuevos resultados no son NULL
    IF fase_id = 1 THEN
        -- Actualizem els punts del equip local, tractem els resultats NULL com a 0
        UPDATE Equip
        SET punts = punts - COALESCE(OLD.resultat_local, 0) + COALESCE(NEW.resultat_local, 0)
        WHERE Equip.id_equip = NEW.id_equip_local;
        
        -- Actualitzem els punts en contra del equip local
        update Equip
        SET punts_contra = punts_contra - COALESCE(old.resultat_visitant,0) + COALESCE(new.resultat_visitant,0)
        WHERE Equip.id_equip = NEW.id_equip_local; 

        -- Actualizem els punts del equip visitant, tractem els resultats NULL com a 0
        UPDATE Equip
        SET punts = punts - COALESCE(OLD.resultat_visitant, 0) + COALESCE(NEW.resultat_visitant, 0)
        WHERE Equip.id_equip = NEW.id_equip_visitant;
        
        -- Actualitzem els punts en contra del equip visitant
        update Equip
        SET punts_contra = punts_contra - COALESCE(old.resultat_local,0) + COALESCE(new.resultat_local,0)
        WHERE Equip.id_equip = NEW.id_equip_visitant;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sentoDev`@`%`*/ /*!50003 TRIGGER `actualitzar_puntsEquip_after_delete` AFTER DELETE ON `Partit` FOR EACH ROW BEGIN
DECLARE fase_id bigint;

    -- Obtener el id de la fase de GRUPS del partido insertado
    SELECT id_fase INTO fase_id FROM Fase WHERE id_fase = OLD.id_fase;

    -- Verifiquem si és de la fase de "Grups"
    IF fase_id = 1 THEN
        -- Restem els punts al equipo local
        UPDATE Equip
        SET punts = punts - OLD.resultat_local
        WHERE Equip.id_equip = OLD.id_equip_local;

        -- Restem els punts en contra al equipo local
        UPDATE Equip
        SET punts_contra = punts_contra - OLD.resultat_visitant
        WHERE Equip.id_equip = OLD.id_equip_local;

       -- Restem els punts al equipo visitant
        UPDATE Equip
        SET punts = punts - OLD.resultat_visitant
        WHERE Equip.id_equip = OLD.id_equip_visitant;

        -- Restem els punts en contra al equipo visitant
        UPDATE Equip
        SET punts_contra = punts_contra - OLD.resultat_local
        WHERE Equip.id_equip = OLD.id_equip_visitant;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Roles`
--

DROP TABLE IF EXISTS `Roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` enum('ADMIN','USER') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Roles`
--

LOCK TABLES `Roles` WRITE;
/*!40000 ALTER TABLE `Roles` DISABLE KEYS */;
INSERT INTO `Roles` VALUES (1,'ADMIN'),(2,'USER');
/*!40000 ALTER TABLE `Roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Temporada`
--

DROP TABLE IF EXISTS `Temporada`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Temporada` (
  `id_temporada` bigint NOT NULL AUTO_INCREMENT,
  `nom` varchar(255) NOT NULL,
  PRIMARY KEY (`id_temporada`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Temporada`
--

LOCK TABLES `Temporada` WRITE;
/*!40000 ALTER TABLE `Temporada` DISABLE KEYS */;
INSERT INTO `Temporada` VALUES (1,'CURS 24 - 25');
/*!40000 ALTER TABLE `Temporada` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`sentoDev`@`%`*/ /*!50003 TRIGGER `crear_grups_inici_temporada` AFTER INSERT ON `Temporada` FOR EACH ROW BEGIN
	insert into Grup (nom) values ('GRUP A');
	insert into Grup (nom) values ('GRUP B');
	insert into Grup (nom) values ('GRUP C');
	insert into Grup (nom) values ('GRUP D');
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `User_Roles`
--

DROP TABLE IF EXISTS `User_Roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User_Roles` (
  `id_usuari` bigint NOT NULL,
  `id_rol` bigint NOT NULL,
  PRIMARY KEY (`id_usuari`,`id_rol`),
  KEY `id_rol` (`id_rol`),
  CONSTRAINT `User_Roles_ibfk_1` FOREIGN KEY (`id_usuari`) REFERENCES `Users` (`id_usuari`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `User_Roles_ibfk_2` FOREIGN KEY (`id_rol`) REFERENCES `Roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User_Roles`
--

LOCK TABLES `User_Roles` WRITE;
/*!40000 ALTER TABLE `User_Roles` DISABLE KEYS */;
INSERT INTO `User_Roles` VALUES (1,1),(4,1),(2,2);
/*!40000 ALTER TABLE `User_Roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `id_usuari` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_usuari`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'sento','$2a$10$ONpX/cPtEc1oHKdm7y/jsO3M1xq6EFr7eayoGd/RgSUFmjYd1VEIe'),(2,'alu','$2a$10$Ex1h/y0IDOANHWoU1asfQeOGs90oXCZOpiSEQvheuYizZ3cZoZ42m'),(4,'admin','$2a$10$ULbeTf5CvHONWmWwJ36Av.KSGd3y3Kb/EeBUyGNKNXWmX95n48hQC');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-29 18:53:13
