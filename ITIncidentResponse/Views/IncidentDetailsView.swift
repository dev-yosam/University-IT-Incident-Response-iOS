import SwiftUI

struct IncidentDetailsView: View {
    @State var viewModel: IncidentDetailsViewModel

    var body: some View {
        Group {
            if let incident = viewModel.incident {
                Form {
                    Section("Incident") {
                        LabeledContent("Reference", value: incident.id.value)
                        LabeledContent("Priority", value: incident.priority.displayName)
                        LabeledContent("Category", value: incident.category.displayName)
                        LabeledContent("Location", value: incident.campusLocation)
                        LabeledContent("Reported", value: incident.reportedAt.formatted(date: .abbreviated, time: .shortened))
                        LabeledContent("Status", value: incident.status.displayName)
                        LabeledContent(
                            "Technician",
                            value: incident.assignedTechnician?.fullName ?? "Unassigned"
                        )
                    }

                    Section("Issue") {
                        Text(incident.issueDescription)
                    }

                    Section {
                        if viewModel.canAccept {
                            Button("Accept Incident") {
                                viewModel.acceptIncident()
                            }
                        }

                        if incident.status == .inProgress {
                            NavigationLink("Work on this incident") {
                                ActiveIncidentView(incidentID: incident.id)
                            }
                        }
                    }
                }
                .navigationTitle(incident.title)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView(
                    "Incident not found",
                    systemImage: "ticket",
                    description: Text("Return to the queue and choose another incident.")
                )
            }
        }
        .alert(
            "Could not accept incident",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}
