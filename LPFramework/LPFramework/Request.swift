import Foundation

public enum RequestMethods: String {
    case GET
    case POST
    case PATCH
    case DELETE
}

public struct MessageModel: Codable {
    var status: Int?
    var message: String?

    enum CodingKeys: String, CodingKey {
        case status, message
    }
}

struct CommonResponse: Decodable {
    let status: Int32
}

public final class Request {
    public static func getCookie() -> [HTTPCookie] {
        guard let url = URL(string: Constants.baseUrl) else { return [] }
        guard let cookies = HTTPCookieStorage.shared.cookies(for: url) else { return [] }
        return cookies
    }
    public static func fetch(url: String, method: RequestMethods, data: Data? = nil,
                             onSuccess: ((Data) -> Void)?, onError: ((Error) -> Void)?) {
        guard let url = URL(string: Constants.baseRequestUrl + url) else {
            return
        }

        var request = URLRequest(url: url)
        if data != nil {
            request.httpBody = data
        }

        guard let cookies = HTTPCookieStorage.shared.cookies(for: url) else { return }
        request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue

        let failure = { (error: Error) in
            DispatchQueue.main.async {
                onError?(error)
            }
        }

        let success = { (response: Data) in
            DispatchQueue.main.async {
                onSuccess?(response)
            }
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                failure(error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                failure(NSError(domain: "APIRequest", code: -1, userInfo: nil))
                return
            }
            guard let data = data else {
                failure(NSError(domain: "APIRequest", code: -2, userInfo: nil))
                return
            }
            var code = 0
            do {
                let responseObject = try JSONDecoder().decode(CommonResponse.self, from: data)
                code = Int(responseObject.status)
            } catch {
                // Это не ошибка
            }

            if response.statusCode != 200 && response.statusCode != 201 || (code != 0 && code != 200 && code != 201) {
                debugPrint(response.statusCode, code)
                failure(NSError(domain: "APIRequest", code: -5, userInfo: ["Error": "Response code is not 2xx"]))
                debugPrint("Request error: ", data)
                return
            }

            guard let url = URL(string: Constants.baseUrl) else {return}

            HTTPCookieStorage.shared.cookies(
                for: (response.url ?? url))
            success(data)

        }
        task.resume()
    }
}
