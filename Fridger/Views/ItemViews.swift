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
                        let itemIndex = scanHandler.scannedItems.firstIndex(where: {item2 in item.upc == item2.upc}) ?? -1
                        
                        NavigationLink(destination:
                                        
                                        //navigate to item page
                                       ItemView(itemIndex: itemIndex).environmentObject(scanHandler)
                        ) {
                            //button text
                            ItemListButton(itemIndex: itemIndex).environmentObject(scanHandler)
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
    
    let itemIndex : Int
    
    var body: some View {
        
        VStack{
            
            Text("Qty in stock: " + String(scanHandler.scannedItems[itemIndex].quantity))
            
            Text("UPC Code: " + scanHandler.scannedItems[itemIndex].upc)
            
            Text("Brand Name: " + (scanHandler.scannedItems[itemIndex].foodOBJ?.brand_name ?? "no data"))
            Text("Item Name: " + (scanHandler.scannedItems[itemIndex].foodOBJ?.item_name ?? "no data"))
            Text("Calories: " + String((scanHandler.scannedItems[itemIndex].foodOBJ?.nf_calories ?? 0.0)))
            
            
            
            
        }
        
    }
    
}


//list button for each item
struct ItemListButton: View {
    
    @EnvironmentObject var scanHandler: ScanHandler
    
    let itemIndex : Int
    
    var body: some View {
        
        HStack{
            
            Text((scanHandler.scannedItems[itemIndex].foodOBJ?.brand_name ?? "") + " " + (scanHandler.scannedItems[itemIndex].foodOBJ?.item_name ?? ""))
            Spacer()
            Text("Qty: " + String(scanHandler.scannedItems[itemIndex].quantity))
            
            
            
            
        }
        
    }
    
}


struct ItemViews_Previews: PreviewProvider {
    static var previews: some View {
        //ItemView(upc: "12345")
        Text("no")
    }
}
