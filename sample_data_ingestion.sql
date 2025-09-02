--stage for sample data 
create stage int_stg_sample_data;

-- raw data table
create or replace table epl_raw (
    season string,
    date date,
    hometeam string,
    awayteam string,
    fthg int,   -- full time home goals
    ftag int,   -- full time away goals
    ftr string, -- full time result (h/d/a)
    hst int,    -- home shots on target
    ast int,    -- away shots on target
    hc int,     -- home corners
    ac int,     -- away corners
    hf int,     -- home fouls
    af int      -- away fouls
);

--custom file format
create file format football_csv_format
type = 'csv'
field_optionally_enclosed_by = '"'
skip_header = 1
null_if = ('','null');

--ingest into base table
copy into epl_raw
from @int_stg_sample_data/epl_data/
file_format = (format_name = ''football_csv_format'')
purge = 'TRUE';

-- final table
create or replace table match_features as
select
    season,
    date,
    hometeam,
    awayteam,
    fthg,
    ftag,
    ftr,
    hst,
    ast,
    hc,
    ac,
    hf,
    af,
    (hst - ast) as shots_diff,
    (hc - ac) as corners_diff,
    (hf - af) as fouls_diff
from epl_raw;

-- stage for keeping trained model
create stage model_stage;
