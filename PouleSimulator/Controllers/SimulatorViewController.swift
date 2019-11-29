//
//  SimulatorViewController.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 23/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

import AVFoundation
import UIKit

protocol SimulatorViewControllerDelegate: class {
    func simulatorViewController(_ viewController: SimulatorViewController, didSimulateRound round: Round?)
}

class SimulatorViewController: UIViewController {
    @IBOutlet weak var homeTeamLogoMatchOne: UIImageView!
    @IBOutlet weak var homeTeamNameLabelMatchOne: UILabel!
    @IBOutlet weak var homeGoalsLabelMatchOne: UILabel!
    
    @IBOutlet weak var awayTeamLogoMatchOne: UIImageView!
    @IBOutlet weak var awayTeamNameLabelMatchOne: UILabel!
    @IBOutlet weak var awayGoalsLabelMatchOne: UILabel!
    
    @IBOutlet weak var homeTeamLogoMatchTwo: UIImageView!
    @IBOutlet weak var homeTeamNameLabelMatchTwo: UILabel!
    @IBOutlet weak var homeGoalsLabelMatchTwo: UILabel!
    
    @IBOutlet weak var awayTeamLogoMatchTwo: UIImageView!
    @IBOutlet weak var awayTeamNameLabelMatchTwo: UILabel!
    @IBOutlet weak var awayGoalsLabelMatchTwo: UILabel!
    
    @IBOutlet weak var matchMinuteLabel: UILabel!
    
    @IBOutlet weak var playMatchButton: UIButton!
    @IBOutlet weak var skipMatchButton: UIButton!
    
    var round: Round?
    
    private var homeTeamMatchOne: Team?
    private var awayTeamMatchOne: Team?
    private var hometeamMatchTwo: Team?
    private var awayTeamMatchTwo: Team?
    
    private var didSimulateRound = false
    private var didRoundFinish = false
    private var simulators: [MatchSimulator] = []
    
    weak var delegate: SimulatorViewControllerDelegate?
    
    override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        setButtonsVisibility(didStartPlaying: false)
        
        setupView()
    }
    
    @IBAction func skipMatchButton(_ sender: Any) -> Void {
        simulators.forEach { $0.fastForwardMatch() }
        skipMatchButton.isEnabled = false
    }
    
    @IBAction func simulateRound(_ sender: Any) -> Void {
        guard !didSimulateRound else { return }
        
        setButtonsVisibility(didStartPlaying: true)
        
        simulators = round!.matches.map { MatchSimulator($0, delegate: self) }
        simulators.forEach { $0.simulateMatch() }
                
        didSimulateRound = true
    }
    
    @IBAction func goBack(_ sender: Any) -> Void {
        simulators.forEach { $0.fastForwardMatch() }
        
        delegate?.simulatorViewController(self, didSimulateRound: didSimulateRound ? round : nil)
    }
    
    private func setButtonsVisibility(didStartPlaying: Bool) -> Void {
        playMatchButton.isHidden = didStartPlaying
        skipMatchButton.isHidden = !didStartPlaying
    }
    
    private func setupView() -> Void {
        homeTeamMatchOne = round?.matches[0].homeTeam
        awayTeamMatchOne = round?.matches[0].awayTeam
        hometeamMatchTwo = round?.matches[1].homeTeam
        awayTeamMatchTwo = round?.matches[1].awayTeam
        
        // Do any additional setup after loading the view.
        homeTeamLogoMatchOne?.image = UIImage(named: homeTeamMatchOne!.imageName)
        homeTeamNameLabelMatchOne?.text = homeTeamMatchOne!.name.prefix(3).uppercased()
        homeGoalsLabelMatchOne?.text = String(round!.matches[0].homeGoals)
        
        awayTeamLogoMatchOne?.image = UIImage(named: awayTeamMatchOne!.imageName)
        awayTeamNameLabelMatchOne?.text = awayTeamMatchOne!.name.prefix(3).uppercased()
        awayGoalsLabelMatchOne?.text = String(round!.matches[0].awayGoals)
        
        homeTeamLogoMatchTwo?.image = UIImage(named: hometeamMatchTwo!.imageName)
        homeTeamNameLabelMatchTwo?.text = hometeamMatchTwo!.name.prefix(3).uppercased()
        homeGoalsLabelMatchTwo?.text = String(round!.matches[1].homeGoals)
        
        awayTeamLogoMatchTwo?.image = UIImage(named: awayTeamMatchTwo!.imageName)
        awayTeamNameLabelMatchTwo?.text = awayTeamMatchTwo!.name.prefix(3).uppercased()
        awayGoalsLabelMatchTwo?.text = String(round!.matches[1].awayGoals)
    }
    
    private func updateGoalLabels(_ match: Match) -> Void {
        
        //determine which match is updated and update the labels
        if homeTeamMatchOne!.name == match.homeTeam.name {
            homeGoalsLabelMatchOne.text = String(match.homeGoals)
            awayGoalsLabelMatchOne.text = String(match.awayGoals)
            
            animateScoringTeamLogo(updatedMatch: match, oldMatch: round!.matches[0], homeLogo: homeTeamLogoMatchOne, awayLogo: awayTeamLogoMatchOne)
            
            round?.matches[0] = match
        } else {
            homeGoalsLabelMatchTwo.text = String(match.homeGoals)
            awayGoalsLabelMatchTwo.text = String(match.awayGoals)
            
            animateScoringTeamLogo(updatedMatch: match, oldMatch: round!.matches[1], homeLogo: homeTeamLogoMatchTwo, awayLogo: awayTeamLogoMatchTwo)
            
            round?.matches[1] = match
        }
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    private func fastForwardMatch() -> Void {
        simulators.forEach { $0.fastForwardMatch() }
    }
    
    private func animateScoringTeamLogo(updatedMatch: Match, oldMatch: Match, homeLogo: UIImageView, awayLogo: UIImageView) -> Void {
        if updatedMatch.homeGoals > oldMatch.homeGoals {
            animateLogo(image: homeLogo)
        } else {
            animateLogo(image: awayLogo)
        }
    }
    
    private func animateLogo(image: UIImageView) -> Void {
        image.transform = .init(scaleX: 1.2, y: 1.2)
        
        UIView.animate(withDuration: 0.3) {
            image.transform = .identity
        }
    }
}

extension SimulatorViewController: MatchSimulatorDelegate {
    func matchSimulator(_ sim: MatchSimulator, didUpdateMatch match: Match) -> Void {
        print("match updated", match)
        updateGoalLabels(match)
    }
    
    func matchMinute(_ sim: MatchSimulator, minute: Int) -> Void {
        // update minute label
        matchMinuteLabel.text = "\(minute)"
    }
}
