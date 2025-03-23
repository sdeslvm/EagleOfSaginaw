import Foundation

class Network: NSObject {
    func isURLValid() async -> Bool {
        if let encodedURLString = Assets.greetingUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let finalURL = URL(string: encodedURLString) {
            do {
                let result = try await URLSession.shared.data(for: URLRequest(url: finalURL))
                print(result.1)
                guard let urlResponse = result.1 as? HTTPURLResponse, urlResponse.statusCode == 200 else { return false }
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
}
