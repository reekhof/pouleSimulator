//
//  Standing.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 20/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

class Standing {
    var results: [TeamResult]
    
    init(_ results: [TeamResult]) {
        self.results = results.sorted(by: {$0.team.name < $1.team.name})
    }
    
    func getSortedStanding() -> [TeamResult] {
        // sort the array by different variables in order:
        // 1. points
        // 2. goalDifference
        // 3. goalsFor
        // 4. goalsAgainst
        // 5. mutual result (wins over the other team)
        return self.results.sorted (by: {
            
            // try to sort by points
            if $0.points != $1.points {
                return $0.points > $1.points
            }

            // try to sort by goalDifference
            else if $0.goalDifference != $1.goalDifference {
                return $0.goalDifference > $1.goalDifference
            }
            
            // try to sort by goalsFor
            else if $0.goalsFor != $1.goalsFor {
                return $0.goalsFor > $1.goalsFor
            }
            
            // try to sort by goalsAgainst
            else if $0.goalsAgainst != $1.goalsAgainst {
                return $0.goalsAgainst > $1.goalsAgainst
            }
            
            // finally sort by mutual result
            else {
                let teamOne = $0.team.name;
                let teamTwo = $1.team.name;
                
//                let teamOneWinsOverTeamTwo = $0.wonFromTeams.reduce(0) { current, team in team == teamTwo ? current + 1 : current }
                
                let teamOneWinsOverTeamTwo = $0.wonFromTeams.filter { (teamname) -> Bool in
                    return teamname == teamTwo
                }.count
                
                let teamTwoWinsOverTeamOne = $1.wonFromTeams.filter { (teamname) -> Bool in
                    return teamname == teamOne
                }.count
                
                return teamOneWinsOverTeamTwo > teamTwoWinsOverTeamOne
            }
            
        })
    }
}
