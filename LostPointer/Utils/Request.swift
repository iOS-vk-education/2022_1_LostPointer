import Foundation

public enum RequestMethods: String {
    case GET
    case POST
}

struct CommonResponse: Decodable {
    let status: Int32
}


public final class Request {
    private static var baseUrl = "https://lostpointer.site/api/v1"
    public static func fetch(url: String, method: RequestMethods, data: Data?, successHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?) {
        let url = URL(string: baseUrl + url)!

        var request = URLRequest(url: url)
        if data != nil {
            request.httpBody = data
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = method.rawValue        
        
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
            var code = 0
            do {
                let responseObject = try JSONDecoder().decode(CommonResponse.self, from: data)
                code = Int(responseObject.status)
            } catch {
                failure(NSError(domain: "APIRequest", code: -4, userInfo: nil))
            }

            if response.statusCode != 200 || code != 200 {
                failure(NSError(domain: "APIRequest", code: -5, userInfo: nil))
                print("Request error: ", data)
                return
            }
            print(response.statusCode)
            success(data)

        }
        task.resume()
    }
}
