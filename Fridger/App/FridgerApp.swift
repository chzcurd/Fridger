//
//  FridgerApp.swift
//  Fridger
//
//  Created by Matthew Fallon on 3/17/22.
//
// Muahahah I'm trying to steal your credit!!!

import SwiftUI

@main
struct FridgerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ScanHandler.shared)
        }
    }
}
