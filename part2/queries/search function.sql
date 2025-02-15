DELIMITER $$

DROP FUNCTION IF EXISTS Search_In_RawData $$

CREATE FUNCTION Search_In_RawData(search_word VARCHAR(255))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE result_count INT;

    -- Search across multiple columns (modify column names as needed)
    SELECT COUNT(*) INTO result_count
    FROM raw_data
    WHERE CONCAT_WS(' ', column1, column2, column3) LIKE CONCAT('%', search_word, '%');

    RETURN result_count;
END $$

DELIMITER ;



-- SELECT Search_In_RawData('0rZRTXEmmPmx6gt92tBqIc') AS match_count;