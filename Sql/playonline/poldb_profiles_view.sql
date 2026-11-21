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

-- Dumping structure for view playonline.poldb_profiles_view
-- Removing temporary table and create final VIEW structure
DROP TABLE IF EXISTS `poldb_profiles_view`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `poldb_profiles_view` AS select `handles`.`polId` AS `polProData`,`handles`.`name` AS `name`,ucase(`handles`.`name`) AS `upName`,`poldb_profiles`.`handleId` AS `handleId`,`poldb_profiles`.`handleNum` AS `handleNum`,`poldb_profiles`.`visibility` AS `visibility`,`poldb_profiles`.`portrait` AS `portrait`,`poldb_profiles`.`updateTime` AS `updateTime`,`poldb_profiles`.`age` AS `age`,`poldb_profiles`.`ageVisibility` AS `ageVisibility`,`poldb_profiles`.`sex` AS `sex`,`poldb_profiles`.`locationContinent` AS `locationContinent`,`poldb_profiles`.`locationCountry` AS `locationCountry`,`poldb_profiles`.`locationProvinceState` AS `locationProvinceState`,`poldb_profiles`.`locale` AS `locale`,`poldb_profiles`.`language0` AS `language0`,`poldb_profiles`.`language1` AS `language1`,`poldb_profiles`.`language2` AS `language2`,`poldb_profiles`.`job` AS `job`,`poldb_profiles`.`interest0` AS `interest0`,`poldb_profiles`.`interest1` AS `interest1`,`poldb_profiles`.`interest2` AS `interest2`,`poldb_profiles`.`purpose` AS `purpose`,`poldb_profiles`.`email` AS `email`,`poldb_profiles`.`rlang` AS `rlang`,`poldb_profiles`.`aa_mt` AS `aa_mt`,`poldb_profiles`.`aa_dt` AS `aa_dt`,`poldb_profiles`.`aa_t` AS `aa_t`,`poldb_profiles`.`aa_m` AS `aa_m`,`poldb_profiles`.`aa_c` AS `aa_c`,`poldb_profiles`.`aa_w` AS `aa_w`,`poldb_profiles`.`aa_d` AS `aa_d`,`poldb_profiles`.`aa_e` AS `aa_e` from (`poldb_profiles` join `handles` on(`handles`.`id` = `poldb_profiles`.`handleId`));

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
