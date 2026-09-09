import Foundation

/// How the technician fixed the incident before closing it.
/// A summary is required.
struct IncidentResolution: IncidentActivity {
    let resolutionSummary: String
    let occurredAt: Date
    let performedByTechnicianID: TechnicianIdentifier

    var activitySummary: String {
        "Resolved — \(resolutionSummary)"
    }
}
