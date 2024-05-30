import Foundation

class RepoSearchViewModel {
    var url: URL?
    var method: HTTPMethod = .GET
    var query: String = ""
    var repositories: RepoSearchResult?
    var repostitoriesItemData = [Items]()
    var currentPage: Int = 1
    var perPageCount = 10
    var reloadNext = true
    
    fileprivate var urlRequest: URLRequest {
        guard let url = URL(string: URL.searchRepoURLString + "q=\(query)" + "&page=\(currentPage)&per_page=\(perPageCount)") else { fatalError("Could not configure URL") }
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        return req
    }
    
    func request(page: Int, callback: @escaping (APIResult) -> Void) {
        self.currentPage = page
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if let e = error {
                callback(.failure(e))
            } else if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let response: RepoSearchResult = try jsonDecoder.decode(RepoSearchResult.self, from: data)
                    guard let data = response.items else { return }
                    if !data.isEmpty {
                        self.repostitoriesItemData.append(contentsOf: data)
                        if page == 2 {
                            self.saveDataToLocalStorage(data: Array(self.repostitoriesItemData.prefix(15)))
                        }
                        callback(.success(response))
                    } else {
                        self.reloadNext = false
                    }
                } catch {
                    callback(.failure(error))
                }
            } else {
                callback(.failure(APIError.emptyBody))
            }
        }).resume()
    }
    
    private func saveDataToLocalStorage(data: [Items]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            UserDefaults.standard.set(encoded, forKey: "savedRepos")
        }
    }
    
    func loadDataFromLocalStorage() {
        if let savedData = UserDefaults.standard.object(forKey: "savedRepos") as? Data {
            let decoder = JSONDecoder()
            if let loadedData = try? decoder.decode([Items].self, from: savedData) {
                self.repostitoriesItemData = loadedData
            }
        }
    }
}

