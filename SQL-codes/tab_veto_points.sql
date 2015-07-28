CREATE TABLE config_data.veto_points (
		vto_id		NUMERIC(5)	PRIMARY KEY,
		ctr_id		SMALLINT
			REFERENCES config_data.country(ctr_id)
			ON UPDATE CASCADE,
		vto_inst_typ	VTO_TYPE,
		vto_inst_n	NAME,
		vto_inst_n_en	NAME,
		vto_inst_sdate	DATE
			CONSTRAINT def_inst_sdate NOT NULL DEFAULT '1900-01-01'::date,
		vto_inst_edate	DATE
			CONSTRAINT def_inst_edate DEFAULT NULL,
		vto_pwr		NUMERIC(3,2),
		vto_cmt		TEXT,	
		vto_src		TEXT	
		);
