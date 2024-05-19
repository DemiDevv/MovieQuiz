//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Demain Petropavlov on 21.04.2024.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
