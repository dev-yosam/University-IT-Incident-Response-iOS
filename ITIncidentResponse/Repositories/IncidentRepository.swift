import Foundation
import Observation

/// In-memory list of incidents for this demo.
/// Shared by the screens so they all see the same queue. Business rules live in
/// the use cases, not here.
@Observable
final class IncidentRepository {
    private(set) var incidents: [ITIncident]
    let signedInTechnician: SupportTechnician

    init(
        incidents: [ITIncident] = IncidentRepository.sampleIncidents,
        signedInTechnician: SupportTechnician = IncidentRepository.sampleTechnician
    ) {
        self.incidents = incidents
        self.signedInTechnician = signedInTechnician
    }

    func incident(withReference reference: IncidentReference) -> ITIncident? {
        incidents.first { $0.id == reference }
    }

    func save(_ incident: ITIncident) {
        guard let index = incidents.firstIndex(where: { $0.id == incident.id }) else { return }
        incidents[index] = incident
    }
}

extension IncidentRepository {
    static let sampleTechnician = SupportTechnician(
        id: TechnicianIdentifier("TECH-07"),
        fullName: "Alex Nguyen"
    )

    /// Sample incidents for the demo. Not from a real service desk.
    static var sampleIncidents: [ITIncident] {
        [
            ITIncident(
                id: IncidentReference("INC-2041"),
                title: "Lecture Hall Wi-Fi Unavailable",
                issueDescription: "Multiple devices cannot connect to the campus Wi-Fi in the lecture hall before a scheduled class.",
                category: .network,
                priority: .high,
                campusLocation: "Building 11, Level 3",
                reportedAt: Date(timeIntervalSinceNow: -1_800)
            ),
            ITIncident(
                id: IncidentReference("INC-2042"),
                title: "Projector Shows No Signal",
                issueDescription: "The teaching laptop is connected but the ceiling projector reports no input signal.",
                category: .classroomTechnology,
                priority: .medium,
                campusLocation: "Building 2, Room 204",
                reportedAt: Date(timeIntervalSinceNow: -5_400)
            ),
            ITIncident(
                id: IncidentReference("INC-2043"),
                title: "Staff Account Locked After Password Reset",
                issueDescription: "A staff member cannot sign in to campus services after resetting their password this morning.",
                category: .accountAccess,
                priority: .high,
                campusLocation: "Student Services, Level 1",
                reportedAt: Date(timeIntervalSinceNow: -9_000)
            ),
            ITIncident(
                id: IncidentReference("INC-2044"),
                title: "Lab Computer Cannot Print",
                issueDescription: "One workstation cannot send jobs to the lab printer while other machines in the room can.",
                category: .printing,
                priority: .low,
                campusLocation: "Building 6, Computer Lab 3",
                reportedAt: Date(timeIntervalSinceNow: -14_400)
            ),
            ITIncident(
                id: IncidentReference("INC-2045"),
                title: "Exam Software Fails to Launch",
                issueDescription: "The invigilated exam application closes immediately on launch in a room booked for an assessment this afternoon.",
                category: .software,
                priority: .critical,
                campusLocation: "Building 4, Room 118",
                reportedAt: Date(timeIntervalSinceNow: -900)
            )
        ]
    }
}
