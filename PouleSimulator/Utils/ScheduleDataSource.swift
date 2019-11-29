//
//  ScheduleDataSource.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 25/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//
//  DataSource for tableViews making use of the standings data

import Foundation
import UIKit

class ScheduleDataSource: NSObject, UITableViewDataSource {
    weak var delegate: PouleProvider?
    
    init(delegate: PouleProvider) {
        self.delegate = delegate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let poule = delegate?.getActivePoule() else { fatalError() }
        
        return poule.schedule.rounds.count * 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let poule = delegate?.getActivePoule() else { fatalError() }
        guard let playedRounds = delegate?.getPlayedRounds() else { fatalError() }
        
        let match = poule.schedule.rounds[(indexPath.row / 2)].matches[indexPath.row % 2]
        
        print("scehdule match updated cell", match)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
        cell.setMatch(match: match, didPlayMatch: didPlaymatch(playedRounds: playedRounds, indexPath: indexPath.row))

        return cell;
    }
    
    private func didPlaymatch(playedRounds: Int, indexPath: Int) -> Bool {
        return playedRounds > 0 && indexPath < playedRounds * 2
    }
}
