import UIKit

struct UserModel: Codable {
    let email, password: String

    enum CodingKeys: String, CodingKey {
        case email, password
    }
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    public func authenticate() {
        let data = try? JSONEncoder().encode(UserModel(email: email, password: password))
        Request.fetch(url: "/user/signin", method: RequestMethods.POST, data: data, successHandler: {(data: Data) -> Void in
            print(String(decoding: data, as: UTF8.self))
        }, errorHandler: nil)
    }
}
