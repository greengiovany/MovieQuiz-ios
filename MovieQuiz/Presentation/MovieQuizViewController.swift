import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageVew: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    // счетчик текущего вопроса
    private var currentQuestionIndex: Int = 0
    // счетчик правильных ответов
    private var correctAnswers: Int = 0
    // разделение ответственности
    private let questionsAmount: Int = 10 // количество вопросов квиза (questionsCount)
    private var questionFactory: QuestionFactoryProtocol? // фабрика вопросов, через композицию
    private var currentQuestion: QuizQuestion? // текущий вопрос
    private var alertPresenter: AlertPresenterPorotocol?
    private var statisticService: StatisticService?
    
    // MARK: - Lifecycle / func viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageVew.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticServiceImp()
        questionFactory?.requestNextQuestion()
         
        // MARK:  Inception.json serialize (homework)
        var documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let file = "top250MoviesIMDB.json"
        documentURL.appendPathComponent(file)
        print(documentURL.path)
        
        var jsonString = try? String(contentsOf: documentURL)
        print(jsonString!)
        
        // MARK:  protocol Codable
        func getMovie(from jsonString: String) -> Top? {
            guard let data = jsonString.data(using: .utf8) else { return nil }
            do {
                let result = try JSONDecoder().decode(Top.self, from: data)
                return result
            } catch {
                print("Failed to parse: \(error.localizedDescription)")
            }
            return nil
        }
    }
    
    // MARK: - QuestionFactoryDelegate
    
    // MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: Any) {
//        let currentQuestion = questions[currentQuestionIndex]
        guard let currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        yesButton.isEnabled = false
    }

    @IBAction private func noButtonClicked(_ sender: Any) {
//        let currentQuestion = questions[currentQuestionIndex]
        guard let currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
        noButton.isEnabled = false
    }
    
    // MARK: - Private functions
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageVew.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    

    
    // приватный метод, который меняет цвет рамки
    private func showAnswerResult(isCorrect: Bool) {
        imageVew.layer.masksToBounds = true
        imageVew.layer.borderWidth = 8
        imageVew.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        if isCorrect {
            correctAnswers += 1
        }
        imageVew.layer.cornerRadius = 20
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            self.showNextQuestionOrResult()
        }
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    private func showNextQuestionOrResult() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        if currentQuestionIndex == questionsAmount - 1 {
            showFinalResults()
        } else {
            imageVew.layer.borderColor = UIColor(white: 1, alpha: 0).cgColor
            currentQuestionIndex += 1
            self.questionFactory?.requestNextQuestion()
//            if let nextQuestion = questionFactory.requestNextQuestion() {
//                currentQuestion = nextQuestion
//                let viewModel = convert(model: nextQuestion)
//                show(quiz: viewModel)
//            }
        }
    }
    
    private func showFinalResults() {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        // TODO: call aleretPresenter
        
        let alertModel = AlertModel(
            title: "Этот раунд окончен!",
            message: makeResultMessage() ,
            buttonText: "Сыграть ещё раз",
            buttonAction: { [weak self] in
                guard let self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                questionFactory?.requestNextQuestion()

            }
        )
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func makeResultMessage() -> String {
        guard let statisticService = statisticService,  let bestGame = statisticService.bestGame else {
            assertionFailure("error")
            return ""
        }
        let totalplaysCountLine = "Количество сыгранных квизов: \(statisticService.gamesCount)"
        let currentGameResultLine = "Ваш результат: \(correctAnswers) \\\(questionsAmount)"
        let bestGameInfoLine = "Рекорд: \(bestGame.correct)\\\(bestGame.total)" + " (\(bestGame.date.dateTimeString))"
        let averageAccuracyLine = "Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%"
        let resultMessage = [currentGameResultLine, totalplaysCountLine, bestGameInfoLine, averageAccuracyLine].joined (separator: "\n" )
        
        return resultMessage
    }
}


extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }

        currentQuestion = question // .self (?)
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
