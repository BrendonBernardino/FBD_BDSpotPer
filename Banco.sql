CREATE DATABASE BDSpotPer
ON
PRIMARY ( --filegroup primário, apenas com 1 file primário
	NAME = 'bdspotper',
	FILENAME = 'C:\BDSpotPer\bdspotper.mdf',
	SIZE= 4096KB,
	FILEGROWTH = 1024KB
),
FILEGROUP bdspotper_fg01( --filegroup com 2 files
	NAME = 'bdspotper_01',
	FILENAME = 'C:\BDSpotPer\bdspotper_01.ndf',
	SIZE= 1024KB,
	FILEGROWTH = 30%
	),
	(
	NAME = 'bdspotper_02',
	FILENAME = 'C:\BDSpotPer\bdspotper_02.ndf',
	SIZE= 1024KB,
	FILEGROWTH = 30%
),
FILEGROUP bdspotper_fg02( --filegroup com apenas 1 file
	NAME = 'bdspotper_03',
	FILENAME = 'C:\BDSpotPer\bdspotper_03.ndf',
	SIZE= 1024KB,
	FILEGROWTH = 30%
)

LOG
ON ( -- arquivo de log
	NAME = 'bdspotper_log',
    FILENAME = 'C:\BDSpotPer\bdspotper_log.ldf',
    SIZE = 1024KB,
    FILEGROWTH = 10%
)