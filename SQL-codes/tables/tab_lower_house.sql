CREATE TABLE config_data.lower_house (
		lh_id		NUMERIC(5)	PRIMARY KEY,
		lh_prv_id	NUMERIC(5),
		lh_nxt_id	NUMERIC(5),
		lhelc_id	NUMERIC(5)
			REFERENCES config_data.lh_election
			MATCH SIMPLE
			ON UPDATE CASCADE,
		ctr_id		SMALLINT
			REFERENCES config_data.country(ctr_id)
			ON UPDATE CASCADE,
		lh_sdate	DATE,			
		lh_sts_ttl	INTEGER	NOT NULL,	
		lh_enpp		NUMERIC,
		lh_cmt		TEXT,	
		lh_src		TEXT,	
		pty_lh_rght	BOOLEAN  
		);
