CREATE TABLE config_data.upper_house (
		uh_id		NUMERIC(5)	PRIMARY KEY,
		uh_prv_id	NUMERIC(5),
		uhelc_id	NUMERIC(5)
			REFERENCES config_data.uh_election
			MATCH SIMPLE
			ON UPDATE CASCADE,
		ctr_id		SMALLINT
			REFERENCES config_data.country(ctr_id)
			ON UPDATE CASCADE,
		uh_sdate	DATE,
		uh_sts_ttl	INTEGER	NOT NULL,
		uh_cmt		TEXT,
		uh_src		TEXT
		);
