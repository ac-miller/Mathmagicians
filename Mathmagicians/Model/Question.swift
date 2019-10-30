//
//  Question.swift
//  Mathmagicians
//
//  Created by Aaron Miller on 10/27/19.
//  Copyright © 2019 Jesse Chan. All rights reserved.
//

import Foundation

class Question : Codable {
    var questionID: Int16?
    var difficulty: Int16?
    var questionText: String?
    var answers: [Answer]?

    enum CodingKeys: String, CodingKey {
        case questionID = "QuestionID"
        case difficulty = "Difficulty"
        case questionText = "QuestionText"
        case answers = "Answers"
        
//        enum AnswerKeys: String, CodingKey {
//            case questionID = "QuestionID"
//            case answerText = "answerText"
//            case correct = "Correct"
//        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        questionID = try container.decode(Int16.self, forKey: .questionID)
        difficulty = try container.decode(Int16.self, forKey: .difficulty)
        questionText = try container.decode(String.self, forKey: .questionText)
        answers = try container.decode([Answer].self, forKey: .answers)
    }
}
