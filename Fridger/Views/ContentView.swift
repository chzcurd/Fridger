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
                    NavigationLink(destination: ItemListView().environmentObject(scanHandler)) {
                        Text("View Scanned Items")
                    }
                    
                    NavigationLink(destination: ScannerView().environmentObject(scanHandler)) {
                        Text("Scan Item")
                    }
                    //temp save and load data buttons
                    HStack {
                        Button() {
                            //save cart data to phone memory
                            scanHandler.saveData()
                        }
                        label: {
                            Text("Save Data").padding(.trailing)
                        }
                        Spacer()
                        Button() {
                            //Load cart data to phone memory
                            scanHandler.loadData()
                        }
                        label: {
                            Text("Load Data").padding(.leading)
                        }
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
