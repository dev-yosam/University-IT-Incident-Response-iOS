import SwiftUI

struct ActiveIncidentView: View {
    let incidentID: IncidentReference
    @Environment(IncidentRepository.self) private var repository

    var body: some View {
        Group {
            if let incident = repository.incident(withReference: incidentID) {
                Form {
                    Section("Issue") {
                        Text(incident.title)
                            .font(.headline)
                        Text(incident.issueDescription)
                    }
                }
                .navigationTitle("Active Incident")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView(
                    "Incident not found",
                    systemImage: "ticket",
                    description: Text("Return to the queue and choose another incident.")
                )
            }
        }
    }
}
