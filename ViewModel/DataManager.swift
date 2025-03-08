//
//  DataManager.swift
//  Shaadi.com
//

import Foundation
import Combine

/// Protocol for DataManager
protocol DataManagerProtocol {
    func fetchMatchDetails() -> AnyPublisher<[MatchDetailsModel], Error>
    func updateMatchStatus(uuid: String, isAccepted: Bool) -> AnyPublisher<Void, Error>
}

class DataManager: NSObject, DataManagerProtocol {
    private let apiUrl = "https://randomuser.me/api/?results=10"
    
    /// Need api to update the button click status
    private let updateStatus = "https://randomuser.me/api/?results"
    
    /// Fetch match details from the API
    func fetchMatchDetails() -> AnyPublisher<[MatchDetailsModel], Error> {
        guard let url = URL(string: apiUrl) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveOutput: { output in
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("Response from server: \(jsonString)")
                }
            })
            .map(\.data)
            .decode(type: MatchDetailsResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    func updateMatchStatus(uuid: String, isAccepted: Bool) -> AnyPublisher<Void, Error> {
        guard let url = URL(string: updateStatus) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "uuid": uuid,
            "status": isAccepted ? "accepted" : "rejected"
        ], options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return URLSession.shared.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { output in
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("Response from server: \(jsonString)")
                }
            })
            .map { _ in () }
            .mapError { $0 as Error }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct MatchDetailsResponse: Codable {
    let results: [MatchDetailsModel]
}
