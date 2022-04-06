//
//  ScannerView.swift
//  Fridger
//
//  Created by Josh Osmanski on 3/17/22.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct ScannerView: View {
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    //@Binding var scannedItems : [foodOBJ]
    
    @EnvironmentObject var scanHandler: ScanHandler

    var body: some View {
        VStack(spacing: 10) {

            Button() {
                isPresentingScanner = true
            }
            label: {
            Label("Scan barcode", systemImage: "barcode.viewfinder")
            }

            
            Text("Scan result:")
            if let item = scanHandler.currentItem {
                VStack{
                    //print(food?.item_name)
                    Text((scanHandler.currentItem?.item_name) ?? "no data :(")
                    Button() {
                        scanHandler.scannedItems.append(scanHandler.currentItem!)
                    }
                    label: {
                    Text("Add Scanned item to list")
                    }
                }
            }
            
        }
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.ean8,.ean13,.upce], scanMode: .once, simulatedData: "0064144030941") { response in
                if case let .success(result) = response {
                    isPresentingScanner = false
                    scanHandler.getUPC(code: result.string)
                }
            }
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerView()
    }
}
