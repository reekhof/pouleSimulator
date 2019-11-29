//
//  ViewController.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 19/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    @IBOutlet weak var standingsTableView: UITableView!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var simulateMatchButton: UIButton!
    @IBOutlet weak var resetPouleButton: UIButton!
    
    private var roundsPlayed = 0
    
    private var championsLeaguePoule: Poule!
    
    private var standingsDataSource: StandingsDataSource!
    private var scheduleDataSource: ScheduleDataSource!
    
    override func viewDidLoad() -> Void {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        standingsDataSource = StandingsDataSource(delegate: self)
        scheduleDataSource = ScheduleDataSource(delegate: self)
        
        standingsTableView.dataSource = standingsDataSource
        scheduleTableView.dataSource = scheduleDataSource
        
        // The Poule we create exists of 3 rounds of 2 matches
        championsLeaguePoule = createChampionLeaguePoule()
    }
    
    @IBAction func presentSimulator(_ sender: Any) -> Void {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainNavigationVC = mainStoryBoard.instantiateViewController(identifier: "MainNavigationController") as? MainNavigationController else {
            return
        }
        
        if let simulatorVC = mainNavigationVC.children.first as? SimulatorViewController {
            guard roundsPlayed < 3 else { return }
            
            simulatorVC.round = championsLeaguePoule.schedule.rounds[roundsPlayed]
            simulatorVC.delegate = self
        }
        
        present(mainNavigationVC, animated: true, completion: nil)
    }
    
    @IBAction func resetPoule(_ sender: Any) -> Void {
        resetRoundsPlayed()
        championsLeaguePoule = createChampionLeaguePoule()
        setButtonsVisibility(didPouleEnd: false)
        updateTableViews()
    }
    
    private func setButtonsVisibility(didPouleEnd: Bool) {
        simulateMatchButton.isHidden = didPouleEnd
        resetPouleButton.isHidden = !didPouleEnd
    }
    
    private func createChampionLeaguePoule() -> Poule {
        // Create the teams which will participate in the Poule!
        let teamOne = Team(name: "Feyenoord", imageName: "logo_feyenoord", attack: 75, midfield: 73, defence: 74, goalkeeper: 76)
        let teamTwo = Team(name: "Liverpool", imageName: "logo_liverpool", attack: 86, midfield: 83, defence: 84, goalkeeper: 89)
        let teamThree = Team(name: "Valencia CF", imageName: "logo_valencia", attack: 81, midfield: 81, defence: 81, goalkeeper: 83)
        let teamFour = Team(name: "Gent KAA", imageName: "logo_gent", attack: 74, midfield: 74, defence: 73, goalkeeper: 74)
        
        // The Poule we create exists of 3 rounds of 2 matches
        return createPoule(teamOne: teamOne, teamTwo: teamTwo, teamThree: teamThree, teamFour: teamFour)
    }
    
    private func updateTableViews() -> Void {
        standingsTableView.reloadData()
        scheduleTableView.reloadData()
    }
    
    private func createPoule(teamOne: Team, teamTwo: Team, teamThree: Team, teamFour: Team) -> Poule {
        // A Poule requires 4 teams, a schedule and a standing
        
        // Define the schedule
        let schedule = PouleHelper.createSchedule(teamOne, teamTwo, teamThree, teamFour)
        
        // Now we initialize the standing
        let standing = PouleHelper.createStanding(teamOne, teamTwo, teamThree, teamFour)
        
        // And finally we create the Poule
        return Poule(teams: [teamOne, teamOne, teamThree, teamFour], schedule: schedule, standing: standing)
    }
        
    private func updateStanding(_ round: Round) -> Void {
        updatePouleWithMatchResults(round)
        updatePouleScheduleWithPlayedRound(round)
        
        updateTableViews()
    }
    
    private func updatePouleWithMatchResults(_ round: Round) -> Void {
        round.matches.forEach { match in
            let homeTeamResult = championsLeaguePoule.standing.results.first(where: { $0.team.name == match.homeTeam.name })
            let awayTeamResult = championsLeaguePoule.standing.results.first(where: { $0.team.name == match.awayTeam.name })
            
            homeTeamResult?.addResult(goalsFor: match.homeGoals, goalsAgainst: match.awayGoals, opponent: match.awayTeam.name)
            awayTeamResult?.addResult(goalsFor: match.awayGoals, goalsAgainst: match.homeGoals, opponent: match.homeTeam.name)
        }
    }
    
    private func updatePouleScheduleWithPlayedRound(_ round: Round) -> Void {
        championsLeaguePoule.updateScheduleWithPlayedRound(roundIndex: roundsPlayed - 1, round: round)
    }
    
    private func resetRoundsPlayed() {
        roundsPlayed = 0
    }
}

protocol PouleProvider: class {
    func getActivePoule() -> Poule
    func getPlayedRounds() -> Int
}

extension ViewController: PouleProvider {
    func getActivePoule() -> Poule {
        return championsLeaguePoule
    }
    
    func getPlayedRounds() -> Int {
        return roundsPlayed
    }
}

extension ViewController: SimulatorViewControllerDelegate {
    func simulatorViewController(_ viewController: SimulatorViewController, didSimulateRound round: Round?) {
        viewController.dismiss(animated: true, completion: nil)
        
        if let round = round {
            roundsPlayed += 1
            updateStanding(round)
        }
        
        if roundsPlayed == 3 {
            setButtonsVisibility(didPouleEnd: true)
        }
    }
}
