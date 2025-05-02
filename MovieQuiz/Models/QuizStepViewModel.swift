//
//  QuizStepViewModel.swift
//  MovieQuiz
//
//  Created by Илья on 28.04.2025.
//
import Foundation
import UIKit

class  QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    init(image: UIImage, question: String, questionNumber: String) {
        self.image = image
        self.question = question
        self.questionNumber = questionNumber
    }
    }

