//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Andrey Bigalinov on 01.10.2023.
//

import Foundation

struct BestGame: Codable {  
    let correct: Int
    let total: Int
    let date: Date
    
    // метод сравнения по кол-ву верных ответов
//    func isBetterThan(_ another: BestGame) -> Bool {
//        correct > another.correct
//    }
}
// alternative
extension BestGame: Comparable {
    private var accuracy: Double {
        guard total != 0 else {
            return 0
        }
        
        return Double(correct / total)
    }
    static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        lhs.correct < rhs.correct
    }
    
    
}