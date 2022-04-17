import UIKit

struct UserModel: Codable {
    let email, password, nickname, bigAvatar, oldPassword: String?

    enum CodingKeys: String, CodingKey {
        case email, password, nickname
        case bigAvatar = "big_avatar"
        case oldPassword = "old_password"
    }

    init(email: String? = nil, password: String? = nil, nickname: String? = nil,
         bigAvatar: String? = nil, oldPassword: String? = nil) {
        self.email = email
        self.password = password
        self.nickname = nickname
        self.bigAvatar = bigAvatar
        self.oldPassword = oldPassword
    }

    public static func authenticate(email: String, password: String, onSuccess: @escaping () -> Void?, onError: @escaping () -> Void?) {
        let data = try? JSONEncoder().encode(UserModel(email: email, password: password))
        Request.fetch(url: "/user/signin", method: RequestMethods.POST, data: data, successHandler: {(_: Data) -> Void in
            onSuccess()
        }, errorHandler: {(err: Error) -> Void in
            print(err)
            onError()
        })
    }

    public static func checkAuth(onSuccess: @escaping () -> Void?, onError: @escaping () -> Void?) {
        Request.fetch(url: "/auth", method: RequestMethods.GET, successHandler: {(_) -> Void in
            onSuccess()
        }, errorHandler: {(_) -> Void in
            onError()
        })
    }

    public static func logout(onSuccess: @escaping() -> Void?, onError: @escaping (Error) -> Void?) {
        Request.fetch(url: "/user/logout", method: RequestMethods.POST, successHandler: {(_) -> Void in
            onSuccess()
        }, errorHandler: {(err: Error) -> Void in
            onError(err)
        })
    }

    public static func getProfileData(onSuccess: @escaping(Data) -> Void?, onError: @escaping (Error) -> Void?) {
        Request.fetch(url: "/user/settings", method: RequestMethods.GET, successHandler: {(data: Data) -> Void in
        onSuccess(data)
        }, errorHandler: {(error: Error) -> Void in
            onError(error)
        })
    }

    public func validateProfileData(onSuccess: () -> Void, onError: (String) -> Void) {
        if nickname != nil {

        }

        if email != nil {
            if !email!.isEmail() {
                onError("Incorrect email")
            }
        }

        if oldPassword != nil && password != nil {

        }
    }

    public func updateProfileData(onSuccess: () -> Void, onError: (String) -> Void) {
        validateProfileData(onSuccess: {() -> Void in
            print("Updating")
        }, onError: {(err: String) -> Void in
            onError(err)
        })
    }
}
