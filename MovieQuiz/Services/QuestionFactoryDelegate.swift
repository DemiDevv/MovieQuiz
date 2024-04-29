//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Demain Petropavlov on 21.04.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
