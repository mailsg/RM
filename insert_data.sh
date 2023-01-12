#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
    if [ "$winner" != "winner" ] && [ "$opponent" != "opponent" ] 
    then
        echo "$winner"
        echo "$opponent"
    fi
done < games.csv | sort -u | while read team 
do 
    echo $($PSQL "INSERT INTO teams(name) VALUES('$team')")
done


cat games.csv | while IFS="," read -r year round winner opponent winner_goals opponent_goals
do
    if [ "$year" != "year" ] && [ "$round" != "round" ] && [ "$winner" != "winner" ] && [ "$opponent" != "opponent" ] && [ "$winner_goals" != "winner_goals" ] && [ "$opponent_goals" != "opponent_goals" ]
    then
        # echo "$year"
        # echo "$round"
        # echo "$winner"
        # echo "$opponent"
        # echo "$winner_goals"
        # echo "$opponent_goals"
        # INSERT INTO games(year, round, winner_id, opponent_id, winner_goals,opponent_goals) VALUES($year, '$round',  )

        # GET WINNER ID
        WINNER_ID=$($PSQL "SELECT team_id from teams where name = '$winner'")
        
        # GET OPPONENT ID
        OPPONENT_ID=$($PSQL "SELECT team_id from teams where name = '$opponent'")
        # echo $WINNER_ID $OPPONENT_ID

        INSERT_TEAM=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
                                         VALUES($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)")
        echo $INSERT_TEAM

    fi
done

