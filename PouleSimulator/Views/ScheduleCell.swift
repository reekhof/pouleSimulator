//
//  ScheduleCell.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 23/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {
    
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var homeTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLogo: UIImageView!
    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var homeTeamGoals: UILabel!
    @IBOutlet weak var awayTeamGoals: UILabel!
    
    func setMatch(match: Match, didPlayMatch: Bool) {
        homeTeamGoals.isHidden = !didPlayMatch
        awayTeamGoals.isHidden = !didPlayMatch
        
        homeTeamLabel.text = match.homeTeam.name.prefix(3).uppercased()
        homeTeamLogo.image = UIImage(named: match.homeTeam.imageName)
        awayTeamLogo.image = UIImage(named: match.awayTeam.imageName)
        awayTeamLabel.text = match.awayTeam.name.prefix(3).uppercased()
        homeTeamGoals.text = "\(match.homeGoals)"
        awayTeamGoals.text = "\(match.awayGoals)"
    }

}
