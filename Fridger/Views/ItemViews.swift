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
                //getItemCountInFridge()
                //var itemCount = getItemCountInFridge().environmentObject(scanHandler)
                Text("Item count: " + String(getItemCountInFridge(scannedItems: scanHandler.scannedItems)))
                
                List {
                    ForEach(scanHandler.scannedItems, id: \.upc) { item in
                        var itemIndex = scanHandler.scannedItems.firstIndex(where: {item2 in item.upc == item2.upc}) ?? -1
                        
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
    
    @State var itemIndex : Int
    
    var body: some View {
        
        VStack{
            
            //Text("Qty in stock: " + String(scanHandler.scannedItems[itemIndex].quantity))
            
            
            if (itemIndex >= 0) {
                
                ItemQtyEditView(itemIndex: $itemIndex)
                
                Spacer()
                
                Text("UPC Code: " + scanHandler.scannedItems[itemIndex].upc)
            
                Text("Brand Name: " + (scanHandler.scannedItems[itemIndex].foodOBJ.brand_name ))
                Text("Item Name: " + (scanHandler.scannedItems[itemIndex].foodOBJ.item_name ))
                Text("Calories: " + String((scanHandler.scannedItems[itemIndex].foodOBJ.nf_calories ?? 0.0)))
                
                Spacer()
                ItemDeleteView(itemIndex: $itemIndex, alreadyScanned: .constant(true)).environmentObject(scanHandler)
                Spacer()

            
            }
            
            
            

            
            
        }
        
    }
    
}


//list button for each item
struct ItemListButton: View {
    
    @EnvironmentObject var scanHandler: ScanHandler
    
    let itemIndex : Int
    
    var body: some View {
        
        if (itemIndex >= 0 && itemIndex < scanHandler.scannedItems.count){
        
            HStack{
            
                Text((scanHandler.scannedItems[itemIndex].foodOBJ.brand_name ) + " " + (scanHandler.scannedItems[itemIndex].foodOBJ.item_name ))
                Spacer()
                Text("Qty: " + String(scanHandler.scannedItems[itemIndex].quantity))
            
            
            
            
            }
        }
        
    }
    
}



//view of the item Qty Edit controls
struct ItemQtyEditView: View {
    
    @EnvironmentObject var scanHandler: ScanHandler
    
    @Binding var itemIndex : Int
    
    var body: some View {
        
        if itemIndex >= 0 {
            
        
        Text("Qty in stock: " + String(scanHandler.scannedItems[itemIndex].quantity))
        //add/remove quantity button
        HStack {
            Button() {
                //remove stock if more than zero items
                if scanHandler.scannedItems[itemIndex].quantity > 0 {
                    scanHandler.scannedItems[itemIndex].quantity-=1
                }
            }
            label: {
                Text("Remove Stock").padding(.trailing)
            }
            
            //Spacer()
            
            Button() {
                //add stock
                scanHandler.scannedItems[itemIndex].quantity+=1
                
            }
            label: {
                Text("Add Stock").padding(.leading)
            }
        }
        }
        
    }
    
}



//view of the item Qty Edit controls
struct ItemDeleteView: View {
    
    @EnvironmentObject var scanHandler: ScanHandler
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Binding var itemIndex : Int
    @Binding var alreadyScanned : Bool
    @State private var confirmDelete = false
    
    var body: some View {
        
        if itemIndex >= 0 {
            
            if !confirmDelete {
                Button() {
                    confirmDelete = true
                }
            label: {
                Text("Remove scanned item from database")
            }
            }
            else {
                
                HStack{
                    Button() {
                        confirmDelete = false
                    }
                label: {
                    Text("KEEP ITEM").padding(.trailing)
                }
                    
                    Button() {
                        //remove the item from the cart
                        scanHandler.scannedItems.remove(at: itemIndex)
                        
                        //remove the current item from scan handler
                        scanHandler.currentItem = nil
                        alreadyScanned = false
                        itemIndex = -1
                        
                        
                        //close the view and go back
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    label: {
                        Text("CONFIRM DELETE").padding(.leading)
                    }
                }
            
            }
        
        }
        
    }
    
}

func getItemCountInFridge(scannedItems: [foodItem]) -> Int {
    
    var total = 0
    
    scannedItems.forEach { item in
        total += item.quantity
    }
    
    
    return total
}



struct ItemViews_Previews: PreviewProvider {
    static var previews: some View {
        //ItemView(upc: "12345")
        Text("no")
    }
}
