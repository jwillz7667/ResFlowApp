// App/Services/AuthenticationService.swift

import Foundation
import Alamofire

class AuthenticationService {
    static let shared = AuthenticationService()

    private init() {}

    func signUp(
        name: String,
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        let parameters: [String: Any] = [
            "name": name,
            "email": email,
            "password": password
        ]

        AF.request("https://api.resflow.com/auth/signup", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }

    func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]

        AF.request("https://api.resflow.com/auth/signin", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
