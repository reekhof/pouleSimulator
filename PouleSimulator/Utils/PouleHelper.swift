//
//  PouleHelper.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 21/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//
//  An Helper to create an entire poule, with an schedule & standing

class PouleHelper {
    static func createSchedule(_ teamOne: Team, _ teamTwo: Team, _ teamThree: Team, _ teamFour: Team) -> Schedule {
        let matchOne = Match(homeTeam: teamOne, awayTeam: teamTwo)
        let matchTwo = Match(homeTeam: teamThree, awayTeam: teamFour)
        let roundOne = Round(matchOne, matchTwo)
        
        let matchThree = Match(homeTeam: teamOne, awayTeam: teamThree)
        let matchFour = Match(homeTeam: teamTwo, awayTeam: teamFour)
        let roundTwo = Round(matchThree, matchFour)
        
        let matchFive = Match(homeTeam: teamFour, awayTeam: teamOne)
        let matchSix = Match(homeTeam: teamTwo, awayTeam: teamThree)
        let roundThree = Round(matchFive, matchSix)
        
        return Schedule(roundOne, roundTwo, roundThree)
    }
    
    static func createStanding(_ teamOne: Team, _ teamTwo: Team, _ teamThree: Team, _ teamFour: Team) -> Standing {
        return Standing([TeamResult(teamOne), TeamResult(teamTwo), TeamResult(teamThree), TeamResult(teamFour)])
    }
}
