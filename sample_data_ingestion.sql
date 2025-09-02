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


create stage int_stg_sample_data;

copy into epl_raw
from @int_stg_sample_data/epl_data/
file_format = (TYPE = CSV FIELD_OPTIONALLY_ENCLOSED_BY='"' SKIP_HEADER=1);
