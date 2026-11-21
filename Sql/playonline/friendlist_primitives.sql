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

-- Dumping structure for view playonline.friendlist_primitives
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `friendlist_primitives`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `friendlist_primitives` AS select `friendlist`.`ownerPolId` AS `ownerPolId`,`friendlist`.`creationPosition` AS `friendNum`,`cp`.`attachOrder` AS `attachOrder`,`cp`.`contentClass` AS `contentClass`,`cp`.`contentSubId` AS `contentSubId`,`cp`.`contentId` AS `contentId` from (`friendlist` join `characters_primitives` `cp` on(`cp`.`handleId` = `friendlist`.`friendHandleId`));

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
