CREATE TABLE config_data.party (
		pty_id		NUMERIC(5)	PRIMARY KEY,
		pty_abr		VARCHAR(10)	UNIQUE NOT NULL,
		pty_n		VARCHAR(45),
		pty_n_en	VARCHAR(45),
		cmp_id		NUMERIC(5),
		prlgv_id	INTEGER,
		pty_eal		INTEGER,
		pty_eal_id	NUMERIC(5),
		ctr_id		SMALLINT	UNIQUE
			REFERENCES config_data.country(ctr_id)
			ON UPDATE CASCADE,
		clea_id		VARCHAR(10),
		pty_cmt		TEXT,
		pty_src		TEXT
);