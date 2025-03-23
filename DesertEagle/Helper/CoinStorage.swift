import Foundation

final class CoinStorage {
    static let shared = CoinStorage()
    private let key = "coin_storage"
    
    private init() {}
    
    private var coins: Int {
        get { UserDefaults.standard.integer(forKey: key) }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }

    func add(_ amount: Int) {
        coins += amount
    }

    func spend(_ amount: Int) -> Bool {
        if coins >= amount {
            coins -= amount
            return true
        }
        return false
    }

    func getBalance() -> Int {
        return coins
    }
}
