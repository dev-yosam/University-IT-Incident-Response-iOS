import Foundation

/// Specialist team that takes over when first-line support cannot fix the issue.
enum EscalationTarget: String, CaseIterable, Identifiable {
    case networkServices
    case identityAndAccess
    case classroomAV
    case desktopSupport

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .networkServices: return "Network Services"
        case .identityAndAccess: return "Identity & Access"
        case .classroomAV: return "Classroom AV"
        case .desktopSupport: return "Desktop Support"
        }
    }
}

/// Record of handing an incident to a specialist team.
/// Needs a team and a reason.
struct IncidentEscalation: IncidentActivity {
    let target: EscalationTarget
    let escalationReason: String
    let occurredAt: Date
    let performedByTechnicianID: TechnicianIdentifier

    var activitySummary: String {
        "Escalated to \(target.displayName) — \(escalationReason)"
    }
}
