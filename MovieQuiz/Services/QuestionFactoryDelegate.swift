//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Demain Petropavlov on 21.04.2024.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
