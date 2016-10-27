CREATE TABLE config_data.electoral_alliances(
		ctr_id		SMALLINT
			REFERENCES config_data.country(ctr_id)
			ON UPDATE CASCADE,
		pty_id		NUMERIC(5)
			REFERENCES config_data.party(pty_id)
			ON UPDATE CASCADE,
		pty_abr		VARCHAR(50),
		pty_eal_nbr	INTEGER,
		pty_eal_id	NUMERIC(5),
		pty_eal_cmt	TEXT,
		pty_eal_src	TEXT
);
