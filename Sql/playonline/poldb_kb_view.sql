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

-- Dumping structure for view playonline.poldb_kb_view
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `poldb_kb_view`;
CREATE ALGORITHM=UNDEFINED DEFINER=`pol`@`73.156.95.239` SQL SECURITY DEFINER VIEW `poldb_kb_view` AS select `poldb_kb`.`id` AS `id`,`poldb_kb`.`category1` AS `category1`,`poldb_kb`.`category2` AS `category2`,`poldb_kb`.`question` AS `question`,`poldb_kb`.`answer` AS `answer`,`poldb_kb`.`searchQuestion` AS `searchQuestion`,`poldb_kb`.`searchAnswer` AS `searchAnswer`,cast(unix_timestamp(`poldb_kb`.`createTime`) as unsigned) AS `createTime`,cast(unix_timestamp(`poldb_kb`.`modifyTime`) as unsigned) AS `modifyTime`,`poldb_kb`.`locale` AS `locale` from `poldb_kb`;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
