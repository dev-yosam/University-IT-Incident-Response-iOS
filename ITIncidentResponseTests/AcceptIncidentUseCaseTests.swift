import Testing
@testable import ITIncidentResponse

struct AcceptIncidentUseCaseTests {
    @Test @MainActor func acceptIncident_succeeds_whenIncidentIsQueued() throws {
        let repository = IncidentRepository()
        let useCase = AcceptIncidentUseCase(repository: repository)
        let technician = IncidentRepository.sampleTechnician
        let id = IncidentReference("INC-2041")

        let incident = try useCase.execute(incidentID: id, technician: technician)

        #expect(incident.status == .inProgress)
        #expect(incident.assignedTechnician?.id == technician.id)
    }

    @Test func acceptIncident_fails_whenIncidentIsAlreadyAssigned() throws {
        let repository = IncidentRepository()
        let useCase = AcceptIncidentUseCase(repository: repository)
        let technician = IncidentRepository.sampleTechnician
        let id = IncidentReference("INC-2041")
        _ = try useCase.execute(incidentID: id, technician: technician)

        #expect(throws: AcceptIncidentError.incidentAlreadyAssigned) {
            try useCase.execute(incidentID: id, technician: technician)
        }
    }
}
