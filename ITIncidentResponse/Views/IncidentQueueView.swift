import SwiftUI

struct IncidentQueueView: View {
    let viewModel: IncidentQueueViewModel
    @Environment(IncidentRepository.self) private var repository

    var body: some View {
        NavigationStack {
            List(viewModel.incidents) { incident in
                NavigationLink(value: incident.id) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(incident.priority.displayName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text(incident.title)
                            .font(.headline)
                        Text("\(incident.category.displayName) · \(incident.campusLocation)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(incident.status.displayName)
                            .font(.footnote)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("IT Incident Queue")
            .navigationDestination(for: IncidentReference.self) { incidentID in
                IncidentDetailsView(
                    viewModel: IncidentDetailsViewModel(
                        incidentID: incidentID,
                        repository: repository
                    )
                )
            }
        }
    }
}
