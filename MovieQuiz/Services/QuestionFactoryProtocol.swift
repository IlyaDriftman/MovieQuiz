//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Илья on 29.04.2025.
//
import Foundation

protocol QuestionFactoryProtocol {
    func loadData()
    func requestNextQuestion()
    func setup(delegate: QuestionFactoryDelegate)
}
