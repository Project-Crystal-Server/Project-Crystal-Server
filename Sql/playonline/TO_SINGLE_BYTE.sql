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

-- Dumping structure for function playonline.TO_SINGLE_BYTE
DELIMITER //
CREATE FUNCTION `TO_SINGLE_BYTE`(`input` TEXT CHARSET utf8mb4) RETURNS text CHARSET utf8mb4 COLLATE utf8mb4_bin
    NO SQL
    DETERMINISTIC
BEGIN
    DECLARE plainFull  VARCHAR(63) CHARSET utf8mb4 COLLATE utf8mb4_bin DEFAULT
        'ァアィイゥウェエォオカキクケコサシスセソタチッツテトナニヌネノハヒフヘホマミムメモャヤュユョヨラリルレロワヲンー。「」、・゛゜';
    DECLARE plainHalf  VARCHAR(63) CHARSET utf8mb4 COLLATE utf8mb4_bin DEFAULT
        'ｧｱｨｲｩｳｪｴｫｵｶｷｸｹｺｻｼｽｾｿﾀﾁｯﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓｬﾔｭﾕｮﾖﾗﾘﾙﾚﾛﾜｦﾝｰ｡｢｣､･ﾞﾟ';
    DECLARE voicedFull VARCHAR(21) CHARSET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'ガギグゲゴザジズゼゾダヂヅデドバビブベボヴ';
    DECLARE voicedBase VARCHAR(21) CHARSET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'ｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾊﾋﾌﾍﾎｳ';
    DECLARE semiFull   VARCHAR(5)  CHARSET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'パピプペポ';
    DECLARE semiBase   VARCHAR(5)  CHARSET utf8mb4 COLLATE utf8mb4_bin DEFAULT 'ﾊﾋﾌﾍﾎ';

    DECLARE result TEXT CHARSET utf8mb4 COLLATE utf8mb4_bin DEFAULT '';
    DECLARE ch VARCHAR(2) CHARSET utf8mb4 COLLATE utf8mb4_bin;
    DECLARE cp INT;
    DECLARE pos INT;
    DECLARE i INT DEFAULT 1;
    DECLARE len INT;

    IF input IS NULL THEN RETURN NULL; END IF;
    SET len = CHAR_LENGTH(input);
    WHILE i <= len DO
        SET ch = SUBSTRING(input, i, 1);
        SET cp = CONV(HEX(CONVERT(ch USING utf32)), 16, 10);
        IF cp BETWEEN 65281 AND 65374 THEN
            SET ch = CHAR(cp - 65248 USING utf8mb4);
        ELSEIF cp = 12288 THEN
            SET ch = ' ';
        ELSE
            SET pos = INSTR(plainFull, ch);
            IF pos > 0 THEN
                SET ch = SUBSTRING(plainHalf, pos, 1);
            ELSE
                SET pos = INSTR(voicedFull, ch);
                IF pos > 0 THEN
                    SET ch = CONCAT(SUBSTRING(voicedBase, pos, 1), 'ﾞ');
                ELSE
                    SET pos = INSTR(semiFull, ch);
                    IF pos > 0 THEN
                        SET ch = CONCAT(SUBSTRING(semiBase, pos, 1), 'ﾟ');
                    END IF;
                END IF;
            END IF;
        END IF;
        SET result = CONCAT(result, ch);
        SET i = i + 1;
    END WHILE;
    RETURN result;
END//
DELIMITER ;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
