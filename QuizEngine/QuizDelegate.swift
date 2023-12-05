//
//  Copyright © 2023 Keepitswift. All rights reserved.
//

import Foundation

public protocol QuizDelegate: AnyObject {
    associatedtype Question
    associatedtype Answer
    
    func answer(for question: Question, goToPreviousQuestion: (() -> Void)?, goToNextQuestion: (() -> Void)?, completion: @escaping (Answer) -> Void)
    
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
}
