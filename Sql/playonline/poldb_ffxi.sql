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

-- Dumping structure for table playonline.poldb_ffxi
CREATE TABLE IF NOT EXISTS `poldb_ffxi` (
  `contentId` bigint(20) unsigned DEFAULT NULL,
  `contentSubId` mediumint(8) unsigned DEFAULT 0,
  `name` varchar(16) DEFAULT '',
  `purpose` tinyint(3) unsigned DEFAULT 0,
  `lang` tinyint(3) unsigned DEFAULT 0,
  `worldName` varchar(50) DEFAULT '',
  `countryId` smallint(5) unsigned DEFAULT 3,
  `zoneId` smallint(5) unsigned DEFAULT 0,
  `jobId` smallint(5) unsigned DEFAULT 0,
  `jobLevel` smallint(5) unsigned DEFAULT 0,
  `raceId` smallint(5) unsigned DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
