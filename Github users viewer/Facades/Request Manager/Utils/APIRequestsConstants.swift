
import Foundation

enum ErrorCodes: Int {

    // ios system codes
    case NoConnectionCode = -1009
    case TimeoutConnectionCode = -1001

    // http real codes
    case BadRequesStatusCode = 400
    case UnauthorizedStatusCode = 401
    case ErrorRequesStatusCode = 406
    case InternalServerError = 500

    //default
    case UnknownError = -999

    case Success = 200

}

let GithubDomain = "com.github"

enum APIRequestsURL: String {
    case ListOfUsersURL = "users";
}

protocol APIURLProviderProtocol : class {
    var baseURL: String {get}

    func URL(url:APIRequestsURL, path: String?) -> URL?
}


extension APIURLProviderProtocol {
    func URL(url:APIRequestsURL, path: String? = nil) -> URL? {
        return URL(url: url, path: path)
    }
}


class APIURLProvider: APIURLProviderProtocol {
    var baseURL = "https://api.github.com"
    
    func URL(url:APIRequestsURL, path: String?) -> URL? {
        var url = NSURL(string: baseURL)?.appendingPathComponent(url.rawValue)
        if let path = path {
            url = url?.appendingPathComponent(path)
        }
        return url
    }

}


// MARK:- Locator

class APIURLProviderLocator {
    private static var provider: APIURLProvider = APIURLProvider()

    static func URLProvider(provider: APIURLProvider) {
        APIURLProviderLocator.provider = provider
    }

    static var sharedProvider: APIURLProvider {
        return APIURLProviderLocator.provider
    }
}
