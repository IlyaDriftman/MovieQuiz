//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Илья on 01.05.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date

    // метод сравнения по количеству верных ответов
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
    
  //  var accuracy: Double {
   //         guard total > 0 else { return 0.0 }
   //         return Double(correct) / Double(total)
   //     }
}
