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

-- Dumping structure for table playonline.poldb_profiles
CREATE TABLE IF NOT EXISTS `poldb_profiles` (
  `handleId` bigint(20) unsigned NOT NULL,
  `handleNum` smallint(5) unsigned NOT NULL DEFAULT 0,
  `visibility` tinyint(3) unsigned NOT NULL DEFAULT 3,
  `portrait` int(10) unsigned NOT NULL DEFAULT 0,
  `updateTime` int(11) unsigned DEFAULT 0,
  `age` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `ageVisibility` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `sex` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `locationContinent` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `locationCountry` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `locationProvinceState` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `locale` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `language0` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `language1` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `language2` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `job` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `interest0` smallint(5) unsigned NOT NULL DEFAULT 0,
  `interest1` smallint(5) unsigned NOT NULL DEFAULT 0,
  `interest2` smallint(5) unsigned NOT NULL DEFAULT 0,
  `purpose` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `email` varchar(322) NOT NULL DEFAULT 'No Mail address',
  `rlang` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `aa_mt` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `aa_dt` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `aa_t` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `aa_m` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `aa_c` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `aa_w` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `aa_d` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `aa_e` tinyint(3) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`handleId`),
  CONSTRAINT `FK_profiles_handles` FOREIGN KEY (`handleId`) REFERENCES `handles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Data exporting was unselected.
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
