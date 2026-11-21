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

-- Dumping structure for view playonline.chatrooms_polbes_view
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `chatrooms_polbes_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `chatrooms_polbes_view` AS select ascii(substr(`chatrooms`.`channel`,1,1)) AS `channelPrefix`,coalesce(cast(conv(substr(`chatrooms`.`channel`,2,2),16,10) as unsigned),0) AS `channelLang`,ascii(substr(`chatrooms`.`channel`,4,1)) AS `channelUse`,ascii(substr(`chatrooms`.`channel`,5,1)) AS `channelKind`,substr(`chatrooms`.`channel`,6) AS `channelIdx`,`chatrooms`.`usersCurrent` AS `usersCurrent`,`chatrooms`.`zoneCode` AS `zoneCode`,`chatrooms`.`memberCode` AS `memberCode`,`chatrooms`.`purposeCode` AS `purposeCode`,`chatrooms`.`languageCode` AS `languageCode`,`chatrooms`.`chatroomName` AS `chatroomName`,`chatrooms`.`usersMax` AS `usersMax`,`chatrooms`.`hasPassword` AS `hasPassword`,cast(unix_timestamp(`chatrooms`.`creationTime`) as unsigned) AS `createTime` from `chatrooms`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
