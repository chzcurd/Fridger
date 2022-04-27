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
    @State private var theItemThatWasScanned = foodOBJ(item_name: "No data", brand_name: "No data")
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
                    Text(theItemThatWasScanned.brand_name)
                    Text(theItemThatWasScanned.item_name)
                    Button() {
                        //set foodOBJ to edited version
                        scanHandler.currentItem!.foodOBJ = theItemThatWasScanned
                        //add the item to the cart
                        scanHandler.scannedItems.append(scanHandler.currentItem!)
                        
                        //remove the current item from scan handler
                        scanHandler.currentItem = nil
                        //reset the edited food obj to new food item
                        theItemThatWasScanned = foodOBJ(item_name: "No Data", brand_name: "No Data")
                        
                        //close the view and go back
                        self.presentationMode.wrappedValue.dismiss()
                    }
                label: {
                    Text("Add Scanned item to list")
                }
                    
                    NavigationLink(destination:
                                    ItemEditView(foodObj: $theItemThatWasScanned)
                    ) {
                        //button text
                        Text("Edit Item Details")
                    }.padding(.top)
                    
                }
            }
            //actions when item is already scanned
            if alreadyScanned {
                Text("Item is already scanned, What would you like to do?")
                
                Text((scanHandler.scannedItems[alreadyScannedIndex].foodOBJ.brand_name) )
                Text((scanHandler.scannedItems[alreadyScannedIndex].foodOBJ.item_name) )
                
                ItemDeleteView(itemIndex: $alreadyScannedIndex, alreadyScanned: $alreadyScanned).environmentObject(scanHandler)
                
                Spacer()
                
                ItemQtyEditView(itemIndex: $alreadyScannedIndex).environmentObject(scanHandler)
                NavigationLink(destination:
                                //navigate to item page
                               ItemEditView(foodObj: $scanHandler.scannedItems[alreadyScannedIndex].foodOBJ)
                ) {
                    //button text
                    Text("Edit Item Details")
                }.padding(.top)
                
            }
            Spacer()
            
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
                        //set the editable food obj to the result that came back from the barcode api
                        theItemThatWasScanned = scanHandler.currentItem!.foodOBJ
                        
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
