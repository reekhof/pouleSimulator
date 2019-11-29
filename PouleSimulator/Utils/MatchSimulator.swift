//
//  MatchSimulator.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 21/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//
//  The MatchSimulator simulates a match
//  A match of 90 minutes is simulated. Every minute there can be a possible goal chance
//
//  How does a goal chance arise?
//  - First we check which team is in possesion of the ball by comparing team strength
//  - Then we check if the midfield can reach the attackers
//  - Then we check if the attackers can successfully pass the defence and shoot on goal
//  - Lastly we check if the goal keeper has a save
//  - If any of these checks fail, we go to the next minute to try again
//  - If all checks are passed, GOAL!

import Foundation

protocol MatchSimulatorDelegate: class {
    func matchSimulator(_ sim: MatchSimulator, didUpdateMatch match: Match)
    func matchMinute(_ sim: MatchSimulator, minute: Int)
}

class MatchSimulator {
    private var match: Match
    private weak var delegate: MatchSimulatorDelegate?
    private var currentMinute = 0
    private var timer: Timer!
    
    init(_ match: Match, delegate: MatchSimulatorDelegate) {
        self.match = match
        self.delegate = delegate
    }
    
    func simulateMatch() -> Void {
        print("Start match!")
        
        timer = Timer.scheduledTimer(
            timeInterval: 0.5,
            target: self,
            selector: Selector(("simulateMatchMinuteWithTimer")),
            userInfo: nil,
            repeats: true
        )
        
        timer!.fire()
    }
    
    func stopMatchTimer() -> Void {
        timer!.invalidate()
    }
    
    // simulate the remainder of the match
    func fastForwardMatch() -> Void {
        stopMatchTimer()
        
        guard currentMinute < 90 else {
            return
        }
        
        for _ in currentMinute...89 {
            simulateMatchMinute()
            addMatchMinute()
        }
    }
    
    // simulate a match minute with a guard on the timer
    @objc func simulateMatchMinuteWithTimer() -> Void {

        guard currentMinute < 91 else {
            timer!.invalidate()
            return
        }
        
        simulateMatchMinute()
        addMatchMinute()
    }
    
    private func simulateMatchMinute() -> Void {
        let homeTeam = match.homeTeam
        let awayTeam = match.awayTeam
        
        // Which team has possession of the ball?
        let teamInPossession = getTeamInPosession(homeTeam: homeTeam, awayTeam:  awayTeam)
        
        // Can we reach the attackers?
        if !self.didActionSucceed(teamInPossession: teamInPossession, homeStat: homeTeam.midfield, awayStat: awayTeam.midfield ) {
            print("Attack deverted")
        }
         
        // Can we pass the defence?
        else if !self.didActionSucceed(teamInPossession: teamInPossession, homeStat: homeTeam.attack, awayStat: awayTeam.defence ) {
            print("Defence interrupted")
        }
        
        // Does the keeper save?
        else if !self.didActionSucceed(teamInPossession: teamInPossession, homeStat: homeTeam.attack, awayStat: awayTeam.goalkeeper ) {
            print("Goalkeeper saves!")
        }
            
        // GOLAZOOOO!
        else {
            notifyMatchUpdate(teamInPossionName: teamInPossession.name)
        }
    }
    
    private func addMatchMinute() -> Void {
        currentMinute += 1
        delegate?.matchMinute(self, minute: currentMinute)
    }
    
    // determines which team has possession of the ball
    private func getTeamInPosession(homeTeam: Team, awayTeam: Team) -> Team {
        let homeTeamAverage = getTeamAverage(homeTeam.attack, homeTeam.midfield, homeTeam.defence)
        let awayTeamAverage = getTeamAverage(awayTeam.attack, awayTeam.midfield, awayTeam.defence)
        
        let homePosession = addRandomness(homeTeamAverage)
        let awayPosession = addRandomness(awayTeamAverage)
        
        return homePosession > awayPosession ? homeTeam : awayTeam
    }
    
    // determines if the action is succesfull (set up attack, pass defence, keeper saves)
    private func didActionSucceed(teamInPossession: Team, homeStat: Int, awayStat: Int) -> Bool {
        var homeStatWithRandomness: Int
        var awayStatWithRandomness: Int
        var passed = 0
        repeat {
            passed += 1
            homeStatWithRandomness = addRandomness(homeStat)
            awayStatWithRandomness = addRandomness(awayStat)
        } while self.strengthCheck(teamInPosession: teamInPossession, homeStat: homeStatWithRandomness, awayStat: awayStatWithRandomness) && passed < 3
        
        return passed == 3
    }
    
    private func getTeamAverage(_ attack: Int,_ midfield: Int,_ defence: Int) -> Int {
        return (attack + midfield + midfield) / 3
    }
    
    // checks if the team is posession is also the stronger team
    private func strengthCheck(teamInPosession: Team, homeStat: Int, awayStat: Int) -> Bool {
        let strongerTeam = homeStat > awayStat ? match.homeTeam : match.awayTeam
        return teamInPosession.name == strongerTeam.name
    }
    
    // the ball is round so anything can happen!
    private func addRandomness(_ teamStatistic: Int) -> Int {
        return teamStatistic + Int.random(in: 0...Constants.randomnessFactor)
    }
    
    // delegate the match if an update has happened (goal scored)
    private func notifyMatchUpdate(teamInPossionName: String) -> Void {
        print("GOLAZOOOO")
        
        if teamInPossionName == match.homeTeam.name {
            match.addHomeGoal()
        } else {
            match.addAwayGoal()
        }
        
        delegate?.matchSimulator(self, didUpdateMatch: match)
    }
}
