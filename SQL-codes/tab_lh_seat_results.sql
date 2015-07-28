CREATE TABLE config_data.lh_seat_results (
		lhsres_id	NUMERIC(5)	PRIMARY KEY,
		lhelc_id	NUMERIC(5)
			REFERENCES config_data.lower_house(lh_id)
			ON UPDATE CASCADE,
		pty_id		NUMERIC(5)
			REFERENCES config_data.party(pty_id)
			ON UPDATE CASCADE,
		pty_lh_sts_pr	INTEGER	DEFAULT NULL,
		pty_lh_sts_pl	INTEGER	DEFAULT NULL,
		pty_lh_sts	INTEGER,
		lhvres_cmt	TEXT,	
		lhvres_src	TEXT
		);
