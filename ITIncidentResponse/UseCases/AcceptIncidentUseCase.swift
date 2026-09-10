import Foundation

/// Error when a technician tries to accept an incident from the queue.
enum AcceptIncidentError: LocalizedError, Equatable {
    case incidentNotFound
    case incidentAlreadyAssigned
    case incidentNotAvailable

    var errorDescription: String? {
        switch self {
        case .incidentNotFound:
            return "This incident could not be found. Return to the queue and choose another incident."
        case .incidentAlreadyAssigned:
            return "This incident is already assigned to a technician. Return to the queue and choose another incident."
        case .incidentNotAvailable:
            return "This incident is no longer available in the queue. Return to the queue and choose another incident."
        }
    }
}

/// Lets a technician take a queued incident and start working on it.
/// The incident must be in the queue and not already assigned.
struct AcceptIncidentUseCase {
    let repository: IncidentRepository

    func execute(incidentID: IncidentReference, technician: SupportTechnician) throws -> ITIncident {
        guard var incident = repository.incident(withReference: incidentID) else {
            throw AcceptIncidentError.incidentNotFound
        }

        if incident.assignedTechnician != nil {
            throw AcceptIncidentError.incidentAlreadyAssigned
        }

        if incident.status != .queued {
            throw AcceptIncidentError.incidentNotAvailable
        }

        incident.assign(to: technician)
        repository.save(incident)
        return incident
    }
}
