CREATE TABLE config_data.uh_election (
		uhelc_id	NUMERIC(5)	PRIMARY KEY,
		uhelc_prv_id	NUMERIC(5),
		ctr_id		SMALLINT
			REFERENCES config_data.country(ctr_id)
			ON UPDATE CASCADE,
		uhelc_date	DATE,
		uh_sts_ttl	INTEGER	NOT NULL,
		uhelc_sts_elc	INTEGER	NOT NULL,
		uhelc_cmt	TEXT,
		uhelc_src	TEXT
		);
