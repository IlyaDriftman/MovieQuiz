import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
            
            let rating = Float(movie.rating) ?? 0
            let randomIndex = Int.random(in: 5..<10)
            let text = "Рейтинг этого фильма больше чем \(randomIndex)?"
            let correctAnswer = Int(rating) > randomIndex
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    // weak var delegate: QuestionFactoryDelegate?
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    private var movies: [MostPopularMovie] = []
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in

            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // сообщаем об ошибке нашему MovieQuizViewController
                }
            }
            /* private let questions: [QuizQuestion] = [
             QuizQuestion(
             image: "The Godfather",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(
             image: "The Dark Knight",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(
             image: "Kill Bill",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(
             image: "The Avengers",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(
             image: "Deadpool",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(
             image: "The Green Knight",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: true),
             QuizQuestion(
             image: "Old",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false),
             QuizQuestion(
             image: "The Ice Age Adventures of Buck Wild",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false),
             QuizQuestion(
             image: "Tesla",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false),
             QuizQuestion(
             image: "Vivarium",
             text: "Рейтинг этого фильма больше чем 6?",
             correctAnswer: false)
             ]
             */
             
             /*
             func requestNextQuestion()  {
             guard let index = (0..<questions.count).randomElement() else {
             delegate?.didReceiveNextQuestion(question: nil)
             return
             }
             let question = questions[safe: index]
             delegate?.didReceiveNextQuestion(question: question)
             }
             */
        }
    }
}
