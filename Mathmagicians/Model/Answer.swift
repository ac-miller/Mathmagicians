//
//  Answer.swift
//  Mathmagicians
//
//  Created by Aaron Miller on 10/27/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import Foundation

class Answer : Codable {
    var questionID: Int16?
    var answerText: String?
    var correct: Bool?
    
    enum CodingKeys: String, CodingKey {
        case questionID = "QuestionID"
        case answerText = "AnswerText"
        case correct = "Correct"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.questionID = try container.decode(Int16.self, forKey: .questionID)
        self.answerText = try container.decode(String.self, forKey: .answerText)
        self.correct = try container.decode(Bool.self, forKey: .correct)
        
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.questionID, forKey: .questionID)
        try container.encode(self.answerText, forKey: .answerText)
        try container.encode(self.correct, forKey: .correct)
    }
}
