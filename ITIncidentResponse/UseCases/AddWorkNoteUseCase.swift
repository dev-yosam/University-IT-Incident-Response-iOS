import Foundation

/// Error when a technician tries to add an investigation note.
enum AddWorkNoteError: LocalizedError, Equatable {
    case incidentNotFound
    case incidentNotActive
    case emptyWorkNote

    var errorDescription: String? {
        switch self {
        case .incidentNotFound:
            return "This incident could not be found. Return to the queue and choose another incident."
        case .incidentNotActive:
            return "Notes can only be added while the incident is in progress. Open an active incident first."
        case .emptyWorkNote:
            return "Add a short diagnostic note before saving so the investigation history is clear."
        }
    }
}

/// Records a diagnostic note on an incident the technician is working on.
/// The incident must be in progress and the note cannot be empty.
struct AddWorkNoteUseCase {
    let repository: IncidentRepository

    func execute(incidentID: IncidentReference, noteText: String, technician: SupportTechnician) throws -> ITIncident {
        guard var incident = repository.incident(withReference: incidentID) else {
            throw AddWorkNoteError.incidentNotFound
        }

        if incident.status != .inProgress {
            throw AddWorkNoteError.incidentNotActive
        }

        let trimmedNote = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedNote.isEmpty {
            throw AddWorkNoteError.emptyWorkNote
        }

        let workNote = IncidentWorkNote(
            noteText: trimmedNote,
            occurredAt: Date(),
            performedByTechnicianID: technician.id
        )
        incident.record(workNote)
        repository.save(incident)
        return incident
    }
}
