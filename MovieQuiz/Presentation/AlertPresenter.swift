//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Илья on 30.04.2025.
//
import Foundation
import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
            self.viewController = viewController
        }
    
    func presenterAlert(on viewController: UIViewController, with model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        viewController.present(alert, animated: true)
    }
}
