//
//  ItemListView.swift
//  Fridger
//
//  Created by Josh Osmanski on 4/7/22.
//

import SwiftUI

struct ItemListView: View {
    
    @EnvironmentObject var scanHandler: ScanHandler
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Item count: " + String(scanHandler.scannedItems.count))
                
                List {
                    ForEach(scanHandler.scannedItems, id: \.upc) { item in
                        NavigationLink(destination:
                                        //navigate to item page
                                       ItemView(upc: item.upc, item: item.foodOBJ!).environmentObject(scanHandler)
                        ) {
                            //button text
                            ItemListButton(upc: item.upc).environmentObject(scanHandler)
                        }
                    }
                }
                
                
            }
        }
        .navigationBarTitle(Text("Scanned Items"))
        .onAppear(perform: {scanHandler.currentItem = nil})
        
        .navigationViewStyle(StackNavigationViewStyle())
        
        
        //ScannerView()
    }
    
}

//view of the item
struct ItemView: View {
    
    @EnvironmentObject var scanHandler: ScanHandler
    
    let upc : String
    let item : foodOBJ
    
    var body: some View {
        
        VStack{
            
            Text(upc)
            
            
            Text(item.brand_name ?? "")
            Text(item.item_name ?? "")
            
            
            
            
            
        }
        
    }
    
}


//list button for each item
struct ItemListButton: View {
    
    @EnvironmentObject var scanHandler: ScanHandler
    
    let upc : String
    
    var body: some View {
        
        VStack{
            
            Text(upc)
            
            
        }
        
    }
    
}


struct ItemViews_Previews: PreviewProvider {
    static var previews: some View {
        //ItemView(upc: "12345")
        Text("no")
    }
}
