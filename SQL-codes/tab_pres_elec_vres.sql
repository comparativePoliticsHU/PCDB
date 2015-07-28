CREATE TABLE config_data.pres_elec_vres (
		prsvres_id	NUMERIC(5)	PRIMARY KEY,
		prselc_id	NUMERIC(5)
			REFERENCES config_data.presidential_election(prselc_id)
			ON UPDATE CASCADE,
		prselc_rnd	SMALLINT,
		prs_cnd_pty	NUMERIC(5)
			REFERENCES config_data.party(pty_id)
			ON UPDATE CASCADE,
		prs_cnd_n	NAME,
		prs_cnd_vts_clg	INTEGER,
		prs_cnd_vts_ppl	INTEGER,
		prsvres_cmt	TEXT,
		prsvres_src	TEXT
);