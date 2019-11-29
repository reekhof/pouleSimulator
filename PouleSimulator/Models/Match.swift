//
//  Match.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 20/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

struct Match {
    let homeTeam: Team
    let awayTeam: Team
    
    var homeGoals: Int = 0
    var awayGoals: Int = 0
    
    init(homeTeam: Team, awayTeam: Team) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
    
    mutating func addHomeGoal() {
        self.homeGoals += 1
    }
    
    mutating func addAwayGoal() {
        self.awayGoals += 1
    }
}

