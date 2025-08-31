CREATE OR REPLACE TABLE EPL_RAW (
    Season STRING,
    Date DATE,
    HomeTeam STRING,
    AwayTeam STRING,
    FTHG INT,   -- Full Time Home Goals
    FTAG INT,   -- Full Time Away Goals
    FTR STRING, -- Full Time Result (H/D/A)
    HST INT,    -- Home Shots on Target
    AST INT,    -- Away Shots on Target
    HC INT,     -- Home Corners
    AC INT,     -- Away Corners
    HF INT,     -- Home Fouls
    AF INT      -- Away Fouls
);

COPY INTO EPL_RAW
FROM @my_stage/epl_data/
FILE_FORMAT = (TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);
