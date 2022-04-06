//
//  FridgerApp.swift
//  Fridger
//
//  Created by Josh Osmanski on 3/17/22.
//

import SwiftUI

@main
struct FridgerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ScanHandler.shared)
        }
    }
}
