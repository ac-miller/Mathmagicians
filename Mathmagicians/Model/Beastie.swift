//
//  Beastie.swift
//  Mathmagicians
//
//  Created by Aaron Miller on 10/31/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import Foundation

class Beastie : Codable {
    var difficulty: Int16?
    var name: String?
    var model: String?
    
    enum CodingKeys: String, CodingKey {
        case difficulty = "Difficulty"
        case name = "Name"
        case model = "Model"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.difficulty = try container.decode(Int16.self, forKey: .difficulty)
        self.name = try container.decode(String.self, forKey: .name)
        self.model = try container.decode(String.self, forKey: .model)
        
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.difficulty, forKey: .difficulty)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.model, forKey: .model)
    }
}
