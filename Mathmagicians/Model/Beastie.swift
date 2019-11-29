//
//  Beastie.swift
//  Description: Defining the rendering of beasties based on selection by levels selected
//               by the user on the map page
//
//  
//  Copyright © 2019 Mathmagicians. All rights reserved.
//

import Foundation

class Beastie : Codable {
    var imageOnMap: String?
    var arImagePath: String?
    
    //defing the path to get the beasties
    enum CodingKeys: String, CodingKey {
        case imageOnMap = "imageOnMap"
        case arImagePath = "arImagePath"
    }
    //initializing
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
