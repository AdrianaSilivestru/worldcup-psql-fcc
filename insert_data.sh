#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
  #check if winner is not already in teams table
  WINNER_EXISTS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_EXISTS ]]
    then
      #insert winner in teams names
      INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER') ")
    fi
  fi
  if [[ $OPPONENT != 'opponent' ]]
  then
    #check if opponent is not already in teams table
    OPPONENT_EXISTS=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_EXISTS ]]
    then
      #insert opponent in teams names
      INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT') ")
    fi
  fi

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  if [[ $YEAR != 'year' && $ROUND != 'round' && $WIN_GOALS != 'winner_goals' && $OPP_GOALS != 'opponent_goals' ]]
  then
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WIN_GOALS, $OPP_GOALS)")
  fi
  #echo $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WIN_GOALS, $OPP_GOALS

done
