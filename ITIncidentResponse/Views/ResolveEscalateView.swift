import SwiftUI

struct ResolveEscalateView: View {
    @Bindable var viewModel: ResolveEscalateViewModel
    @Environment(IncidentRepository.self) private var repository

    private var incident: ITIncident? {
        repository.incident(withReference: viewModel.incidentID)
    }

    var body: some View {
        Group {
            if let incident {
                Form {
                    Section("Status") {
                        LabeledContent("Incident", value: incident.title)
                        LabeledContent("Status", value: incident.status.displayName)
                    }

                    if incident.status == .inProgress {
                        Section("Resolve") {
                            TextField("Resolution summary", text: $viewModel.resolutionSummary, axis: .vertical)
                                .lineLimit(3...6)
                            Button("Resolve Incident") {
                                viewModel.confirmResolve = true
                            }
                        }

                        Section("Escalate") {
                            Picker("Specialist Team", selection: $viewModel.selectedTarget) {
                                Text("Choose a team").tag(Optional<EscalationTarget>.none)
                                ForEach(EscalationTarget.allCases) { team in
                                    Text(team.displayName).tag(Optional(team))
                                }
                            }
                            TextField("Escalation reason", text: $viewModel.escalationReason, axis: .vertical)
                                .lineLimit(3...6)
                            Button("Escalate Incident") {
                                viewModel.escalateIncident()
                            }
                        }
                    }

                    if incident.status == .resolved, let resolution = incident.resolution {
                        Section("Resolution") {
                            Text(resolution.resolutionSummary)
                            Text("This incident is closed. Use Back to return to the queue.")
                                .foregroundStyle(.secondary)
                        }
                    }

                    if incident.status == .escalated, let escalation = incident.escalation {
                        Section("Escalation") {
                            LabeledContent("Team", value: escalation.target.displayName)
                            Text(escalation.escalationReason)
                            Text("This incident was handed to a specialist team. Use Back to return to the queue.")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .navigationTitle("Resolve / Escalate")
                .navigationBarTitleDisplayMode(.inline)
                .scrollDismissesKeyboard(.interactively)
                .confirmationDialog(
                    "Close this incident?",
                    isPresented: $viewModel.confirmResolve,
                    titleVisibility: .visible
                ) {
                    Button("Resolve Incident") {
                        viewModel.resolveIncident()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("Check the resolution summary first. This takes the incident out of the active queue.")
                }
            } else {
                ContentUnavailableView(
                    "Incident not found",
                    systemImage: "ticket",
                    description: Text("Return to the queue and choose another incident.")
                )
            }
        }
        .alert(
            "Could not update incident",
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
