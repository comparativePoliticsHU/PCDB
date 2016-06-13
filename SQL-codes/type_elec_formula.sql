CREATE TYPE elec_formula AS ENUM (
	'2RS', -- Two Round System
	'AV', -- Alternative Vote
	'DHondt',
	'Droop',
	'LR-Droop', -- Droop w/ Largest Remainders
	'Hare',
	'modified Hare',
	'LR-Hare', -- Hare w/ Largest Remainders
	'highest average remaining',
	'Imperiali',
	'MMD', -- Multi-Member District
	'mSainteLague',
	'Reinforced Imperiali',
	'SainteLague', 
	'SMP', -- Single Member Plurality
	'SNTV', -- Single Non-Transferable Vote
	'STV' -- Single Transferable Vote
	);