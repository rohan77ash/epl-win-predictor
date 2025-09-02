# English Premier League football match outcome prediction

This project predicts football match outcomes using historical EPL data.  
It extracts features with SQL in Snowflake, trains a model allowing users to query predictions by calling a function.

---

## Workflow
1. **Sample data ingestion** (`sql/create_features.sql`)  
   Builds the base table (`epl_raw`) from raw match data and final table (`epl_features`) in Snowflake. 

2. **Model Training** (`scripts/train_model.py`)  
   - Extracts data from Snowflake  
   - Scales features  
   - Uses GridSearchCV for tuning  
   - Trains a Gradient Boosting model  

3. **Prediction** (`app/predict.py`)  
   - Connects to Snowflake and fetches team matchup features  
   - Calls the trained model  
   - Returns win/draw/loss probability


