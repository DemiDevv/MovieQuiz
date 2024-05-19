import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var correctAnswers = 0
    private let presenter = MovieQuizPresenter()
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService?
    
    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
       
       imageView.layer.cornerRadius = 20
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        statisticService = StatisticServiceImplementation()

        showLoadingIndicator()
        questionFactory?.loadData()
        alertPresenter = AlertPresenter(viewController: self)

    }
    // MARK: - QuestionFactoryDelegate

    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
    }

    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
        
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
            currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }

    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        
        alertPresenter?.showAlert(alert: model)
    }
    
    private func show(quiz step: QuizStepViewModel) {
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.image = step.image
        imageView.layer.cornerRadius = 20
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        
        guard let statisticService = statisticService else { return }
        let message = " Ваш результат: \(correctAnswers)/\(presenter.questionsAmount) \n Количество сыгранных квизов: \(statisticService.gamesCount) \n Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))% "
        
        let alertModel = AlertModel(
            title: result.title,
            message: message,
            buttonText: result.buttonText,
            competition: { [weak self] in
                guard let self = self else {return}
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            })
        alertPresenter?.showAlert(alert: alertModel)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else {return}
            yesButton.isEnabled = true
            noButton.isEnabled = true
            self.imageView.layer.borderColor = UIColor.ypBlack.cgColor
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            let text = correctAnswers == presenter.questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на: \(correctAnswers)/10, попробуйте еще раз!"
            let viewModel = QuizResultsViewModel(
                        title: "Этот раунд окончен!",
                        text: text,
                        buttonText: "Сыграть ещё раз")
                    show(quiz: viewModel)
            
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.self.requestNextQuestion()
        }
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.currentQuestion = currentQuestion
        presenter.noButtonClicked()
        
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
        
    }

    
}
