CREATE OR REPLACE PROCEDURE predict_match_result(match_num INT)
RETURNS TABLE (
    match_number INT,
    home_team STRING,
    away_team STRING,
    home_win_prob FLOAT,
    draw_prob FLOAT,
    away_win_prob FLOAT
)
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-snowpark-python','pandas','scikit-learn','joblib')
HANDLER = 'run'
IMPORTS = ('@model_stage/epl_model.pkl')
AS
$$
import joblib
import pandas as pd

def run(session, match_num: int):
    # Load trained model
    model = joblib.load("epl_model.pkl")

    # Get features for the requested match
    fixtures_df = session.table("upcoming_fixtures_features") \
                         .filter(f"match_number = {match_num}") \
                         .to_pandas()

    if fixtures_df.empty:
        return pd.DataFrame([], columns=["match_number","home_team","away_team","home_win_prob","draw_prob","away_win_prob"])

    # Predict probabilities
    probs = model.predict_proba(fixtures_df.drop(columns=["match_number","home_team","away_team"]))[0]
    classes = model.classes_

    # Initialize
    home_p, draw_p, away_p = 0, 0, 0

    # Assign based on class labels
    for cls, prob in zip(classes, probs):
        if cls == "H":
            home_p = round(float(prob) * 100, 2)
        elif cls == "D":
            draw_p = round(float(prob) * 100, 2)
        elif cls == "A":
            away_p = round(float(prob) * 100, 2)

    # Build clean result row
    result = pd.DataFrame([{
        "match_number": int(fixtures_df.iloc[0]["match_number"]),
        "home_team": fixtures_df.iloc[0]["home_team"],
        "away_team": fixtures_df.iloc[0]["away_team"],
        "home_win_prob": home_p,
        "draw_prob": draw_p,
        "away_win_prob": away_p
    }])

    return result
$$;
