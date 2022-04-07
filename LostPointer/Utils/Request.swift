import Foundation

public enum RequestMethods: String {
    case GET
    case POST
}


public final class Request {
    private static var baseUrl = "https://lostpointer.site/api/v1"
    public static func fetch(url: String, method: RequestMethods, data: Data?, successHandler: ((Data) -> Void)?, errorHandler: ((Error) -> Void)?) {
        let url = URL(string: baseUrl + url)!

        var request = URLRequest(url: url)
        if data != nil {
            request.httpBody = data
        }
        request.httpMethod = method.rawValue
        print(String(decoding: (request.httpBody)!, as: UTF8.self))
        print(url)
        
        print(request.httpMethod)
        
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
                failure(NSError(domain: "", code: -1, userInfo: nil))
                return
            }
            guard let data = data else {
                failure(NSError(domain: "", code: -2, userInfo: nil))
                return
            }
            if response.statusCode != 200 {
                failure(NSError(domain: "", code: -3, userInfo: nil))
                print("Request error: ", data)
                return
            }
            print(response.statusCode)
//            print(response.allHeaderFields)
            success(data)
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
        }
        task.resume()
    }
}
