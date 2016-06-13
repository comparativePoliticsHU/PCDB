CREATE TABLE config_data.cabinet_portfolios (
		ptf_id		NUMERIC(5)	PRIMARY KEY,
		cab_id		NUMERIC(5)	
			REFERENCES config_data.cabinet(cab_id)
			ON UPDATE CASCADE,
		pty_id		NUMERIC(5)
			REFERENCES config_data.party(pty_id)
			ON UPDATE CASCADE,
		pty_cab		BOOLEAN	,
		pty_cab_sts	INTEGER	,
		pty_cab_hog	BOOLEAN	,
		pty_cab_sup	BOOLEAN	,
		ptf_cmt		TEXT	,
		ptf_src		TEXT	
		);
