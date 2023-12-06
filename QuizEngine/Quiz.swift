//
//  Copyright © 2023 Keepitswift. All rights reserved.
//

import Foundation

public final class Quiz {
    private let flow: Any
    
    private init(flow: Any) {
        self.flow = flow
    }
    
    public static func start<Delegate: QuizDelegate>(
        questions: [Delegate.Question],
        delegate: Delegate
    ) -> Quiz where Delegate.Answer: Equatable {
        let flow = Flow(questions: questions, delegate: WeakRefVirtualProxy(delegate))
        flow.start()
        return Quiz(flow: flow)
    }
}

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: QuizDelegate where T: QuizDelegate {
    func answer(for question: T.Question, goToPreviousQuestion: (() -> Void)?, goToNextQuestion: (() -> Void)?, completion: @escaping (T.Answer) -> Void) {
        object?.answer(for: question, goToPreviousQuestion: goToPreviousQuestion, goToNextQuestion: goToNextQuestion, completion: completion)
    }
    
    func didCompleteQuiz(withAnswers: [(question: T.Question, answer: T.Answer)]) {
        object?.didCompleteQuiz(withAnswers: withAnswers)
    }
}
