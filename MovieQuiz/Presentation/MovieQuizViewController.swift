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
    private let questionsAmount: Int = 10 // количество вопросов квиза
    private var questionFactory: QuestionFactoryProtocol? // фабрика вопросов, через композицию
    private var currentQuestion: QuizQuestion? // текущий вопрос
    private var alertPresenter: AlertPresenterPorotocol?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageVew.layer.cornerRadius = 20
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(viewController: self) // rename to delegate
        questionFactory?.requestNextQuestion()
        
        // MARK: - Inception.json serialize (homework)
        var documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let file = "inception.json"
        documentURL.appendPathComponent(file)
        
        var jsonString = try? String(contentsOf: documentURL)
        print(jsonString!)
        
        // MARK: - serialization from file
//        func getMovie(from jsonString: String) -> Movie? {
//            var movie: Movie? = nil
//
//            do {
//                guard let data = jsonString.data(using: .utf8) else {
//                    return nil
//                }
//
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//
//                guard let json = json,
//                      let id = json["id"] as? String,
//                      let title = json["title"] as? String,
//                      let jsonYear = json["year"] as? String,
//                      let year = Int(jsonYear),
//                      let image = json["image"] as? String,
//                      let releaseDate = json["releaseDate"] as? String,
//                      let jsonRuntimeMins = json["runtimeMins"] as? String,
//                      let runtimeMins = Int(jsonRuntimeMins),
//                      let directors = json["directors"] as? String,
//                      let actorList = json["actorList"] as? [Any] else {
//                    return nil
//                }
//
//                var actors: [Actor] = []
//
//                for actor in actorList {
//                    guard let actor = actor as? [String: Any],
//                          let id = actor["id"] as? String,
//                          let image = actor["image"] as? String,
//                          let name = actor["name"] as? String,
//                          let asCharacter = actor["asCharacter"] as? String else {
//                        return nil
//                    }
//                    let mainActor = Actor(id: id,
//                                          image: image,
//                                          name: name,
//                                          asCharacter: asCharacter)
//                    actors.append(mainActor)
//                }
//                movie = Movie(id: id,
//                              title: title,
//                              year: year,
//                              image: image,
//                              releaseDate: releaseDate,
//                              runtimeMins: runtimeMins,
//                              directors: directors,
//                              actorList: actors)
//            } catch {
//                print("Failed to parse: \(jsonString)")
//            }
//            return movie
//        }
        
        // MARK: - protocol Codable
        func getMovie(from jsonString: String) -> Movie? {
            guard let data = jsonString.data(using: .utf8) else { return nil }
            do {
                let movie = try JSONDecoder().decode(Movie.self, from: data)
                return movie
            } catch {
                print("Failed to parse: \(error.localizedDescription)")
            }
            return nil
        }
        
        
        
//        // MARK: - FileManager
//        print(NSHomeDirectory())
//        UserDefaults.standard.set(true, forKey: "viewDidLoad")
//        print(Bundle.main.bundlePath)
//
//        var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        print(documentsURL)
//
//        let fileNAme = "text.swift"
//        documentsURL.appendPathComponent(fileNAme)
//        print(documentsURL.path)
//
//
//        if !FileManager.default.fileExists(atPath: documentsURL.path) {
//            let hello = "Hello wolrd!"
//            let data = hello.data(using: .utf8)
//
//            FileManager.default.createFile(atPath: documentsURL.path, contents: data)
//        }
//
//        // Errors
//        enum FileManagerError: Error {
//            case fileDoesntExist
//        }
//
//        func stringRead(from documentURL: URL) throws -> String {
//            if !FileManager.default.fileExists(atPath: documentURL.path) {
//                throw FileManagerError.fileDoesntExist
//            }
//            return try String(contentsOf: documentURL)
//        }
//
//        try! FileManager.default.removeItem(atPath: documentsURL.path) // or '?'
//
//        // example
//        var str = ""
//        do {
//            str = try stringRead(from: documentsURL)
//        } catch FileManagerError.fileDoesntExist {
//            print("Файл по адресу \(documentsURL.path) не существует")
//        } catch {
//            print("Неизвестная ошибка чтения из файла \(error)")
//        }
        
        // дисериализация
//        func getMovie(from jsonString: String) -> Movie? {
//            var movie: Movie? = nil
//            do {
//                guard let data = jsonString.data(using: .utf8) else {
//                    return nil
//                }
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//
//                guard let json = json,
//                      let id = json["id"] as? String,
//                      let title = json["title"] as? String,
//                      let jsonYear = json["year"] as? String,
//                      let year = Int(jsonYear),
//                      let image = json["image"] as? String,
//                      let releaseDate = json["releaseDate"] as? String,
//                      let jsonRuntimeMins = json["runtimeMins"] as? String,
//                      let runtimeMins = Int(jsonRuntimeMins),
//                      let directors = json["directors"] as? String,
//                      let actorList = json["actorList"] as? [Any] else {
//                    return nil
//                }
//
//                var actors: [Actor] = []
//
//                for actor in actorList {
//                    guard let actor = actor as? [String: Any],
//                          let id = actor["id"] as? String,
//                          let image = actor["image"] as? String,
//                          let name = actor["name"] as? String,
//                          let asCharacter = actor["asCharacter"] as? String else {
//                        return nil
//                    }
//                    let mainActor = Actor(id: id,
//                                          image: image,
//                                          name: name,
//                                          asCharacter: asCharacter)
//                    actors.append(mainActor)
//                }
//                movie = Movie(id: id,
//                              title: title,
//                              year: year,
//                              image: image,
//                              releaseDate: releaseDate,
//                              runtimeMins: runtimeMins,
//                              directors: directors,
//                              actorList: actors)
//            } catch {
//                print("Failed to parse: \(jsonString)")
//            }
//
//            return movie
//        }
    }
    
    // MARK: - QuestionFactoryDelegate
//    func didReceiveNextQuestion(question: QuizQuestion?) {
//        guard let question else {
//            return
//        }
//
//        currentQuestion = question
//        let viewModel = convert(model: question)
//        DispatchQueue.main.async { [weak self] in
//            self?.show(quiz: viewModel)
//        }
//    }
    
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
        
        // TODO: call aleretPresenter
        
        let alertModel = AlertModel(
            title: "test",
            message: "test1",
            buttonText: "button",
            buttonAction: { [weak self] in
                guard let self else { return }
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                questionFactory?.requestNextQuestion()

            }
        )
        alertPresenter?.show(alertModel: alertModel)
//        // создаём объекты всплывающего окна
//        let alert = UIAlertController(
//            title: result.title,
//            message: result.text,
//            preferredStyle: .alert)
//
//        // константа с кнопкой для системного алерта
//        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { [weak self] _ in
//            guard let self else { return }
//            // обнуляем индекс и результат по прошлому раунду
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//            questionFactory?.requestNextQuestion()
//        }
//
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
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


extension MovieQuizViewController: QuestionFactoryDelegate {
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
}
