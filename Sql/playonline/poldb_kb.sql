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

-- Dumping structure for table playonline.poldb_kb
CREATE TABLE IF NOT EXISTS `poldb_kb` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `category1` smallint(5) unsigned NOT NULL DEFAULT 0,
  `category2` smallint(5) unsigned NOT NULL DEFAULT 0,
  `question` varchar(256) NOT NULL DEFAULT '',
  `answer` varchar(4000) NOT NULL DEFAULT '',
  `searchQuestion` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `searchAnswer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
  `createTime` timestamp NOT NULL DEFAULT current_timestamp(),
  `modifyTime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `locale` varchar(8) NOT NULL DEFAULT 'en',
  PRIMARY KEY (`id`),
  KEY `category` (`category1`,`category2`),
  KEY `locale` (`locale`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dumping data for table playonline.poldb_kb: ~1 rows (approximately)
DELETE FROM `poldb_kb`;
/*!40000 ALTER TABLE `poldb_kb` DISABLE KEYS */;
INSERT INTO `poldb_kb` (`id`, `category1`, `category2`, `question`, `answer`, `searchQuestion`, `searchAnswer`, `createTime`, `modifyTime`, `locale`) VALUES
	(1, 1, 1, 'Project Crystalとは何ですか？', 'Project Crystalは、PlayOnlineサーバー群およびPS2版FFXIのエミュレーションプロジェクトです。', 'project crystalとは何ですか?', 'project crystalは､playonlineｻｰﾊﾞｰ群およびps2版ffxiのｴﾐｭﾚｰｼｮﾝﾌﾟﾛｼﾞｪｸﾄです｡', '2026-11-21 02:41:56', '2026-11-21 03:04:06', 'ja'),
	(2, 1, 1, 'What is Project Crystal?', 'Project Crystal is a emulation of the POL server suite as well as FFXI for PS2.', 'what is project crystal?', 'project crystal is a emulation of the pol server suite as well as ffxi for ps2.', '2026-11-21 02:53:05', '2026-11-21 03:05:46', 'en');
/*!40000 ALTER TABLE `poldb_kb` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
