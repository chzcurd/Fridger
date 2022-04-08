//
//  ScannerView.swift
//  Fridger
//
//  Created by Josh Osmanski on 3/17/22.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var alreadyScanned = false
    @State private var alreadyScannedIndex = 0
    //@Binding var scannedItems : [foodOBJ]
    
    @EnvironmentObject var scanHandler: ScanHandler
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack(spacing: 10) {

            Button() {
                isPresentingScanner = true
            }
            label: {
            Label("Scan barcode", systemImage: "barcode.viewfinder")
            }

            
            Text("Scan result:")
            if (scanHandler.currentItem != nil && alreadyScanned == false) {
                VStack{
                    //print(food?.item_name)
                    Text((scanHandler.currentItem?.foodOBJ?.brand_name) ?? "no data")
                    Text((scanHandler.currentItem?.foodOBJ?.item_name) ?? ":(")
                    Button() {
                        //add the item to the cart
                        scanHandler.scannedItems.append(scanHandler.currentItem!)
                        
                        //remove the current item from scan handler
                        scanHandler.currentItem = nil
                        
                        //close the view and go back
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    label: {
                    Text("Add Scanned item to list")
                    }
                }
            }
            //actions when item is already scanned
            if alreadyScanned {
                Text("Item is already scanned, What would you like to do?")
                
                Text((scanHandler.scannedItems[alreadyScannedIndex].foodOBJ?.brand_name) ?? "no item brand provided")
                Text((scanHandler.scannedItems[alreadyScannedIndex].foodOBJ?.item_name) ?? "no item name provided")
                
                Button() {
                    //remove the item from the cart
                    scanHandler.scannedItems.remove(at: alreadyScannedIndex)
                    
                    
                    //remove the current item from scan handler
                    scanHandler.currentItem = nil
                    alreadyScanned = false
                    
                    //close the view and go back
                    self.presentationMode.wrappedValue.dismiss()
                }
                label: {
                Text("Remove scanned item from database")
                }
                
                Spacer()
                
                Text("Qty in stock: " + String(scanHandler.scannedItems[alreadyScannedIndex].quantity))
                //add/remove quantity button
                HStack {
                    Button() {
                        //remove stock if more than zero items
                        if scanHandler.scannedItems[alreadyScannedIndex].quantity > 0 {
                            scanHandler.scannedItems[alreadyScannedIndex].quantity-=1
                        }
                    }
                    label: {
                        Text("Remove Stock").padding()
                    }
                    
                    Spacer()
                    
                    Button() {
                        //add stock
                        scanHandler.scannedItems[alreadyScannedIndex].quantity+=1
                        
                    }
                    label: {
                        Text("Add Stock").padding()
                    }
                    
                }
                Spacer()
                
            }
            
        }
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.ean8,.ean13,.upce], scanMode: .once, simulatedData: "0015300014992") { response in
                if case let .success(result) = response {
                    //close scanner
                    isPresentingScanner = false
                    
                    //check if scanned item already exists in database
                    alreadyScannedIndex = scanHandler.scannedItems.firstIndex(where: {item in item.upc == result.string}) ?? -1
                    if alreadyScannedIndex == -1 {
                        alreadyScanned = false
                        scanHandler.getUPC(code: result.string)
                    }
                    else{
                        scanHandler.currentItem = nil
                        alreadyScanned = true
                    }
                    
                    
                    
                    
                }
            }
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        Text("no")
    }
}
