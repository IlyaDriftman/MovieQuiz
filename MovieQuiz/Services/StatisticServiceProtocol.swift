//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Илья on 01.05.2025.
//
protocol StatisticServiceProtocol {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameResult { get }

    func store(correct count: Int, total amount: Int)
    
    
}
