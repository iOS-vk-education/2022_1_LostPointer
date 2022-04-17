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
    
    public func authenticate(onSuccess: @escaping ()->Void?, onError: @escaping () -> Void?) {
        let data = try? JSONEncoder().encode(UserModel(email: email, password: password))
        Request.fetch(url: "/user/signin", method: RequestMethods.POST, data: data, successHandler: {(_: Data) -> Void in
            onSuccess()
        }, errorHandler: {(err: Error) -> Void in
            print(err)
            onError()
        })
    }
    
    public static func checkAuth(onSuccess: @escaping () -> Void?, onError: @escaping () -> Void?) {
        Request.fetch(url: "/auth", method: RequestMethods.GET, successHandler: {(_)->Void in
            onSuccess()
        }, errorHandler: {(_) -> Void in
            onError()
        })
    }
}
