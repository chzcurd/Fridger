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
                HStack{
                    Text("Database Items: " + String(scanHandler.scannedItems.count))
                    Text("|")
                    Text("In Fridge Count: " + String(getItemCountInFridge(scannedItems: scanHandler.scannedItems)))

                }
                
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
    
    @State var itemIndex : Int
    
    var body: some View {
        
        VStack{
            
            //Text("Qty in stock: " + String(scanHandler.scannedItems[itemIndex].quantity))
            
            
            if (itemIndex >= 0) {
                
                ItemQtyEditView(itemIndex: $itemIndex)
                
                NavigationLink(destination:
                                //navigate to item page
                               ItemEditView(foodObj: $scanHandler.scannedItems[itemIndex].foodOBJ)
                ) {
                    //button text
                    Text("Edit Item Details")
                }.padding(.top)
                
                
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


struct ItemEditView: View {
    
    //@EnvironmentObject var scanHandler: ScanHandler
    
    @Binding var foodObj : foodOBJ
    
    var body: some View {
        
        ScrollView{
            VStack{
            //Text("Qty in stock: " + String(scanHandler.scannedItems[itemIndex].quantity))
                Text("Edit Food Details")
                //stupid xcode only allowing 10 views :(
                //forced to group the shit together
                Group{
                noNillTextEditButton(label: "Brand Name", value: $foodObj.brand_name)
                noNillTextEditButton(label: "Item Name", value: $foodObj.item_name )
                TextEditButton(label: "Item Description", value: $foodObj.item_description)
                TextEditButton(label: "Ingredient Statement", value: $foodObj.nf_ingredient_statement)
                numberTextEditButton(label: "Water grams", value: $foodObj.nf_water_grams)
                numberTextEditButton(label: "Calories", value: $foodObj.nf_calories)
                numberTextEditButton(label: "Calories from Fat", value: $foodObj.nf_calories_from_fat)
                numberTextEditButton(label: "Total Fat", value: $foodObj.nf_total_fat)
                numberTextEditButton(label: "Saturated Fat", value: $foodObj.nf_saturated_fat)
                numberTextEditButton(label: "Trans Fatty Acid", value: $foodObj.nf_trans_fatty_acid)
                }
                Group{
                    numberTextEditButton(label: "Polyunsaturated Fat", value: $foodObj.nf_polyunsaturated_fat)
                    numberTextEditButton(label: "Monounsaturated Fat", value: $foodObj.nf_monounsaturated_fat)
                    numberTextEditButton(label: "Cholesterol", value: $foodObj.nf_cholesterol)
                    numberTextEditButton(label: "Sodium", value: $foodObj.nf_sodium)
                    numberTextEditButton(label: "Total Carbohydrate", value: $foodObj.nf_total_carbohydrate)
                    numberTextEditButton(label: "Dietary Fiber", value: $foodObj.nf_dietary_fiber)
                    numberTextEditButton(label: "Sugars", value: $foodObj.nf_sugars)
                    numberTextEditButton(label: "Protein", value: $foodObj.nf_protein)
                    numberTextEditButton(label: "Vitamin A dv", value: $foodObj.nf_vitamin_a_dv)
                    numberTextEditButton(label: "Vitamin C dv", value: $foodObj.nf_vitamin_c_dv)
                }
                Group{
                    numberTextEditButton(label: "Calcium dv", value: $foodObj.nf_calcium_dv)
                    numberTextEditButton(label: "Iron dv", value: $foodObj.nf_iron_dv)
                    numberTextEditButton(label: "Servings per Container", value: $foodObj.nf_servings_per_container)
                    numberTextEditButton(label: "Serving Size Qty", value: $foodObj.nf_serving_size_qty)
                    TextEditButton(label: "Serving Size Unit", value: $foodObj.nf_serving_size_unit)
                    numberTextEditButton(label: "Serving Weight Grams", value: $foodObj.nf_serving_weight_grams)
                }
                
            }
            }
            
            
            

            
            
        
        
    }
    
}

struct numberTextEditButton: View {
    @State private var string: String = ""
    var label: String
    @Binding var value: Double?
    
    //@Binding var doubleToSave: Double
    
    func save() {
        value = Double(string) ?? 0.0
    }
    
    var body: some View {
        VStack {
            Text("\(label): \(String(value ?? 0.0))").padding(.top)
            TextField("\(label)", text: $string).keyboardType(.decimalPad).padding(.leading).padding(.trailing)
            Button(action: save) { Text("Set")}.padding(.bottom)
        }
    }
    
}

struct TextEditButton: View {
    @State private var string: String = ""
    var label: String
    @Binding var value: String?
    
    //@Binding var doubleToSave: Double
    
    func save() {
        value = string
    }
    
    var body: some View {
        VStack {
            Text("\(label): \(value ?? "")").padding(.top)
            TextField("\(label)", text: $string).padding(.leading).padding(.trailing)
            Button(action: save) { Text("Set")}.padding(.bottom)
        }
    }
    
}

struct noNillTextEditButton: View {
    @State private var string: String = ""
    var label: String
    @Binding var value: String
    
    //@Binding var doubleToSave: Double
    
    func save() {
        value = string
    }
    
    var body: some View {
        VStack {
            Text("\(label): \(value)").padding(.top)
            TextField("\(label)", text: $string).padding(.leading).padding(.trailing)
            Button(action: save) { Text("Set")}.padding(.bottom)
        }
    }
    
}

struct ItemViews_Previews: PreviewProvider {
    static var previews: some View {
        //ItemView(upc: "12345")
        Text("no")
    }
}
