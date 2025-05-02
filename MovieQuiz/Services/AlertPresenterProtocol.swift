//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Илья on 30.04.2025.
//

import UIKit
protocol AlertPresenterProtocol: AnyObject {
    func presenterAlert(on viewController: UIViewController, with model: AlertModel)
}
