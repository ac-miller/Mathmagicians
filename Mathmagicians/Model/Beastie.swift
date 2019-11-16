//
//  Beastie.swift
//  Mathmagicians
//
//  Created by Aaron Miller on 10/31/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import Foundation

class Beastie : Codable {
    var imageOnMap: String?
    var arImagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case imageOnMap = "imageOnMap"
        case arImagePath = "arImagePath"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imageOnMap = try container.decode(String.self, forKey: .imageOnMap)
        self.arImagePath = try container.decode(String.self, forKey: .arImagePath)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.imageOnMap, forKey: .imageOnMap)
        try container.encode(self.arImagePath, forKey: .arImagePath)
    }
}
