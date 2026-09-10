//
//  ITIncidentResponseApp.swift
//  ITIncidentResponse
//
//

import SwiftUI

@main
struct ITIncidentResponseApp: App {
    @State private var repository = IncidentRepository()

    var body: some Scene {
        WindowGroup {
            IncidentQueueView(viewModel: IncidentQueueViewModel(repository: repository))
                .environment(repository)
        }
    }
}
