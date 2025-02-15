DELIMITER $$

-- Drop the procedure if it already exists
DROP PROCEDURE IF EXISTS Search_All_Columns $$

CREATE PROCEDURE Search_All_Columns(IN table_name VARCHAR(64), IN search_word VARCHAR(255))
BEGIN
    DECLARE sql_query TEXT;

    -- Store search_word into a session variable for use in dynamic SQL
    SET @search_word = CONCAT('%', search_word, '%');

    -- Generate dynamic WHERE clause
    SELECT GROUP_CONCAT(
        CONCAT('COALESCE(`', COLUMN_NAME, '`, '''') LIKE "', @search_word, '"')
        SEPARATOR ' OR '
    ) INTO sql_query
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = table_name AND TABLE_SCHEMA = DATABASE();

    -- Construct the final SQL query
    SET @final_query = CONCAT('SELECT * FROM ', table_name, ' WHERE ', sql_query);

    -- Execute the dynamic SQL
    PREPARE stmt FROM @final_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END $$

DELIMITER ;


/*
how to use
CALL Search_All_Columns('your_table', 'your_word');
*/