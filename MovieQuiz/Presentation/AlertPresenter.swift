//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Andrey Bigalinov on 10.09.2023.
//

import UIKit

protocol AlertPresenterPorotocol {
    func show(alertModel: AlertModel)
}

final class AlertPresenter: AlertPresenterPorotocol {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController? = nil) {
        self.viewController = viewController
    }
}

extension AlertPresenter {
    func show(alertModel: AlertModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        // константа с кнопкой для системного алерта
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) {  _ in
            alertModel.buttonAction()
        }
        
        alert.addAction(action) 
        viewController?.present(alert, animated: true)
    }
}