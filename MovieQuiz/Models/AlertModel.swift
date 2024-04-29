//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Demain Petropavlov on 21.04.2024.
//

import Foundation

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    
    let competition: () -> Void 
}
