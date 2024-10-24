drop PROCEDURE apsp_GetInvoiceFetchInfo;

DELIMITER $$

CREATE PROCEDURE apsp_GetInvoiceFetchInfo (
)
begin

DECLARE min int;
DECLARE max int;

DROP TEMPORARY TABLE IF EXISTS _temp,_final;

create temporary table _temp (
	id INT NOT NULL auto_increment,
    statement VARCHAR(8000),
    PRIMARY KEY (id)
);

create temporary table _final (
	ent_record_id INT, 
    ent_client_name VARCHAR(256), 
    company_code int, 
    co_name VARCHAR(64), 
    db_hostname varchar(128), 
	db_port varchar(128), 
	db_username varchar(128), 
	db_password varchar(128),
    nexelus_s3_storage_connection_string VARCHAR(512), 
    client_ftp_site_connection_string VARCHAR(1024), 
    invoice_collection_email VARCHAR(128)
);

insert into _temp (statement)
SELECT concat("INSERT INTO _final ","select '", ent_record_id,"' ent_record_id, '", ent_client_name,"' ent_client_name, ",
 "company_code, co_name, nexelus_s3_storage_connection_string, ",
"client_ftp_site_connection_string, invoice_collection_email from ",db_schema_name,".apam_company") statement
FROM tao_apautomation_common.ent_client
WHERE active_flag = 1;


set min = (select min(id) from _temp);
set max = (select max(id) from _temp);

WHILE min <= max DO
	SET @query = (select statement from _temp
    WHERE id = min);
    
    PREPARE stmt1 FROM @query; 
	EXECUTE stmt1; 
	DEALLOCATE PREPARE stmt1;
    
    SET min = min + 1;
    
END WHILE;

SELECT * FROM _final;

DROP TEMPORARY TABLE _temp, _final;

end$$

DELIMITER ;