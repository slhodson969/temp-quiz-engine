//
//  Copyright © 2023 Keepitswift. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        let (sut, delegate) = makeSUT(questions: [])
        sut.start()
        
        XCTAssertTrue(delegate.questionsAsked.isEmpty)
    }
    
    func test_start_withOneQuestion_delegatesCorrectQuestionHandling() {
        let (sut, delegate) = makeSUT(questions: ["Q1"])
        sut.start()
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    
    func test_start_withOneQuestion_delegatesAnotherCorrectQuestionHandling() {
        let (sut, delegate) = makeSUT(questions: ["Q2"])
        sut.start()
        
        XCTAssertEqual(delegate.questionsAsked, ["Q2"])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        let (sut, delegate) = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let (sut, delegate) = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
        let (sut, delegate) = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesSecondAndThirdQuestionHandling22() {
        let (sut, delegate) = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        XCTAssertEqual(delegate.goToPreviousQuestionCompletions.count, 1)
        XCTAssertNil(delegate.goToPreviousQuestionCompletions[0])
        XCTAssertEqual(delegate.goToNextQuestionCompletions.count, 1)
        XCTAssertNotNil(delegate.goToNextQuestionCompletions[0])
        
        delegate.answerCompletions[0]("A1")
        
        XCTAssertEqual(delegate.goToPreviousQuestionCompletions.count, 2)
        XCTAssertNotNil(delegate.goToPreviousQuestionCompletions[1])
        XCTAssertEqual(delegate.goToNextQuestionCompletions.count, 2)
        XCTAssertNotNil(delegate.goToNextQuestionCompletions[1])
        
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.goToPreviousQuestionCompletions.count, 3)
        XCTAssertNotNil(delegate.goToPreviousQuestionCompletions[2])
        XCTAssertEqual(delegate.goToNextQuestionCompletions.count, 3)
        XCTAssertNil(delegate.goToNextQuestionCompletions[2])
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateAnotherQuestionHandling() {
        let (sut, delegate) = makeSUT(questions: ["Q1"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        
        XCTAssertEqual(delegate.questionsAsked, ["Q1"])
    }
    
    func test_start_withOneQuestion_doesNotCompleteQuiz() {
        let (sut, delegate) = makeSUT(questions: ["Q1"])
        sut.start()
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_start_withNoQuestions_completeWithEmptyQuiz() {
        let (sut, delegate) = makeSUT(questions: [])
        sut.start()
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        XCTAssertTrue(delegate.completedQuizzes[0].isEmpty)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotCompleteQuiz() {
        let (sut, delegate) = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        
        XCTAssertTrue(delegate.completedQuizzes.isEmpty)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestions_completesQuiz() {
        let (sut, delegate) = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 1)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
    }
    
    func test_startAndAnswerFirstAndSecondQuestionTwice_withTwoQuestions_completesQuizTwice() {
        let (sut, delegate) = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCompletions[0]("A1")
        delegate.answerCompletions[1]("A2")
        
        delegate.answerCompletions[0]("A1-1")
        delegate.answerCompletions[1]("A2-2")
        
        XCTAssertEqual(delegate.completedQuizzes.count, 2)
        assertEqual(delegate.completedQuizzes[0], [("Q1", "A1"), ("Q2", "A2")])
        assertEqual(delegate.completedQuizzes[1], [("Q1", "A1-1"), ("Q2", "A2-2")])
    }
    
    // MARK: Helpers
    
    private weak var weakSUT: Flow<WeakRefVirtualProxy<DelegateSpy>>?
    
    override func tearDown() {
        super.tearDown()
        
        XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not nil.")
    }
    
    private func makeSUT(questions: [String]) -> (sut: Flow<WeakRefVirtualProxy<DelegateSpy>>, delegate: DelegateSpy) {
        let delegate = DelegateSpy()
        let sut = Flow(questions: questions, delegate: WeakRefVirtualProxy(delegate))
        weakSUT = sut
        return (sut, delegate)
    }
    
}
