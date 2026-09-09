import Foundation

/// Error when a technician tries to hand an incident to a specialist team.
enum EscalateIncidentError: LocalizedError {
    case incidentNotFound
    case incidentNotActive
    case missingEscalationReason
    case missingEscalationTarget

    var errorDescription: String? {
        switch self {
        case .incidentNotFound:
            return "This incident could not be found. Return to the queue and choose another incident."
        case .incidentNotActive:
            return "Only an in-progress incident can be escalated. Accept it from the queue first."
        case .missingEscalationReason:
            return "Choose the specialist team and explain why the incident needs escalation before continuing."
        case .missingEscalationTarget:
            return "Choose the specialist team and explain why the incident needs escalation before continuing."
        }
    }
}

/// Hands an active incident to a specialist team.
/// The incident must be in progress. A team and a reason are both required.
struct EscalateIncidentUseCase {
    let repository: IncidentRepository

    func execute(
        incidentID: IncidentReference,
        target: EscalationTarget?,
        reason: String,
        technician: SupportTechnician
    ) throws -> ITIncident {
        guard var incident = repository.incident(withReference: incidentID) else {
            throw EscalateIncidentError.incidentNotFound
        }

        if incident.status != .inProgress {
            throw EscalateIncidentError.incidentNotActive
        }

        guard let target else {
            throw EscalateIncidentError.missingEscalationTarget
        }

        let trimmedReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedReason.isEmpty {
            throw EscalateIncidentError.missingEscalationReason
        }

        let escalation = IncidentEscalation(
            target: target,
            escalationReason: trimmedReason,
            occurredAt: Date(),
            performedByTechnicianID: technician.id
        )
        incident.handOver(with: escalation)
        repository.save(incident)
        return incident
    }
}
