//
//  TeamResult.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 20/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

class TeamResult {
    let team: Team
    var played = 0
    var wins = 0
    var losses = 0
    var ties = 0
    var goalsFor = 0
    var goalsAgainst = 0
    var goalDifference = 0
    var points = 0
    var wonFromTeams: [String] = []
    
    init(_ team: Team) {
        self.team = team
    }
    
    func addResult(goalsFor: Int, goalsAgainst: Int, opponent: String) {
        self.played += 1
        self.goalsFor += goalsFor
        self.goalsAgainst += goalsAgainst
        self.goalDifference = self.goalsFor - self.goalsAgainst
        
        // Result of the match is a win!
        if goalsFor > goalsAgainst {
            addWinResult(opponent)
        }
        
        // Result of the match is a tie!
        if goalsFor == goalsAgainst {
            addTieResult()
        }
        
        // Result of the match is a loss!
        if goalsFor < goalsAgainst {
            addLossResult()
        }
    }
    
    private func addWinResult(_ opponent: String) {
        self.wins += 1
        self.points += Constants.pointsForWin
        self.wonFromTeams.append(opponent)
    }

    private func addTieResult() {
        self.ties += 1
        self.points += Constants.pointsForTie
    }

    private func addLossResult() {
        self.losses += 1
        self.points += Constants.pointsForLoss
    }
}

