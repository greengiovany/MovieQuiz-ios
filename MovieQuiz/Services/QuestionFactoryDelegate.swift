//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Andrey Bigalinov on 05.09.2023.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
