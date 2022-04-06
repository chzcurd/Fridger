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

    var body: some View {
        VStack(spacing: 10) {

            Button() {
                isPresentingScanner = true
            }
            label: {
            Label("Scan barcode", systemImage: "barcode.viewfinder")
            }

            
            Text("Scan result:")
            if let code = scannedCode {
                //NavigationLink("Next page", destination: NextView(scannedCode: code), isActive: .constant(true)).hidden()
                VStack{
                    Text(code)
                    var food = getUPC(code: code);
                    //print(food?.item_name)
                    Text((food?.item_name) ?? "no data :(")
                }
                
                
            }
        }
        .sheet(isPresented: $isPresentingScanner) {
            CodeScannerView(codeTypes: [.ean8,.ean13,.upce], scanMode: .once, simulatedData: "0064144030941") { response in
                if case let .success(result) = response {
                    scannedCode = result.string
                    isPresentingScanner = false
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
