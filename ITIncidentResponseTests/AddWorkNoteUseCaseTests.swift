import Testing
@testable import ITIncidentResponse

struct AddWorkNoteUseCaseTests {
    @Test func addWorkNote_succeeds_forActiveIncident() throws {
        let repository = IncidentRepository()
        let technician = IncidentRepository.sampleTechnician
        let id = IncidentReference("INC-2041")
        _ = try AcceptIncidentUseCase(repository: repository).execute(incidentID: id, technician: technician)
        let useCase = AddWorkNoteUseCase(repository: repository)

        let incident = try useCase.execute(
            incidentID: id,
            noteText: "Tried reconnecting to campus Wi-Fi.",
            technician: technician
        )

        #expect(incident.workNotes.count == 1)
        #expect(incident.workNotes.first?.noteText == "Tried reconnecting to campus Wi-Fi.")
    }

    @Test func addWorkNote_fails_whenNoteIsWhitespaceOnly() throws {
        let repository = IncidentRepository()
        let technician = IncidentRepository.sampleTechnician
        let id = IncidentReference("INC-2041")
        _ = try AcceptIncidentUseCase(repository: repository).execute(incidentID: id, technician: technician)
        let useCase = AddWorkNoteUseCase(repository: repository)

        #expect(throws: AddWorkNoteError.emptyWorkNote) {
            try useCase.execute(incidentID: id, noteText: "   ", technician: technician)
        }
    }
}
