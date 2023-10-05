//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Andrey Bigalinov on 10.09.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let buttonAction: () -> Void
}
