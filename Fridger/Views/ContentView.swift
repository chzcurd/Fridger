//
//  ContentView.swift
//  Fridger
//
//  Created by Josh Osmanski on 3/17/22.
//

import SwiftUI

struct ContentView: View {
    
    //@State var items : [foodOBJ] = []
    
    @EnvironmentObject var scanHandler: ScanHandler
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Items inside fridge: " + String(getItemCountInFridge(scannedItems: scanHandler.scannedItems)))
                
                List{
                    NavigationLink(destination: ItemListView(databaseView: false, titleText: "In the Fridge").environmentObject(scanHandler)) {
                        Text("View Fridge")
                    }
                    
                    NavigationLink(destination: ScannerView().environmentObject(scanHandler)) {
                        Text("Scan Item")
                    }
                    NavigationLink(destination: ItemListView(databaseView: true, titleText: "Food Database").environmentObject(scanHandler)) {
                        Text("View Database")
                    }
                    
                    
                }
            }
            .navigationBarTitle(Text("Fridger"))
            .onAppear(perform: {scanHandler.currentItem = nil})
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        //ScannerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
