DROP TABLE IF EXISTS beta_version.minister;
CREATE TABLE beta_version.minister (
	min_id	NUMERIC(5,0)	PRIMARY KEY,
	cab_id 		NUMERIC(5,0)
			REFERENCES beta_version.cabinet (cab_id)
			ON UPDATE CASCADE,
	cres_id		NUMERIC(5,0),
	pty_id 		NUMERIC(5,0) 
			REFERENCES beta_version.party (pty_id)
			ON UPDATE CASCADE,
	min_sdate 	DATE,
	min_ttl_nr	SMALLINT,
	min_pty_nr	SMALLINT,
	mltp_off	SMALLINT,
	portfolio_categories	SMALLINT,
	cab_min_ttl	SMALLINT,
	min_pm	SMALLINT,	-- prime minister
	min_dep	SMALLINT,	-- deputy prime minister
	min_faf	SMALLINT,	-- foreign affairs
	min_def	SMALLINT,	-- defence
	min_int	SMALLINT,	-- interior
	min_jus	SMALLINT,	-- justice
	min_fin	SMALLINT,	-- finance
	min_eco	SMALLINT,	-- economic_affairs
	min_lab	SMALLINT,	-- labor
	min_edu	SMALLINT,	-- education
	min_hlth	SMALLINT,	--health
	min_hou	SMALLINT,	--housing
	min_agr	SMALLINT,	-- agriculture
	min_ind	SMALLINT,	-- industry_trade
	min_env	SMALLINT,	-- environment
	min_soc	SMALLINT,	-- social_affairs
	min_pwk	SMALLINT,	-- public_works
	min_oth	SMALLINT,	--other
	min_com	TEXT,	
	min_src	TEXT
)