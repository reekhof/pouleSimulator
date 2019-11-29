//
//  Round.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 20/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

struct Round {
    var matches: [Match] = []
    
    init(_ matchOne: Match, _ matchTwo: Match) {
        //matches = [matchOne, matchTwo]
        
        self.matches.append(matchOne)
        self.matches.append(matchTwo)
    }
}
