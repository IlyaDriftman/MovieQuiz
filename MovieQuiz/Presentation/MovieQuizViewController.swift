import UIKit
final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
//final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    
    //private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticServiceProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statisticService = StatisticService()
        let allValues = UserDefaults.standard.dictionaryRepresentation()
        // Получаем все ключи словаря, затем в цикле удаляем их
        allValues.keys.forEach { key in
        UserDefaults.standard.removeObject(forKey: key)
        }
        
        // Печатаем или обрабатываем все ключи и значения
        for (key, value) in allValues {
            print("\(key) - \(value)")
        } 
        
        setUpImageView()
        alertPresenter = AlertPresenter(viewController: self)
        let questionFactory = QuestionFactory()
        questionFactory.setup(delegate: self)
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }

        currentQuestion = question
        let viewModel = convert(model: question)
        //show(quiz: viewModel)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    private func setUpImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
    }
    
    private func show(quiz step: QuizStepViewModel) {
        let text = step.question
        
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.13
        paragraphStyle.minimumLineHeight = 23
        paragraphStyle.alignment = .center
        attributedString.addAttribute(
            .kern,
            value: 0.35,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length)
        )
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        textLabel.attributedText = attributedString
    }
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        if isCorrect {
            correctAnswers += 1
        }
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
            
            self.unblockButtons()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            finishGame(correct: correctAnswers, total: questionsAmount)
            let bestGame = statisticService?.bestGame
            let accuracy = String(format: "%.2f", statisticService?.totalAccuracy ?? "")
                
                let text = """
                Ваш результат: \(correctAnswers)/\(questionsAmount)
                Количество сыграных квизов: \(statisticService?.gamesCount ?? 0)
                Рекорд: \(bestGame?.correct ?? 0)/\(bestGame?.total ?? 0) (\(bestGame?.date.dateTimeString ?? ""))
                Средняя точность: \(accuracy)%
                """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
           // finishGame(correct: correctAnswers, total: questionsAmount)
            show(quiz: viewModel)
           
        } else {
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
        }
    }
    private func blockButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    private func unblockButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let model = AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        )
        alertPresenter?.presenterAlert(on: self, with: model)
        
        //let alert = UIAlertController(
        //title: result.title,
        //message: result.text,
       // preferredStyle: .alert)
       // let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
       // guard let self = self else { return }
       // self.currentQuestionIndex = 0
       // self.correctAnswers = 0
        
       // questionFactory.requestNextQuestion()
       // }
       // alert.addAction(action)
       // present(alert, animated: true, completion: nil)
        }
        
    @IBAction private func noButtonClicked(_ sender: Any) {
        blockButtons()
        guard let currentQuestion = currentQuestion else {
            return
        }
        let curoectAnswer = false
        showAnswerResult(isCorrect:curoectAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        blockButtons()
       // let currentQuestion = questions[currentQuestionIndex]
        guard let currentQuestion = currentQuestion else {
            return
        }
        let curoectAnswer = true
        showAnswerResult(isCorrect:curoectAnswer == currentQuestion.correctAnswer)
    }
    
    func finishGame(correct: Int, total: Int) {
        statisticService?.store(correct: correct, total: total)
        }
    
}
