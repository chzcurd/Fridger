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
            deleteDatabase().environmentObject(scanHandler).padding()
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
                    print("database deleted!")
                }
                
                
            label: {
                Text("CONFIRM DELETE").foregroundColor(Color.red).padding(.leading)
            }
            
            }
            
        }
            
        
        Text("")
            .alert(isPresented: $deleted) {
                Alert(title: Text("Database Deleted!"), message: Text("The Food Database has been deleted!"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
}

/*struct settingsViews_Previews: PreviewProvider {
    static var previews: some View {
        settingsViews()
    }
}*/
