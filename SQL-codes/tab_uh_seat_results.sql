CREATE TABLE config_data.uh_seat_results (
		uhsres_id	NUMERIC(5)	PRIMARY KEY,
		uh_id	NUMERIC(5)
			REFERENCES config_data.upper_house(uh_id)
			ON UPDATE CASCADE,
		pty_id		NUMERIC(5)
			REFERENCES config_data.party(pty_id)
			ON UPDATE CASCADE,
		pty_uh_sts_elc	NUMERIC,
		pty_uh_sts	NUMERIC NOT NULL,
		uhsres_cmt	TEXT,
		uhsres_src	TEXT
		);
