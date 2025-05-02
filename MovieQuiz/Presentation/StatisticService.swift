//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Илья on 01.05.2025.
//

// Расширяем при объявлении
import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
   
    
    var totalAccuracy: Double {
        let correct = storage.integer(forKey: "totalCorrect")
        let total = storage.integer(forKey: "totalQuestions")
        
        guard total > 0 else { return 0.0 }
        
        return (Double(correct) / Double(total)) * 100
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: "gamesCount")
        }
        set {
            storage.set(newValue, forKey: "gamesCount")
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: "bestGame_correct")
            let total = storage.integer(forKey: "bestGame_total")
            let date = storage.object(forKey: "bestGame_date") as? Date ?? Date()
            //let date = String(date1.dateTimeString)
            //print(date.dateTimeString)
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: "bestGame_correct")
            storage.set(newValue.total, forKey: "bestGame_total")
            storage.set(newValue.date, forKey: "bestGame_date")
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        gamesCount += 1

        // Обновляем общее количество правильных ответов и вопросов
        let currentCorrect = storage.integer(forKey: "totalCorrect")
        
        
        print("достаем тз базы тоталкоррект - \(currentCorrect), а count - \(count)" )
        
        let currentTotal = storage.integer(forKey: "totalQuestions")
        
        print("достаем тз базы тоталквестшн - \(currentTotal), а amount - \(amount)" )
        
        storage.set(currentCorrect + count, forKey: "totalCorrect")
        storage.set(currentTotal + amount, forKey: "totalQuestions")
        print("средняя точность \(totalAccuracy)")
        
        // Создаём новый результат
        let newGame = GameResult(correct: count, total: amount, date: Date())
        
        if newGame.isBetterThan(bestGame) {
            bestGame = newGame
            print("Новый рузльтат игры лучше чем в базе")
        }
        
        // Сравниваем с текущим лучшим результатом
       // if newGame.accuracy > bestGame.accuracy {
        //    bestGame = newGame
        //   print("Новый рузльтат игры лучше чем в базе")
            
        //}
    }
    
  
}
