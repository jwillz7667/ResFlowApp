// App/Services/NetworkManager.swift

import Foundation
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://api.resflow.com" // Replace with your actual API base URL
    private let cache = URLCache.shared
    private var cancellables = Set<AnyCancellable>()
    private let logger = Logger()

    private init() {}

    func performRequest<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        retries: Int = 3,
        cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad
    ) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 30)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body

        return attemptRequest(request: request, retries: retries)
            .decode(type: T.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { data in
                let response = CachedURLResponse(response: request.urlResponse!, data: data)
                self.cache.storeCachedResponse(response, for: request)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func attemptRequest(
        request: URLRequest,
        retries: Int,
        delay: Double = 1.0
    ) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                self.logger.logRequest(request, response: httpResponse, data: result.data)
                if (200...299).contains(httpResponse.statusCode) {
                    return result.data
                } else {
                    throw URLError(.init(rawValue: httpResponse.statusCode))
                }
            }
            .catch { error -> AnyPublisher<Data, Error> in
                guard retries > 0 else { return Fail(error: error).eraseToAnyPublisher() }
                let newDelay = delay * 2
                return Just(Void())
                    .delay(for: .seconds(newDelay), scheduler: DispatchQueue.global())
                    .flatMap { self.attemptRequest(request: request, retries: retries - 1, delay: newDelay) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func cachedResponse<T: Decodable>(for endpoint: String) -> T? {
        guard let url = URL(string: "\(baseURL)/\(endpoint)"),
              let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
              let decodedResponse = try? JSONDecoder().decode(T.self, from: cachedResponse.data) else {
            return nil
        }
        return decodedResponse
    }
}

class Logger {
    func logRequest(_ request: URLRequest, response: HTTPURLResponse, data: Data) {
        print("Request to \(request.url?.absoluteString ?? "") returned status code \(response.statusCode)")
        if let body = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
            print("Response Body: \(body)")
        } else {
            print("Failed to parse response body")
        }
    }
}
