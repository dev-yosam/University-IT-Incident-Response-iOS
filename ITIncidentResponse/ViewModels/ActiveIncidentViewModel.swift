import Foundation
import Observation

@Observable
final class ActiveIncidentViewModel {
    let incidentID: IncidentReference
    private let repository: IncidentRepository
    var draftNote = ""
    var errorMessage: String?

    init(incidentID: IncidentReference, repository: IncidentRepository) {
        self.incidentID = incidentID
        self.repository = repository
    }

    func addWorkNote() {
        errorMessage = nil
        do {
            _ = try AddWorkNoteUseCase(repository: repository).execute(
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
