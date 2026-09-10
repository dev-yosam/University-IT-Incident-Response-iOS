import Foundation
import Observation

@Observable
final class ActiveIncidentViewModel {
    let incidentID: IncidentReference
    private let repository: IncidentRepository
    var draftNote = ""
    var errorMessage: String?
    var incident: ITIncident?

    init(incidentID: IncidentReference, repository: IncidentRepository) {
        self.incidentID = incidentID
        self.repository = repository
        self.incident = repository.incident(withReference: incidentID)
    }

    func addWorkNote() {
        errorMessage = nil
        do {
            incident = try AddWorkNoteUseCase(repository: repository).execute(
                incidentID: incidentID,
                noteText: draftNote,
                technician: repository.signedInTechnician
            )
            draftNote = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
