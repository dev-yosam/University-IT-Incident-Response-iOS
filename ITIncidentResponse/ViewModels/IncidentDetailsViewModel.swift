import Foundation
import Observation

@Observable
final class IncidentDetailsViewModel {
    let incidentID: IncidentReference
    private let repository: IncidentRepository
    var errorMessage: String?

    init(incidentID: IncidentReference, repository: IncidentRepository) {
        self.incidentID = incidentID
        self.repository = repository
    }

    var incident: ITIncident? {
        repository.incident(withReference: incidentID)
    }

    var canAccept: Bool {
        incident?.status == .queued
    }

    func acceptIncident() {
        errorMessage = nil
        do {
            _ = try AcceptIncidentUseCase(repository: repository).execute(
                incidentID: incidentID,
                technician: repository.signedInTechnician
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
