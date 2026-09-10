import Testing
@testable import ITIncidentResponse

struct ResolveIncidentUseCaseTests {
    @Test func resolveIncident_succeeds_withResolutionSummary() throws {
        let repository = IncidentRepository()
        let technician = IncidentRepository.sampleTechnician
        let id = IncidentReference("INC-2041")
        _ = try AcceptIncidentUseCase(repository: repository).execute(incidentID: id, technician: technician)
        let useCase = ResolveIncidentUseCase(repository: repository)

        let incident = try useCase.execute(
            incidentID: id,
            resolutionSummary: "Access point was reset and devices reconnected.",
            technician: technician
        )

        #expect(incident.status == .resolved)
        #expect(incident.resolution?.resolutionSummary == "Access point was reset and devices reconnected.")
    }

    @Test func resolveIncident_fails_whenResolutionSummaryIsEmpty() throws {
        let repository = IncidentRepository()
        let technician = IncidentRepository.sampleTechnician
        let id = IncidentReference("INC-2041")
        _ = try AcceptIncidentUseCase(repository: repository).execute(incidentID: id, technician: technician)
        let useCase = ResolveIncidentUseCase(repository: repository)

        #expect(throws: ResolveIncidentError.missingResolutionSummary) {
            try useCase.execute(incidentID: id, resolutionSummary: "   ", technician: technician)
        }
    }

    @Test func resolveIncident_fails_whenIncidentIsNotActive() {
        let repository = IncidentRepository()
        let useCase = ResolveIncidentUseCase(repository: repository)
        let technician = IncidentRepository.sampleTechnician
        let id = IncidentReference("INC-2041")

        #expect(throws: ResolveIncidentError.incidentNotActive) {
            try useCase.execute(
                incidentID: id,
                resolutionSummary: "Access point was reset.",
                technician: technician
            )
        }
    }
}
