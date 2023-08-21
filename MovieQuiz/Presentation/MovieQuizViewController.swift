import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageVew: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    // счетчик текущего вопроса
    private var currentQuestionIndex: Int = 0
    // счетчик правильных ответов
    private var correctAnswers: Int = 0
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// yes button action
    @IBAction private func yesButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    // no button action
    @IBAction private func noButtonClicked(_ sender: Any) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    // функция конвертирования модели QuizQuestion в QuizStepViewModel
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
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
        imageVew.layer.cornerRadius = 20
        
//        if isCorrect {
//            imageVew.layer.masksToBounds = true
//            imageVew.layer.borderWidth = 8
//            imageVew.layer.borderColor = UIColor(named: "YP Green")?.cgColor
//            imageVew.layer.cornerRadius = 8
//
//        } else {
//            imageVew.layer.masksToBounds = true
//            imageVew.layer.borderWidth = 8
//            imageVew.layer.borderColor = UIColor(named: "YP Red")?.cgColor
//            imageVew.layer.cornerRadius = 8
//        }
    }
    
    
    
    
}



// MARK: ViewModels
// для состояния "Вопрос показан"
struct QuizStepViewModel {
    let image: UIImage
    let question: String
    let questionNumber: String
}

// для состояния "Результат квиза"
struct QuizResultViewModel {
    let title: String
    let text: String
    let buttonText: String
}

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
}

// MARK: Mocks
private let questions: [QuizQuestion] = [
    QuizQuestion(image: "The Godfather",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "The Dark Knight",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "Kill Bill",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "The Avengers",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "Deadpool",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "The Green Knight",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: true),
    QuizQuestion(image: "Old",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "Tesla",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false),
    QuizQuestion(image: "Vivarium",
                 text: "Рейтинг этого фильма больше чем 6?",
                 correctAnswer: false)
]
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
