import Foundation
import Observation

@Observable
final class IncidentQueueViewModel {
    private let repository: IncidentRepository

    init(repository: IncidentRepository) {
        self.repository = repository
    }

    var incidents: [ITIncident] {
        repository.incidents
    }
}
