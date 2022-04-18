import Foundation

public enum RequestMethods: String {
    case GET
    case POST
    case PATCH
}

struct CommonResponse: Decodable {
    let status: Int32
}

public final class Request {
    public static func fetch(url: String, method: RequestMethods, data: Data? = nil, successHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?) {
        let url = URL(string: Constants.baseRequestUrl + url)!

        var request = URLRequest(url: url)
        if data != nil {
            request.httpBody = data
        }

        let cookies = HTTPCookieStorage.shared.cookies(for: url)

        request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: cookies!)

//        print("Headers: >>>")
//        print(request.allHTTPHeaderFields)
//        print("Headers: <<<")

//        print("Headers after: >>>")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue
//        print(request.allHTTPHeaderFields)
//        print("Headers after: <<<")

        let failure = { (error: Error) in
            DispatchQueue.main.async {
                errorHandler?(error)
            }
        }

        let success = { (response: Data) in
            DispatchQueue.main.async {
                successHandler?(response)
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
//            print(String(decoding: data, as: UTF8.self))
            var code = 0
            do {
                let responseObject = try JSONDecoder().decode(CommonResponse.self, from: data)
                code = Int(responseObject.status)
            } catch {
                // Это не ошибка
            }

            if response.statusCode != 200 || (code != 0 && code != 200) {
                print(response.statusCode, code)
                failure(NSError(domain: "APIRequest", code: -5, userInfo: ["Error": "Response code is not 2xx"]))
                print("Request error: ", data)
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
