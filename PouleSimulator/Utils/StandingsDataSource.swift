//
//  StandingsDataSource.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 25/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//
//  DataSource for tableViews making use of the standings data

import Foundation
import UIKit

class StandingsDataSource: NSObject, UITableViewDataSource {
    weak var delegate: PouleProvider?
    
    init(delegate: PouleProvider) {
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let poule = delegate?.getActivePoule() else { fatalError() }
        
        return poule.standing.getSortedStanding().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let poule = delegate?.getActivePoule() else { fatalError() }
        
        let standingRow = poule.standing.getSortedStanding()[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StandingsCell") as! StandingsCell
        cell.setTeamResult(result: standingRow, position: indexPath.row + 1)
        
        return cell
    }
}
