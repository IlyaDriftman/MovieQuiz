import UIKit
final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageView()
        alertPresenter = AlertPresenter(viewController: self)
        presenter = MovieQuizPresenter(viewController: self)
        showLoadingIndicator()
    }
    
    private func setUpImageView() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.frame = imageView.frame.integral
        imageView.layer.borderWidth = 1
    }
    
    func show(quiz step: QuizStepViewModel) {
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
        imageView.layer.borderWidth = 0
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func blockButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func unblockButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let message = presenter.makeResultsMessage()
        let model = AlertModel(title: result.title, message: message, buttonText: result.buttonText, completion: {
            self.presenter.restartGame()
        },
                               id: "resultAlert"
        )
        alertPresenter?.presenterAlert(on: self, with: model)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз",
                               completion: { [weak self] in
            guard let self else { return }
            self.presenter.restartGame()
        },
                               id: "errorAlert"
        )
        alertPresenter?.presenterAlert(on: self, with: model)
    }
}
