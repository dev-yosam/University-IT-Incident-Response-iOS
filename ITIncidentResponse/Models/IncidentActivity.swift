import Foundation

/// An action a technician took while working on an incident.
/// Work notes, resolutions and escalations are all recorded this way, so the
/// incident history always shows what was done, when, and by who.
protocol IncidentActivity {
    var occurredAt: Date { get }
    var performedByTechnicianID: TechnicianIdentifier { get }
    var activitySummary: String { get }
}
