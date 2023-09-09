import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
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
    private let questionsAmount: Int = 10 // количество вопросов квиза
    private var questionFactory: QuestionFactoryProtocol? // фабрика вопросов, через композицию
    private var currentQuestion: QuizQuestion? // текущий вопрос
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        imageVew.layer.cornerRadius = 20
        
        questionFactory = QuestionFactory(delegate: self)
        
        questionFactory?.requestNextQuestion()
//        if let firstQuestion = questionFactory.requestNextQuestion() {
//            currentQuestion = firstQuestion
//            let viewModel = convert(model: firstQuestion)
//            show(quiz: viewModel)
//        }
//        let fisrtQuestion = questions[currentQuestionIndex]
//        let firstViewModel = convert(model: fisrtQuestion)
//        show(quiz: firstViewModel)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
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
    
    // приватный метод показа результата
    private func show(quiz result: QuizResultsViewModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        // константа с кнопкой для системного алерта
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { [weak self] _ in
            guard let self else { return }
            // обнуляем индекс и результат по прошлому раунду
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            questionFactory?.requestNextQuestion()
            // заново показываем первый вопрос
//            let firstQuestion = self.questions[self.currentQuestionIndex]
//            let viewModel = self.convert(model: firstQuestion)
//            self.show(quiz: viewModel)
            
//            if let firstQuestion = self.questionFactory.requestNextQuestion() {
//                self.currentQuestion = firstQuestion
//                let viewModel = self.convert(model: firstQuestion)
//                self.show(quiz: viewModel)
//            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
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
//            let text = correctAnswers == questionsAmount ?
//                        "Поздравляем, Вы ответили на 10 из 10!" :
//                        "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            imageVew.layer.borderColor = UIColor(white: 1, alpha: 0).cgColor
            show(quiz: viewModel)
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
}
