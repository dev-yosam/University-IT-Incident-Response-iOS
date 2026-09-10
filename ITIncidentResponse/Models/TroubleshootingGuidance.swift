import Foundation

extension IncidentCategory {
    /// Sample first-line checks for this kind of campus incident.
    /// These are for the demo only, not official university procedures.
    var troubleshootingSteps: [String] {
        switch self {
        case .network:
            return [
                "Confirm whether one device or multiple devices are affected.",
                "Verify Wi-Fi is enabled and the university network is selected.",
                "Reconnect to the network.",
                "If multiple devices remain affected, escalate to Network Services."
            ]
        case .classroomTechnology:
            return [
                "Confirm the projector or display has power.",
                "Check the selected input source.",
                "Reconnect the presentation cable.",
                "Escalate persistent room equipment failures to Classroom AV."
            ]
        case .accountAccess:
            return [
                "Confirm the staff or student identifier.",
                "Check whether the account appears locked.",
                "Retry after basic account checks.",
                "Escalate unresolved identity issues to Identity & Access."
            ]
        case .printing:
            return [
                "Confirm the correct campus printer is selected.",
                "Check whether other users can print.",
                "Retry the print job.",
                "Escalate persistent workstation issues to Desktop Support."
            ]
        case .software:
            return [
                "Confirm the application name and what appeared on screen.",
                "Quit the application and open it again.",
                "Try another machine in the same room if one is free.",
                "Escalate persistent software faults to Desktop Support."
            ]
        }
    }
}
