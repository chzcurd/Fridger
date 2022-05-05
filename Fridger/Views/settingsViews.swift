//
//  settingsViews.swift
//  Fridger
//
//  Created by Josh Osmanski on 5/4/22.
//

import SwiftUI



struct settingsView: View {
    @EnvironmentObject var scanHandler: ScanHandler
    //@State var settingsMessage
    
    var body: some View {
        VStack{
            Text("App Settings").font(.title)
            //Spacer()
            emptyFridge().environmentObject(scanHandler).padding()
            deleteDatabase().environmentObject(scanHandler).padding()
            Text("Items in Database: " + String(scanHandler.scannedItems.count))
            Text("Items currently in Fridge: " + String(getItemCountInFridge(scannedItems: scanHandler.scannedItems)))
            Spacer()
        }
    }
}

struct deleteDatabase: View {
    @EnvironmentObject var scanHandler: ScanHandler
    @State private var confirmDelete = false
    @State private var deleted = false
    
    var body: some View {
        HStack{
            //other empty textview so text is still centered after the other textview needed for the alert notificationˆ
            Text("")
            
            if !confirmDelete {
                Button() {
                    confirmDelete = true
                }
            label: {
                Text("Permenently Delete Database").foregroundColor(Color.red)
            }
            }
            else {
                
                HStack{
                    Button() {
                        confirmDelete = false
                    }
                label: {
                    Text("KEEP DATABASE").padding(.trailing)
                }
                    
                    Button() {
                        //delete the database
                        scanHandler.scannedItems = []
                        confirmDelete = false
                        deleted = true
                        print("database deleted!")
                    }
                    
                    
                label: {
                    Text("CONFIRM DELETE").foregroundColor(Color.red).padding(.leading)
                }
                    
                }
                
            }
            
            //need the empty text view for the alert to appear
            Text("")
                .alert(isPresented: $deleted) {
                    Alert(title: Text("Database Deleted!"), message: Text("The Food Database has been deleted!"), dismissButton: .default(Text("OK")))
                }
        }
    }
    
}


struct emptyFridge: View {
    @EnvironmentObject var scanHandler: ScanHandler
    @State private var confirmDelete = false
    @State private var deleted = false
    
    var body: some View {
        HStack{
            //other empty textview so text is still centered after the other textview needed for the alert notificationˆ
            Text("")
            
            if !confirmDelete {
                Button() {
                    confirmDelete = true
                }
            label: {
                Text("Empty Fridge").foregroundColor(Color.red)
            }
            }
            else {
                
                HStack{
                    Button() {
                        confirmDelete = false
                    }
                label: {
                    Text("KEEP FRIDGE").padding(.trailing)
                }
                    
                    Button() {
                        //remove the item from the fridge
                        scanHandler.scannedItems.forEach{ item in
                            let itemIndex = scanHandler.scannedItems.firstIndex(where: {item2 in item.upc == item2.upc}) ?? -1
                            scanHandler.scannedItems[itemIndex].quantity = 0
                        }
                        
                        confirmDelete = false
                        deleted = true
                        print("FRIDGE EMPTIED!")
                    }
                    
                    
                label: {
                    Text("CONFIRM EMPTY").foregroundColor(Color.red).padding(.leading)
                }
                    
                }
                
            }
            
            //need the empty text view for the alert to appear
            Text("")
                .alert(isPresented: $deleted) {
                    Alert(title: Text("Fridge Emptied!"), message: Text("All food has been removed from the Fridge!"), dismissButton: .default(Text("OK")))
                }
        }
    }
    
}

/*struct settingsViews_Previews: PreviewProvider {
 static var previews: some View {
 settingsViews()
 }
 }*/
