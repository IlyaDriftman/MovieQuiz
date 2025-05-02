//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Илья on 29.04.2025.
//

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
