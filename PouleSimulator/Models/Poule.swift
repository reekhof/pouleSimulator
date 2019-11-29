//
//  Poule.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 20/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

// declare variables private so its not a singleton?? 
class Poule {
    let teams: [Team]
    var schedule: Schedule
    var standing: Standing
    
    init(teams: [Team], schedule: Schedule, standing: Standing) {
        self.teams = teams
        self.schedule = schedule
        self.standing = standing
    }
    
    func updateStandings(_ standing: Standing) {
        self.standing = standing
    }
    
    func updateScheduleWithPlayedRound(roundIndex: Int, round: Round) {
        self.schedule.rounds[roundIndex] = round
    }
}

