import Foundation

/// Ticket ID shown on a campus IT incident, e.g. INC-2041.
struct IncidentReference: Hashable, CustomStringConvertible {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    var description: String { value }
}

/// Where the incident is in the service desk workflow.
/// New incidents start as queued. Work can only be added while in progress.
enum IncidentStatus: String, CaseIterable {
    case queued
    case inProgress
    case resolved
    case escalated

    var displayName: String {
        switch self {
        case .queued: return "Queued"
        case .inProgress: return "In Progress"
        case .resolved: return "Resolved"
        case .escalated: return "Escalated"
        }
    }
}

/// How soon a technician should pick up the incident.
enum IncidentPriority: String, CaseIterable {
    case low
    case medium
    case high
    case critical

    var displayName: String {
        switch self {
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .critical: return "Critical"
        }
    }
}

/// The type of campus IT problem.
/// Used to pick troubleshooting steps and which team to escalate to.
enum IncidentCategory: String, CaseIterable {
    case network
    case accountAccess
    case classroomTechnology
    case software
    case printing

    var displayName: String {
        switch self {
        case .network: return "Network"
        case .accountAccess: return "Account Access"
        case .classroomTechnology: return "Classroom Technology"
        case .software: return "Software"
        case .printing: return "Printing"
        }
    }
}

/// A campus IT problem reported to the service desk.
/// Starts in the queue with no technician. It must be accepted before notes,
/// resolution or escalation can be added.
struct ITIncident: Identifiable {
    let id: IncidentReference
    let title: String
    let issueDescription: String
    let category: IncidentCategory
    let priority: IncidentPriority
    let campusLocation: String
    let reportedAt: Date

    private(set) var status: IncidentStatus
    private(set) var assignedTechnician: SupportTechnician?
    private(set) var workNotes: [IncidentWorkNote]
    private(set) var resolution: IncidentResolution?
    private(set) var escalation: IncidentEscalation?

    init(
        id: IncidentReference,
        title: String,
        issueDescription: String,
        category: IncidentCategory,
        priority: IncidentPriority,
        campusLocation: String,
        reportedAt: Date,
        status: IncidentStatus = .queued,
        assignedTechnician: SupportTechnician? = nil,
        workNotes: [IncidentWorkNote] = [],
        resolution: IncidentResolution? = nil,
        escalation: IncidentEscalation? = nil
    ) {
        self.id = id
        self.title = title
        self.issueDescription = issueDescription
        self.category = category
        self.priority = priority
        self.campusLocation = campusLocation
        self.reportedAt = reportedAt
        self.status = status
        self.assignedTechnician = assignedTechnician
        self.workNotes = workNotes
        self.resolution = resolution
        self.escalation = escalation
    }

    var activityHistory: [any IncidentActivity] {
        var history: [any IncidentActivity] = workNotes
        if let resolution {
            history.append(resolution)
        }
        if let escalation {
            history.append(escalation)
        }
        return history.sorted { $0.occurredAt < $1.occurredAt }
    }

    mutating func assign(to technician: SupportTechnician) {
        assignedTechnician = technician
        status = .inProgress
    }

    mutating func record(_ workNote: IncidentWorkNote) {
        workNotes.append(workNote)
    }

    mutating func close(with resolution: IncidentResolution) {
        self.resolution = resolution
        status = .resolved
    }

    mutating func handOver(with escalation: IncidentEscalation) {
        self.escalation = escalation
        status = .escalated
    }
}
