//
//  Schedule.swift
//  PouleSimulator
//
//  Created by Rik Eekhof on 20/11/2019.
//  Copyright © 2019 Rik Eekhof. All rights reserved.
//

struct Schedule {
    var rounds: [Round] = []
    
    init(_ roundOne: Round, _ roundTwo: Round, _ roundThree: Round) {
        self.rounds.append(roundOne)
        self.rounds.append(roundTwo)
        self.rounds.append(roundThree)
    }
}
