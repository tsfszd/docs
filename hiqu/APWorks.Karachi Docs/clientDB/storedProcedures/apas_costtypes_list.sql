DELIMITER $$
DROP PROCEDURE IF EXISTS apas_costtypes_list;$$

CREATE PROCEDURE apas_costtypes_list
(
	IN company_code_param   INT
)
BEGIN
	SELECT
		company_code,
		cost_type,
		cost_type_name,
		cost_type_description,
		cost_type_status,
		effective_date,
		expiration_date
	FROM
		apam_cost_types ct
	WHERE
		ct.company_code = company_code_param
	ORDER BY
		ct.cost_type_description;
END$$
DELIMITER ;

