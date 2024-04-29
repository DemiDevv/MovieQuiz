
import UIKit

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    func store(correct count: Int, total amount: Int)
}

struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameRecord) -> Bool {
        correct > another.correct
    }
}

final class StatisticServiceImplementation: StatisticService {
    
    private let userDefaults = UserDefaults.standard
    
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private var totalCorrectCount: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    private var totalAmount: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            guard let data = userDefaults.data(forKey: "totalAccuracy"),
            let totalAccuracy = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0
            }

            return totalAccuracy
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: "totalAccuracy")
        }
    }
    
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
            let gamesCount = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }

            return gamesCount
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
            let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }

            return record
        }

        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    

    
    func store(correct count: Int, total amount: Int){
        totalCorrectCount += count
        totalAmount += amount
        gamesCount += 1
        
        totalAccuracy = 100 * (Double(totalCorrectCount) / Double(totalAmount))
        
        var newBestGame = GameRecord(correct: count, total: amount, date: Date())
        var previuosBestGame = bestGame
        
        if newBestGame.isBetterThan(previuosBestGame) {
            guard let data = try? JSONEncoder().encode(newBestGame) else {
                print("Невозможно сохранить результат")
                return
            }

            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
        
    }
    
}
