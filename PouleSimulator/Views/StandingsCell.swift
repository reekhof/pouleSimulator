//
//  StandingsCell.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 23/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

import UIKit

class StandingsCell: UITableViewCell {

    @IBOutlet weak var teamLogoImage: UIImageView!
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var matchesPlayedLabel: UILabel!
    @IBOutlet weak var matchesWonLabel: UILabel!
    @IBOutlet weak var matchesTiedLabel: UILabel!
    @IBOutlet weak var matchesLostLabel: UILabel!
    @IBOutlet weak var goalsForLabel: UILabel!
    @IBOutlet weak var goalsAgainstLabel: UILabel!
    @IBOutlet weak var goalDifferenceLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    func setTeamResult(result: TeamResult, position: Int) {
        teamLogoImage.image = UIImage(named: result.team.imageName)
        
        positionLabel.text = String(position)
        matchesPlayedLabel.text = String(result.played)
        matchesWonLabel.text = String(result.wins)
        matchesTiedLabel.text = String(result.ties)
        matchesLostLabel.text = String(result.losses)  // "\(result.losses)"
        goalsForLabel.text = String(result.goalsFor)
        goalsAgainstLabel.text = String(result.goalsAgainst)
        goalDifferenceLabel.text = String(result.goalDifference)
        pointsLabel.text = String(result.points)
        
        // Show that these team are now in position to go to the next phase of the tournament
        if position < 3 {
            positionLabel.font = UIFont.boldSystemFont(ofSize: 17)
            positionLabel.textColor = UIColor.black
        }
        
        else {
            positionLabel.textColor = UIColor.darkGray
        }
         
    }
    
}
