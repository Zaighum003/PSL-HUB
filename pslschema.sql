-- MySQL dump 10.13  Distrib 8.2.0, for Win64 (x86_64)
--
-- Host: localhost    Database: pslhub
-- ------------------------------------------------------
-- Server version	8.2.0

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

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `admin_chk_1` CHECK (((length(`password`) >= 8) and regexp_like(`password`,_cp850'[0-9]')))
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `batting_stats`
--

DROP TABLE IF EXISTS `batting_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `batting_stats` (
  `player_innings_id` int NOT NULL,
  `player_id` int NOT NULL,
  `inning_id` int NOT NULL,
  `runs_scored` int NOT NULL,
  `balls_faced` int NOT NULL,
  `fours_hit` int NOT NULL,
  `sixes_hit` int NOT NULL,
  `out_or_not_out` varchar(10) NOT NULL,
  KEY `player_id` (`player_id`),
  KEY `inning_id` (`inning_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_batting_stats_insert` AFTER INSERT ON `batting_stats` FOR EACH ROW BEGIN
    DECLARE total_matches INT;
    DECLARE total_innings INT;
    DECLARE total_runs INT;
    DECLARE total_fours INT;
    DECLARE total_sixes INT;
    DECLARE total_balls_faced INT;
    DECLARE total_not_outs INT;
    DECLARE total_highest_score INT;
    DECLARE total_strike_rate DECIMAL(5,2);
    DECLARE total_average DECIMAL(5,2);

    -- Calculate total matches, innings, runs, fours, sixes, balls faced, and highest score for the player
    SELECT COUNT(DISTINCT player_innings_id), SUM(runs_scored), SUM(fours_hit), SUM(sixes_hit), SUM(balls_faced),
           SUM(CASE WHEN out_or_not_out = 'Not Out' THEN 1 ELSE 0 END), MAX(runs_scored)
    INTO total_matches, total_runs, total_fours, total_sixes, total_balls_faced, total_not_outs, total_highest_score
    FROM batting_stats
    WHERE player_id = NEW.player_id;

    -- Calculate total innings (distinct inning_id count) for the player
    SELECT COUNT(DISTINCT inning_id) INTO total_innings
    FROM batting_stats
    WHERE player_id = NEW.player_id;

    -- Calculate batting average and strike rate
    SET total_strike_rate = IF(total_balls_faced > 0, (total_runs / total_balls_faced) * 100, 0);
    SET total_strike_rate = ROUND(total_strike_rate, 2);

    IF total_not_outs = total_matches THEN
        SET total_not_outs = total_matches - 1;
    END IF;

    IF total_matches > 0 THEN
        SET total_runs = total_runs - total_not_outs;
        SET total_matches = total_matches - total_not_outs;
    END IF;

    IF total_matches > 0 THEN
        SET total_average = total_runs / total_matches;
    ELSE
        SET total_average = 0;
    END IF;

    -- Update the corresponding row in battingstats_players table
    UPDATE battingstats_players
    SET matches = total_matches,
        innings = total_innings,
        runs = total_runs,
        strike_rate = total_strike_rate,
        highest_score = total_highest_score,
        average = total_average,
        fours = total_fours,
        sixes = total_sixes
    WHERE player_id = NEW.player_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `battingstats_players`
--

DROP TABLE IF EXISTS `battingstats_players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `battingstats_players` (
  `player_id` int NOT NULL,
  `matches` int NOT NULL DEFAULT '0',
  `innings` int NOT NULL DEFAULT '0',
  `runs` int NOT NULL DEFAULT '0',
  `strike_rate` decimal(5,2) NOT NULL DEFAULT '0.00',
  `highest_score` int NOT NULL DEFAULT '0',
  `average` decimal(5,2) NOT NULL DEFAULT '0.00',
  `fours` int NOT NULL DEFAULT '0',
  `sixes` int NOT NULL DEFAULT '0',
  KEY `player_id` (`player_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bowling_stats`
--

DROP TABLE IF EXISTS `bowling_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bowling_stats` (
  `inning_id` int NOT NULL,
  `player_id` int NOT NULL,
  `runs` int NOT NULL DEFAULT '0',
  `wickets` int NOT NULL DEFAULT '0',
  `overs` int NOT NULL DEFAULT '0',
  `economy` decimal(4,2) NOT NULL,
  KEY `player_id` (`player_id`),
  KEY `inning_id` (`inning_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `after_bowling_stats_insert` AFTER INSERT ON `bowling_stats` FOR EACH ROW BEGIN
    -- Update matches, innings, runs, wickets, and economy for the player in bowlingstats_players
    UPDATE bowlingstats_players
    SET matches = matches + 1,
        innings = innings + 1,
        runs = runs + NEW.runs,
        wickets = wickets + NEW.wickets,
        economy = ((runs + NEW.runs) / (innings + 1))/4
    WHERE player_id = NEW.player_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `bowlingstats_players`
--

DROP TABLE IF EXISTS `bowlingstats_players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bowlingstats_players` (
  `player_id` int NOT NULL,
  `matches` int NOT NULL DEFAULT '0',
  `innings` int NOT NULL DEFAULT '0',
  `runs` int NOT NULL DEFAULT '0',
  `wickets` int NOT NULL DEFAULT '0',
  `economy` decimal(4,2) NOT NULL,
  KEY `player_id` (`player_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `innings`
--

DROP TABLE IF EXISTS `innings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `innings` (
  `Inning_ID` int NOT NULL,
  `Match_ID` int DEFAULT NULL,
  `Batting_Team_ID` int DEFAULT NULL,
  `Bowling_Team_ID` int DEFAULT NULL,
  `Total_Runs_Scored` int DEFAULT NULL,
  `Total_Wickets_Taken` int DEFAULT NULL,
  PRIMARY KEY (`Inning_ID`),
  KEY `Match_ID` (`Match_ID`),
  KEY `Batting_Team_ID` (`Batting_Team_ID`),
  KEY `Bowling_Team_ID` (`Bowling_Team_ID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `matches`
--

DROP TABLE IF EXISTS `matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `matches` (
  `match_id` int NOT NULL,
  `team1_id` int NOT NULL,
  `team2_id` int NOT NULL,
  `venue_id` int NOT NULL,
  `match_date` date NOT NULL,
  `match_time` time NOT NULL,
  `man_of_the_match` int DEFAULT NULL,
  `winning_team` int DEFAULT NULL,
  PRIMARY KEY (`match_id`),
  KEY `team1_id` (`team1_id`),
  KEY `team2_id` (`team2_id`),
  KEY `venue_id` (`venue_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `players` (
  `player_id` int NOT NULL,
  `player_name` varchar(50) NOT NULL,
  `nationality` varchar(50) NOT NULL,
  `dob` date NOT NULL,
  `team_id` int NOT NULL,
  `role` varchar(50) NOT NULL,
  PRIMARY KEY (`player_id`),
  KEY `team_id` (`team_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `team_id` int NOT NULL,
  `team_name` varchar(50) NOT NULL,
  `owner_name` varchar(50) NOT NULL,
  `city` varchar(50) NOT NULL,
  `captain` varchar(50) NOT NULL,
  PRIMARY KEY (`team_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `venues`
--

DROP TABLE IF EXISTS `venues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `venues` (
  `venue_id` int NOT NULL,
  `v_name` varchar(50) NOT NULL,
  `v_city` varchar(50) NOT NULL,
  `v_capacity` int NOT NULL,
  PRIMARY KEY (`venue_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-09-14 22:55:17
