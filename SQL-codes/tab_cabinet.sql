CREATE TABLE config_data.cabinet (
		cab_id		NUMERIC(5)	PRIMARY KEY,
		cab_prv_id	NUMERIC(5),
		ctr_id		SMALLINT	
			REFERENCES config_data.country (ctr_id)
			ON UPDATE CASCADE,
		cab_sdate	DATE,
		cab_hog_n	VARCHAR(15)	,
		cab_sts_ttl	NUMERIC(2,0)	,
		cab_care	BOOLEAN		,
		cab_cmt		TEXT,
		cab_src		TEXT
		);