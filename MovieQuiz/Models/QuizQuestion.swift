//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Илья on 28.04.2025.
//
import Foundation
import UIKit

class QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    
    init(image: String, text: String, correctAnswer: Bool) {
        self.image = image
        self.text = text
        self.correctAnswer = correctAnswer
    }
    }

