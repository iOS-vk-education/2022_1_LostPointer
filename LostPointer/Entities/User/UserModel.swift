import UIKit

struct UserModel: Codable {
    let email, password, nickname, bigAvatar: String?

    enum CodingKeys: String, CodingKey {
        case email, password, nickname
        case bigAvatar = "big_avatar"
    }

    init(email: String, password: String, nickname: String? = nil, bigAvatar: String? = nil) {
        self.email = email
        self.password = password
        self.nickname = nickname
        self.bigAvatar = bigAvatar
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
}
