import SwiftUI

struct ActiveIncidentView: View {
    @Bindable var viewModel: ActiveIncidentViewModel
    @Environment(IncidentRepository.self) private var repository
    @FocusState private var noteFieldFocused: Bool

    private var incident: ITIncident? {
        repository.incident(withReference: viewModel.incidentID)
    }

    var body: some View {
        Group {
            if let incident {
                Form {
                    Section("Issue") {
                        Text(incident.title)
                            .font(.headline)
                        Text(incident.issueDescription)
                    }

                    Section("Investigation Notes") {
                        if incident.workNotes.isEmpty {
                            Text("No notes yet.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(incident.workNotes) { note in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(note.noteText)
                                    Text(note.occurredAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }

                    Section("Add Work Note") {
                        TextField("Short diagnostic note", text: $viewModel.draftNote, axis: .vertical)
                            .lineLimit(2...4)
                            .focused($noteFieldFocused)
                        Button("Add Work Note") {
                            noteFieldFocused = false
                            viewModel.addWorkNote()
                        }
                    }

                    Section {
                        ForEach(Array(incident.category.troubleshootingSteps.enumerated()), id: \.offset) { index, step in
                            Text("\(index + 1). \(step)")
                        }
                    } header: {
                        Text("Troubleshooting Guidance")
                    } footer: {
                        Text("Sample internal steps for this demo. Not official university procedures.")
                    }

                    if incident.status == .inProgress {
                        Section {
                            NavigationLink("Resolve / Escalate") {
                                ResolveEscalateView(
                                    viewModel: ResolveEscalateViewModel(
                                        incidentID: incident.id,
                                        repository: repository
                                    )
                                )
                            }
                        }
                    }
                }
                .navigationTitle("Active Incident")
                .navigationBarTitleDisplayMode(.inline)
                .scrollDismissesKeyboard(.interactively)
            } else {
                ContentUnavailableView(
                    "Incident not found",
                    systemImage: "ticket",
                    description: Text("Return to the queue and choose another incident.")
                )
            }
        }
        .alert(
            "Could not save note",
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
