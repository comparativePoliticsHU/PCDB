CREATE TABLE config_data.presidential_election (
		prselc_id	NUMERIC(5)	PRIMARY KEY,
		prselc_prv_id	NUMERIC(5),
		ctr_id		SMALLINT
			REFERENCES config_data.country(ctr_id)
			ON UPDATE CASCADE,
		prselc_date		DATE,
		prselc_rnd_ttl		SMALLINT DEFAULT ('1'),
		prselc_vts_clg		NUMERIC,
		reg_vts_prselc_r1	NUMERIC,
		reg_vts_prselc_r2	NUMERIC	DEFAULT NULL,
		prselc_vts_ppl_r1	NUMERIC,
		prselc_vts_ppl_r2	NUMERIC DEFAULT NULL,
		prselc_clg		BOOLEAN,
		prs_n		NAME,
		pty_id		NUMERIC(5)
			REFERENCES config_data.party(pty_id)
			ON UPDATE CASCADE,
		prs_sdate	DATE,
		prselc_cmt	TEXT,
		prselc_src	TEXT
		);
