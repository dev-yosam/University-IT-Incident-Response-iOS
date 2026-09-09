import Foundation

/// A diagnostic note added while investigating an incident.
/// The note cannot be empty.
struct IncidentWorkNote: Identifiable, IncidentActivity {
    let id: UUID
    let noteText: String
    let occurredAt: Date
    let performedByTechnicianID: TechnicianIdentifier

    init(
        id: UUID = UUID(),
        noteText: String,
        occurredAt: Date,
        performedByTechnicianID: TechnicianIdentifier
    ) {
        self.id = id
        self.noteText = noteText
        self.occurredAt = occurredAt
        self.performedByTechnicianID = performedByTechnicianID
    }

    var activitySummary: String {
        noteText
    }
}
