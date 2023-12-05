//
//  Copyright © 2023 Keepitswift. All rights reserved.
//

import Foundation
import QuizEngine

struct ClosureHolder {
    let closure: (() -> Void)?
}

//class DelegateSpy: QuizDelegate {
//    var questionsAsked: [String] = []
//    var goToPreviousQuestionCompletions: [ClosureHolder] = []
//    var goToNextQuestionCompletions: [ClosureHolder] = []
//    var answerCompletions: [(String) -> Void] = []
//
//    var completedQuizzes: [[(String, String)]] = []
//        
//    func answer(for question: String, goToPreviousQuestion: (() -> Void)?, goToNextQuestion: (() -> Void)?, completion: @escaping (String) -> Void) {
//        questionsAsked.append(question)
//        goToPreviousQuestionCompletions.append(ClosureHolder(closure: goToPreviousQuestion))
//        goToNextQuestionCompletions.append(ClosureHolder(closure: goToNextQuestion))
//        answerCompletions.append(completion)
//    }
//    
//    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
//        completedQuizzes.append(answers)
//    }
//    
//    deinit {
//        goToPreviousQuestionCompletions = []
//        goToNextQuestionCompletions = []
//        answerCompletions = []
//    }
//}

class DelegateSpy: QuizDelegate {
    var questionsAsked: [String] = []
    var goToPreviousQuestionCompletions: [(() -> Void)?] = []
    var goToNextQuestionCompletions: [(() -> Void)?] = []
    var answerCompletions: [(String) -> Void] = []

    var completedQuizzes: [[(String, String)]] = []
        
    func answer(for question: String, goToPreviousQuestion: (() -> Void)?, goToNextQuestion: (() -> Void)?, completion: @escaping (String) -> Void) {
        questionsAsked.append(question)
        goToPreviousQuestionCompletions.append(goToPreviousQuestion)
        goToNextQuestionCompletions.append(goToNextQuestion)
        answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
}
