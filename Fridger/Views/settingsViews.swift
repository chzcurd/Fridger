//
//  settingsViews.swift
//  Fridger
//
//  Created by Josh Osmanski on 5/4/22.
//

import SwiftUI



struct settingsView: View {
    @EnvironmentObject var scanHandler: ScanHandler
    
    var body: some View {
        VStack{
            Text("Settings view")
            deleteDatabase().environmentObject(scanHandler)
        }
    }
}

struct deleteDatabase: View {
    @EnvironmentObject var scanHandler: ScanHandler
    @State private var confirmDelete = false
    @State private var deleted = false
    
    var body: some View {
        if !deleted{
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
                    //remove the item from the cart
                    scanHandler.scannedItems = []
                    confirmDelete = false
                    deleted = true
                }
            label: {
                Text("CONFIRM DELETE").foregroundColor(Color.red).padding(.leading)
            }
            }
            
        }
    }
        else {
            Text("Database has been deleted!")
        }
        
        
    }
}

/*struct settingsViews_Previews: PreviewProvider {
    static var previews: some View {
        settingsViews()
    }
}*/
