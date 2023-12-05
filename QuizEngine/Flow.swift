//
//  Copyright © 2023 Keepitswift. All rights reserved.
//

import Foundation

final class Flow<Delegate: QuizDelegate> {
    typealias Question = Delegate.Question
    typealias Answer = Delegate.Answer
    
    private let delegate: Delegate
    private let questions: [Question]
    private var answers: [(Question, Answer)] = []
    private var currentQuestionIndex: Int = .zero
    
    init(questions: [Question], delegate: Delegate) {
        self.questions = questions
        self.delegate = delegate
    }
    
    func start() {
        delegateQuestionHandling(at: questions.startIndex)
    }
    
    public func goToPreviousQuestion() {
        guard currentQuestionIndex - 1 >= 0 else { return }
        delegateQuestionHandling(at: currentQuestionIndex - 1)
    }
    
    public func goToNextQuestion() {
        guard currentQuestionIndex + 1 <= questions.endIndex else { return }
        delegateQuestionHandling(at: currentQuestionIndex + 1)
    }
    
    private func delegateQuestionHandling(at index: Int) {
        if index < questions.endIndex {
            let question = questions[index]
            
            let goToPrev = index == questions.startIndex ? nil : goToPreviousQuestion
            let goToNext = index == (questions.endIndex - 1) ? nil : goToNextQuestion
            
            delegate.answer(for: question, goToPreviousQuestion: goToPrev, goToNextQuestion: goToNext, completion: answer(for: question, at: index))
            currentQuestionIndex = index
        } else {
            delegate.didCompleteQuiz(withAnswers: answers)
        }
    }
    
    private func delegateQuestionHandling(after index: Int) {
        delegateQuestionHandling(at: questions.index(after: index))
    }
    
    private func answer(for question: Question, at index: Int) -> (Answer) -> Void {
        return { [weak self] answer in
            self?.answers.replaceOrInsert((question, answer), at: index)
            self?.delegateQuestionHandling(after: index)
        }
    }
}

private extension Array {
    mutating func replaceOrInsert(_ element: Element, at index: Index) {
        if index < count {
            remove(at: index)
        }
        insert(element, at: index)
    }
}
