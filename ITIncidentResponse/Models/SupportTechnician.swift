import Foundation

/// Staff number used at the service desk, e.g. TECH-07.
struct TechnicianIdentifier: Hashable, CustomStringConvertible {
    let value: String

    init(_ value: String) {
        self.value = value
    }

    var description: String { value }
}

/// A university IT technician who works on incidents.
struct SupportTechnician: Identifiable, Hashable {
    let id: TechnicianIdentifier
    let fullName: String

    init(id: TechnicianIdentifier, fullName: String) {
        self.id = id
        self.fullName = fullName
    }
}
