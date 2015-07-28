CREATE TABLE config_data.lh_vote_results (
		lhvres_id	NUMERIC(5)	PRIMARY KEY,
		lhelc_id	NUMERIC(5)
			REFERENCES config_data.lower_house(lh_id)
			ON UPDATE CASCADE,
		pty_id		NUMERIC(5)
			REFERENCES config_data.party(pty_id)
			ON UPDATE CASCADE,
		pty_lh_vts_pr	INTEGER	DEFAULT NULL,
		pty_lh_vts_pl	INTEGER	DEFAULT NULL,
		lhvres_cmt	TEXT,	
		lhvres_src	TEXT	
		);
