import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultsViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func blockButtons()
    func unblockButtons()
    func showNetworkError(message: String)
}

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    private var currentQuestionIndex: Int = 0
    private let statisticService: StatisticServiceProtocol?
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestion: QuizQuestion?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)" 
        )
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func makeResultsMessage() -> String {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        let bestGame = statisticService?.bestGame
        
        let totalPlaysCountLine = "Количество сыгранных квизов: \(statisticService?.gamesCount ?? 0)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers)\\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame?.correct ?? 0)\\\(bestGame?.total ?? 0)"
        + " (\(bestGame?.date.dateTimeString ?? "01-01-01")"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%"
        
        let resultMessage = [
            currentGameResultLine, totalPlaysCountLine, bestGameInfoLine, averageAccuracyLine
        ].joined(separator: "\n")
        return resultMessage
    }
    
    func proceedWithAnswer(isCorrect: Bool) {
        didAnswer(isCorrectAnswer: isCorrect)
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func didAnswer(isYes: Bool) {
        viewController?.blockButtons()
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = isYes
        proceedWithAnswer(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
   
    private func didAnswer(isCorrectAnswer: Bool) {
        if (isCorrectAnswer) { correctAnswers += 1 }
    }
    
    private func proceedToNextQuestionOrResults() {
        viewController?.unblockButtons()
        if self.isLastQuestion() {
            finishGame(correct: correctAnswers, total: self.questionsAmount)
            let bestGame = statisticService?.bestGame
            let accuracy = String(format: "%.2f", statisticService?.totalAccuracy ?? "")
            
            let text = """
                Ваш результат: \(correctAnswers)/\(self.questionsAmount)
                Количество сыграных квизов: \(statisticService?.gamesCount ?? 0)
                Рекорд: \(bestGame?.correct ?? 0)/\(bestGame?.total ?? 0) (\(bestGame?.date.dateTimeString ?? ""))
                Средняя точность: \(accuracy)%
                """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            viewController?.show(quiz: viewModel)
            
        } else {
            self.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func finishGame(correct: Int, total: Int) {
        statisticService?.store(correct: correct, total: total)
    }
    
    
}
