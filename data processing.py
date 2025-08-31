import snowflake.snowpark.functions as F

# Load raw table
df = session.table("EPL_RAW")

# Feature engineering
df_features = (
    df.with_column("GoalDiff", F.col("FTHG") - F.col("FTAG"))
      .with_column("HomeWin", F.when(F.col("FTR")=="H",1).otherwise(0))
      .with_column("AwayWin", F.when(F.col("FTR")=="A",1).otherwise(0))
      .with_column("Draw", F.when(F.col("FTR")=="D",1).otherwise(0))
)

# Save processed features
df_features.write.save_as_table("EPL_FEATURES", mode="overwrite")
