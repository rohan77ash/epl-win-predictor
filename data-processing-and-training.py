from snowflake.snowpark import Session
from snowflake.snowpark.functions import col
from snowflake.snowpark.types import *
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.ensemble import GradientBoostingClassifier
import joblib

# Connect to snowflake 
connection_parameters = {
     "account": "<account_name>",
     "user": "<username>",
     "password": "<password>",
     "role": "<role>",
     "warehouse": "<warehouse>",
     "database": "<database>",
     "schema": "<schema>"
 }
session = Session.builder.configs(connection_parameters).create()

# Load data from Snowflake into Snowpark DataFrame
snow_df = session.table("match_features")

# Select required features
snow_df = snow_df.select(
    col("goal_diff"),
    col("total_goals"),
    col("home_form_scored"),
    col("away_form_scored"),
    col("home_form_conceded"),
    col("away_form_conceded"),
    col("result")
)

# Convert to Pandas for sklearn training
df = snow_df.to_pandas()

# Features and target
X = df[["goal_diff","total_goals","home_form_scored","away_form_scored","home_form_conceded","away_form_conceded"]]
y = df["result"]

# Train/test split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Pipeline with GridSearch
pipe = Pipeline([("scaler", StandardScaler()), ("model", GradientBoostingClassifier())])
param_grid = {"model__n_estimators": [50, 100, 200]}
grid = GridSearchCV(pipe, param_grid=param_grid, cv=3)
grid.fit(X_train, y_train)

# Train final model with best parameters
best_param = grid.best_params_
final_model = GradientBoostingClassifier(n_estimators=best_param["model__n_estimators"])
final_model.fit(X_train, y_train)

# Save model locally
joblib.dump(final_model, "/tmp/epl_model.pkl")

# Upload model to Snowflake stage
session.file.put("/tmp/epl_model.pkl", "@model_stage", auto_compress=False)

print("Model trained and saved to @model_stage")
