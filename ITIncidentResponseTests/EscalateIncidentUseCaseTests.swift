import Testing
@testable import ITIncidentResponse

struct EscalateIncidentUseCaseTests {
    @Test func escalateIncident_succeeds_withTargetAndReason() throws {
        let repository = IncidentRepository()
        let technician = IncidentRepository.sampleTechnician
        let id = IncidentReference("INC-2041")
        _ = try AcceptIncidentUseCase(repository: repository).execute(incidentID: id, technician: technician)
        let useCase = EscalateIncidentUseCase(repository: repository)

        let incident = try useCase.execute(
            incidentID: id,
            target: .networkServices,
            reason: "Building-wide outage, needs Network Services.",
            technician: technician
        )

        #expect(incident.status == .escalated)
        #expect(incident.escalation?.target == .networkServices)
        #expect(incident.escalation?.escalationReason == "Building-wide outage, needs Network Services.")
    }

    @Test func escalateIncident_fails_whenReasonIsEmpty() throws {
        let repository = IncidentRepository()
        let technician = IncidentRepository.sampleTechnician
        let id = IncidentReference("INC-2041")
        _ = try AcceptIncidentUseCase(repository: repository).execute(incidentID: id, technician: technician)
        let useCase = EscalateIncidentUseCase(repository: repository)

        #expect(throws: EscalateIncidentError.missingEscalationReason) {
            try useCase.execute(
                incidentID: id,
                target: .networkServices,
                reason: "   ",
                technician: technician
            )
        }
    }
}
