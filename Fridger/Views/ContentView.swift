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
                Text("Item count: " + String(scanHandler.scannedItems.count))
                
                List{
                    NavigationLink(destination: ScannerView().environmentObject(scanHandler)) {
                        Text("Scan Item")
                    }
                }
            }
            .navigationBarTitle(Text("Master"))
            .onAppear(perform: {scanHandler.currentItem = nil})
        }
        
        
        //ScannerView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
