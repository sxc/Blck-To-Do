//
//  Blck_To_DoApp.swift
//  Shared
//
//  Created by Xiaochun Shen on 2021/1/5.
//

import SwiftUI

@main
struct Blck_To_DoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TasksView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
