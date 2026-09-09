import Foundation

/// Error when a technician tries to close an incident.
enum ResolveIncidentError: LocalizedError {
    case incidentNotFound
    case incidentNotActive
    case missingResolutionSummary

    var errorDescription: String? {
        switch self {
        case .incidentNotFound:
            return "This incident could not be found. Return to the queue and choose another incident."
        case .incidentNotActive:
            return "Only an in-progress incident can be resolved. Accept it from the queue first."
        case .missingResolutionSummary:
            return "Add a resolution summary before closing this incident so future technicians can see what fixed the problem."
        }
    }
}

/// Closes an active incident after the technician has fixed the problem.
/// The incident must be in progress and a resolution summary is required.
struct ResolveIncidentUseCase {
    let repository: IncidentRepository

    func execute(incidentID: IncidentReference, resolutionSummary: String, technician: SupportTechnician) throws -> ITIncident {
        guard var incident = repository.incident(withReference: incidentID) else {
            throw ResolveIncidentError.incidentNotFound
        }

        if incident.status != .inProgress {
            throw ResolveIncidentError.incidentNotActive
        }

        let trimmedSummary = resolutionSummary.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedSummary.isEmpty {
            throw ResolveIncidentError.missingResolutionSummary
        }

        let resolution = IncidentResolution(
            resolutionSummary: trimmedSummary,
            occurredAt: Date(),
            performedByTechnicianID: technician.id
        )
        incident.close(with: resolution)
        repository.save(incident)
        return incident
    }
}
