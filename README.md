# English Premier League football match outcome prediction

This project predicts football match outcomes using historical EPL data.  
It extracts features with SQL in Snowflake, trains a model allowing users to query predictions by calling a function.

---

## Workflow
1. **Sample data ingestion** (`sample_data_ingestion.sql`)
   - Downloaded historical data from  [recent data for EPL](https://www.football-data.co.uk/englandm.php) > premier league, for each year
   - Upload to stage for ingestion, custom file format used depending on the data source
   - Creates the base table (`epl_raw`) from raw match data and final table (`epl_features`) in Snowflake.
   - Custom file format is needed based on the data. 

3. **Model Training** (`data-processing-and-training.py`)
   - Connects to snowflake using snowpark  
   - Extracts data from Snowflake  
   - Scales features  
   - Uses GridSearchCV for tuning, finding best parameters for training
   - Trains a Gradient Boosting model using most suitable parameters on historical seasons' stats
   - uploads trained model in stage

4. **Prediction** (`output-procedure.sql`)  
   - Creates a udf using the uploaded model and gives results based on the arguments passed (this season's stats so far)
   - Returns win/draw/loss probability


