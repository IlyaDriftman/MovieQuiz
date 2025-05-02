//
//  AlerModel.swift
//  MovieQuiz
//
//  Created by Илья on 30.04.2025.
//
import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
