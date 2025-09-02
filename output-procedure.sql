create or replace function predict_match(
    home_team string,
    away_team string,
    home_wins int,
    home_draws int,
    home_losses int,
    away_wins int,
    away_draws int,
    away_losses int,
    home_goals_scored int,
    home_goals_conceded int,
    away_goals_scored int,
    away_goals_conceded int
)
returns object
language python
runtime_version = '3.10'
packages = ('scikit-learn','pandas')
imports = ('@model_stage/epl_model.pkl')
handler = 'predict'
as
$$
import pickle
import pandas as pd

# load trained model
with open("epl_model.pkl", "rb") as f:
    model = pickle.load(f)

def predict(home_team, away_team,
            home_wins, home_draws, home_losses,
            away_wins, away_draws, away_losses,
            home_goals_scored, home_goals_conceded,
            away_goals_scored, away_goals_conceded):

    # construct input features from arguments
    features = pd.DataFrame([{
        "home_wins": home_wins,
        "home_draws": home_draws,
        "home_losses": home_losses,
        "away_wins": away_wins,
        "away_draws": away_draws,
        "away_losses": away_losses,
        "home_goals_scored": home_goals_scored,
        "home_goals_conceded": home_goals_conceded,
        "away_goals_scored": away_goals_scored,
        "away_goals_conceded": away_goals_conceded
    }])

    # get probabilities
    probs = model.predict_proba(features)[0]

    return {
        "home_team": home_team,
        "away_team": away_team,
        "home_win_prob": float(probs[0]),
        "draw_prob": float(probs[1]),
        "away_win_prob": float(probs[2])
    }
$$;




call select predict_match(
    'Home team', 'Away Team',
    home wins, draws, losses,
    away wins, draws, losses,
    home goals scored, conceded,
    away goals scored, conceded
);

