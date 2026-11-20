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

-- Dumping structure for function playonline.PolIdToPolProData
DELIMITER //
CREATE FUNCTION `PolIdToPolProData`(`p_polProId` BIGINT UNSIGNED,
	`p_scrambleMask` BOOLEAN



) RETURNS varchar(8) CHARSET latin1 COLLATE latin1_swedish_ci
    DETERMINISTIC
BEGIN
    DECLARE v_value BIGINT UNSIGNED;
    DECLARE v_lastValue BIGINT UNSIGNED;
    DECLARE v_polProData VARCHAR(8) DEFAULT '';
    DECLARE i INT DEFAULT 7;
    DECLARE v_charMap VARCHAR(36);
    
    -- Your exact sqPolIdToCharacterMap decoded from ASCII hex
    SET v_charMap = 'EFKAOYMJVNGTDSWBQLPCIRHZXU6328401795';

    -- Apply the bitwise mask logic using hex literals
    IF p_scrambleMask THEN
        SET v_value = p_polProId & 0x3FFFFFFFFFF;
    ELSE
        SET v_value = p_polProId & 0x1FFFFFFFFFF;
    END IF;

    -- The base-36 decoding loop
    WHILE i >= 0 DO
        SET v_lastValue = v_value;
        SET v_value = FLOOR(v_value / 36); -- 0x24 is 36
        
        -- Calculate index: lastValue - (value * 36)
        -- +1 is added because MySQL SUBSTRING() starts at index 1
        SET v_polProData = CONCAT(
            SUBSTRING(v_charMap, (v_lastValue - (v_value * 36)) + 1, 1), 
            v_polProData
        );
        
        SET i = i - 1;
    END WHILE;

    RETURN v_polProData;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
