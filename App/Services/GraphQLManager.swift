// App/Services/GraphQLManager.swift

import Foundation
import Combine

class GraphQLManager {
    static let shared = GraphQLManager()
    private let baseURL = "https://api.resflow.com/graphql" // Replace with your actual GraphQL API endpoint
    private let cache = URLCache.shared
    private var cancellables = Set<AnyCancellable>()
    private let logger = Logger()

    private init() {}

    func performQuery<T: Decodable>(
        query: String,
        variables: [String: Any]? = nil,
        retries: Int = 3,
        cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad
    ) -> AnyPublisher<T, Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: 30)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        var body: [String: Any] = ["query": query]
        if let variables = variables {
            body["variables"] = variables
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        return attemptQuery(request: request, retries: retries)
            .decode(type: T.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { data in
                let response = CachedURLResponse(response: request.urlResponse!, data: data)
                self.cache.storeCachedResponse(response, for: request)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private func attemptQuery(
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
                    .flatMap { self.attemptQuery(request: request, retries: retries - 1, delay: newDelay) }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func cachedResponse<T: Decodable>(for query: String, variables: [String: Any]? = nil) -> T? {
        guard let url = URL(string: baseURL),
              let cachedResponse = cache.cachedResponse(for: URLRequest(url: url)),
              let decodedResponse = try? JSONDecoder().decode(T.self, from: cachedResponse.data) else {
            return nil
        }
        return decodedResponse
    }
}
