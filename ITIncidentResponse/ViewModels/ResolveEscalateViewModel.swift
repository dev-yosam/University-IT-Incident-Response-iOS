import Foundation
import Observation

@Observable
final class ResolveEscalateViewModel {
    let incidentID: IncidentReference
    private let repository: IncidentRepository
    var resolutionSummary = ""
    var escalationReason = ""
    var selectedTarget: EscalationTarget?
    var errorMessage: String?
    var confirmResolve = false

    init(incidentID: IncidentReference, repository: IncidentRepository) {
        self.incidentID = incidentID
        self.repository = repository
    }

    func resolveIncident() {
        errorMessage = nil
        do {
            _ = try ResolveIncidentUseCase(repository: repository).execute(
                incidentID: incidentID,
                resolutionSummary: resolutionSummary,
                technician: repository.signedInTechnician
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func escalateIncident() {
        errorMessage = nil
        do {
            _ = try EscalateIncidentUseCase(repository: repository).execute(
                incidentID: incidentID,
                target: selectedTarget,
                reason: escalationReason,
                technician: repository.signedInTechnician
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
