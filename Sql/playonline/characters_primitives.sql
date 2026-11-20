-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               11.8.6-MariaDB
-- Server OS:                    debian-linux-gnu
-- HeidiSQL Version:             10.1.0.5464
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for view playonline.characters_primitives
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `characters_primitives`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `characters_primitives` AS select `characters`.`polId` AS `polId`,`characters`.`contentClass` AS `contentClass`,`characters`.`id` AS `contentId`,`characters`.`subId` AS `contentSubId`,`handles`.`id` AS `handleId`,`characters`.`handleCreationPosition` AS `handleNum`,`characters`.`creationPosition` AS `characterNum`,`characters`.`linkPosition` AS `attachOrder`,`characters`.`name` AS `name`,`handles`.`name` AS `handleName` from (`characters` join `handles` on(`handles`.`polId` = `characters`.`polId` and `handles`.`creationPosition` = `characters`.`handleCreationPosition`)) order by `characters`.`linkPosition`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
