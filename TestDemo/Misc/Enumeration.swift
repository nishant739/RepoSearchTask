import Foundation

enum HTTPMethod: String {
    case GET
}

enum APIError: Error {
    case emptyBody
    case unexpectedResponseType
}

enum APIResult {
    case success(RepoSearchResult)
    case failure(Error)
}

