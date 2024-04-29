//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Demain Petropavlov on 21.04.2024.
//

import UIKit

final class AlertPresenter: AlertPresenterProtocol {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAlert(alert result: AlertModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {  _ in result.competition() }
        
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
    }
}
