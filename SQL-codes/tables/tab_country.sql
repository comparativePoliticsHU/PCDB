CREATE TABLE config_data.country (
		ctr_id		SMALLINT	PRIMARY KEY,
		ctr_n		NAME		UNIQUE,
		ctr_ccode	VARCHAR(3)	UNIQUE,
		ctr_ccode2	VARCHAR(2)	UNIQUE,
		ctr_ccode_nr	NUMERIC(3)	UNIQUE,
		ctr_eu_date	DATE		CONSTRAINT def_eu_date 
			CHECK (ctr_eu_date >= '1951-04-18'::DATE OR ctr_eu_date IS NULL),
		ctr_oecd_date	DATE		CONSTRAINT def_oecd_date 
			CHECK (ctr_oecd_date >= '1961-04-10'::DATE OR ctr_oecd_date IS NULL),
		ctr_wto_date	DATE		CONSTRAINT def_wto_date 
			CHECK (ctr_wto_date >= '1995-01-01'::DATE OR ctr_wto_date IS NULL),
		ctr_cmt		TEXT,
		ctr_src		TEXT
	);