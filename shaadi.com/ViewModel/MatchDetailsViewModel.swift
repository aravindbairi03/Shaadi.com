//
//  MatchDetailsViewModel.swift
//  Shaadi.com
import Foundation
import Combine
import SwiftData

class MatchDetailsViewModel: ObservableObject {
    @Published var matchDetails: [MatchDetailsEntity] = []
    @Published var errorMessage: String? = nil

    private var dataManager: DataManagerProtocol
    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()

    init(dataManager: DataManagerProtocol, modelContext: ModelContext) {
        self.dataManager = dataManager
        self.modelContext = modelContext
        getMatchDetails()
    }

    /// Fetch and store match details
    func getMatchDetails() {
        if NetworkManager.shared.isInternetAvailable() {
            fetchAndSaveMatchDetails()
        } else {
            getDetailsFromSwiftData()
        }
    }

    private func fetchAndSaveMatchDetails() {
        dataManager.fetchMatchDetails()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                    self?.getDetailsFromSwiftData()
                }
            }, receiveValue: { [weak self] details in
                self?.saveToSwiftData(details)
            })
            .store(in: &cancellables)
    }

    private func saveToSwiftData(_ details: [MatchDetailsModel]) {
        try? modelContext.delete(model: MatchDetailsEntity.self)

        for match in details {
            let entity = MatchDetailsEntity(
                firstName: match.name.first,
                lastName: match.name.last,
                title: match.name.title,
                largeImage: match.picture.large,
                state: match.location.state,
                streetName: match.location.street.name,
                streetNumber: match.location.street.number,
                uuid: match.login.uuid
            )
            modelContext.insert(entity)
        }

        try? modelContext.save()
        getDetailsFromSwiftData()
    }

    private func getDetailsFromSwiftData() {
        let descriptor = FetchDescriptor<MatchDetailsEntity>()
        if let cachedData = try? modelContext.fetch(descriptor) {
            self.matchDetails = cachedData
        } else {
            errorMessage = "Data not available."
        }
    }

    /// Handle Accept/Reject action
    func handleMatchAction(uuid: String, isAccepted: Bool) {
        if NetworkManager.shared.isInternetAvailable() {
            updateMatchStatus(uuid: uuid, isAccepted: isAccepted)
        } else {
            cachePendingAction(uuid: uuid, isAccepted: isAccepted)
        }
    }

    /// Update the match status via API
    private func updateMatchStatus(uuid: String, isAccepted: Bool) {
        dataManager.updateMatchStatus(uuid: uuid, isAccepted: isAccepted)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error updating status: \(error.localizedDescription)")
                    self.cachePendingAction(uuid: uuid, isAccepted: isAccepted)
                }
            }, receiveValue: {
                print("Status updated successfully")
            })
            .store(in: &cancellables)
    }

    /// Cache action for retrying later when online
    private func cachePendingAction(uuid: String, isAccepted: Bool) {
        let cachedAction = CachedAction(uuid: uuid, status: isAccepted)
        var cachedActions = UserDefaults.standard.getCachedActions()
        cachedActions.append(cachedAction)
        UserDefaults.standard.saveCachedActions(cachedActions)
    }

    /// Retry cached actions when network is available
    func retryCachedActions() {
        guard NetworkManager.shared.isInternetAvailable() else { return }
        let cachedActions = UserDefaults.standard.getCachedActions()

        for action in cachedActions {
            updateMatchStatus(uuid: action.uuid, isAccepted: action.status)
        }

        UserDefaults.standard.clearCachedActions()
    }
}

/// Model to store cached actions
struct CachedAction: Codable {
    let uuid: String
    let status: Bool
}

/// UserDefaults extension to store cached actions
extension UserDefaults {
    private static let cachedActionsKey = "cachedActions"

    func saveCachedActions(_ actions: [CachedAction]) {
        if let data = try? JSONEncoder().encode(actions) {
            set(data, forKey: UserDefaults.cachedActionsKey)
        }
    }

    func getCachedActions() -> [CachedAction] {
        guard let data = data(forKey: UserDefaults.cachedActionsKey),
              let actions = try? JSONDecoder().decode([CachedAction].self, from: data) else {
            return []
        }
        return actions
    }

    func clearCachedActions() {
        removeObject(forKey: UserDefaults.cachedActionsKey)
    }
}
