import Foundation

struct EagleSkin {
    let name: String
    let price: Int
    var isPurchased: Bool
}

final class SkinStore {
    static let shared = SkinStore()
    private let purchasedKey = "purchased_skins"
    private let selectedKey = "selected_skin"

    private(set) var skins: [EagleSkin] = []
    
    private init() {
        let purchased = Set(UserDefaults.standard.stringArray(forKey: purchasedKey) ?? [])
        let defaultSkins = (1...7).map {
            EagleSkin(name: "eagle\($0)", price: 50 + ($0 - 1) * 30, isPurchased: $0 == 1 || purchased.contains("eagle\($0)"))
        }
        skins = defaultSkins
    }

    var selectedSkinName: String {
        get { UserDefaults.standard.string(forKey: selectedKey) ?? "eagle1" }
        set { UserDefaults.standard.set(newValue, forKey: selectedKey) }
    }

    func purchase(name: String, using coins: CoinStorage) -> Bool {
        guard var skin = skins.first(where: { $0.name == name }),
              !skin.isPurchased,
              coins.spend(skin.price)
        else { return false }

        skin.isPurchased = true
        if let index = skins.firstIndex(where: { $0.name == name }) {
            skins[index] = skin
        }

        var purchased = Set(UserDefaults.standard.stringArray(forKey: purchasedKey) ?? [])
        purchased.insert(name)
        UserDefaults.standard.set(Array(purchased), forKey: purchasedKey)

        return true
    }

    func select(name: String) -> Bool {
        guard let skin = skins.first(where: { $0.name == name && $0.isPurchased }) else {
            return false
        }
        selectedSkinName = skin.name
        return true
    }

    func isPurchased(name: String) -> Bool {
        skins.first(where: { $0.name == name })?.isPurchased ?? false
    }

    func getAllSkins() -> [EagleSkin] {
        skins
    }
}
