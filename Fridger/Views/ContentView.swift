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
    @State private var selection = 1
    
    var handler: Binding<Int> { Binding(
        get: { self.selection},
        set: {
            //if $0 == self.selection {
            print("RESET THE TAB")
            scanHandler.currentItem = nil
            //}
            self.selection = $0
        }
        
    )}
    
    var body: some View {
        //Fridger App title text
        VStack {
            HStack{
                Text("Fridger").font(.largeTitle).bold().fontWeight(.black).padding(.top)
                VStack{
                    Text("").padding(.top)
                    Text("What's in the fridge?").font(.caption).fontWeight(.light)
                }
            }
            TabView(selection: handler){
                NavigationView{
                    ItemListView(databaseView: false, titleText: "In the Fridge").environmentObject(scanHandler)
                }
                .tabItem() {
                    Image(systemName: "fork.knife")
                    Text("View Fridge")
                }
                .tag(1)
                NavigationView{
                    ScannerView().environmentObject(scanHandler)
                }
                .tabItem() {
                    Image(systemName: "barcode.viewfinder")
                    Text("Item Scanner")
                }
                .tag(2)
                NavigationView{
                    ItemListView(databaseView: true, titleText: "Food Database").environmentObject(scanHandler)
                }
                .tabItem() {
                    Image(systemName: "server.rack")
                    Text("View Database")
                }
                .tag(3)
                NavigationView{
                    settingsView().environmentObject(scanHandler)
                }
                .tabItem() {
                    Image(systemName: "slider.horizontal.3")
                    Text("Settings")
                }
                .tag(4)
                
                
            }
            .onChange(of: selection, perform: {index in (scanHandler.currentItem = nil)})
        }
        //.navigationBarTitle(Text("Fridger"))
        //.onAppear(perform: {scanHandler.currentItem = nil})
        
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        //ScannerView()
    }
}

