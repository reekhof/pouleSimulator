# Poule Simulator
The Poule Simulator is an iOS app I created for the code assessment of Gamebasics.
The app simulates a Champions League poule with the teams: Feyenoord (my favorite club), FAA Gent, Valencia & Liverpool

## Summary

# Views
The main view is a overview of the poule standings and the schedule of the next matches. 
The result of the matches that are played are processed into the standings and the schedule.
On the main view there is a button that leads to the simulation view.

The second view is the simulation of a round, that consists of 2 matches. 
On this view the simulation can be started. On first instance the simulation is played match minute to minute (one minute in the simulation is 0.5 second real-time)
When the simulation is started it can be skipped to the end result, for the impatient users. 
When the user navigates back to the standings, the results are processed.

# Models
The poule consists of a schedule and a standings. The schedule consists of 3 rounds of 2 matches (6 matches total) and a match is between 2 teams. The standings is an ordering of the results of the teams.

# Simulation 
Every team has its own stats for: attack, midfield, defence & goalkeeping. 
These stats plus some randomness determine the outcome of a match. 
A match is simulated by minute and every minute there is a chance of a goal being scored.
To determine if a goal is scored some actions have to succeed: 

- Which team has posession of the ball
- Can the midfield set up an attack and reach the attackers
- Can the attackers pass the defence
- Can the attackers pass the goalkeeper

If all these actions succeed a goal is scored!
