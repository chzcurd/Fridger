//
//  Nutritionix.swift
//  Fridger
//
//  Created by Josh Osmanski on 4/5/22.
//

import Foundation
import SwiftUI

struct foodItem: Codable {
    let upc : String
    var quantity : Int
    var foodOBJ : foodOBJ
}



struct foodOBJ : Codable {
    //var old_api_id : String?
    //var item_id:String?
    var item_name:String
    //var leg_loc_id:String?
    //var brand_id:String?
    var brand_name:String
    var item_description:String?
    //var updated_at:String?
    var nf_ingredient_statement:String?
    var nf_water_grams:Double?
    var nf_calories:Double?
    var nf_calories_from_fat:Double?
    var nf_total_fat:Double?
    var nf_saturated_fat:Double?
    var nf_trans_fatty_acid:Double?
    var nf_polyunsaturated_fat:Double?
    var nf_monounsaturated_fat:Double?
    var nf_cholesterol:Double?
    var nf_sodium:Double?
    var nf_total_carbohydrate:Double?
    var nf_dietary_fiber:Double?
    var nf_sugars:Double?
    var nf_protein:Double?
    var nf_vitamin_a_dv:Double?
    var nf_vitamin_c_dv:Double?
    var nf_calcium_dv:Double?
    var nf_iron_dv:Double?
    //var nf_refuse_pct:Double?
    var nf_servings_per_container:Double?
    var nf_serving_size_qty:Double?
    var nf_serving_size_unit:String?
    var nf_serving_weight_grams:Double?
    //var allergen_contains_milk:Bool?
    //var allergen_contains_eggs:Bool?
    //var allergen_contains_fish:Bool?
    //var allergen_contains_shellfish:Bool?
    //var allergen_contains_tree_nuts:Bool?
    //var allergen_contains_peanuts:Bool?
    //var allergen_contains_wheat:Bool?
    //var allergen_contains_soybeans:Bool?
    //var allergen_contains_gluten:Bool?
    //"usda_fields":NULL
}

class ScanHandler: NSObject, ObservableObject {
    let defaults = UserDefaults()
    
    @Published var scannedItems = [foodItem]() {
        //save the data every time it changes
        didSet {
            if let encoded = try? JSONEncoder().encode(scannedItems) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    @Published var currentItem: foodItem? = nil
    
    static let shared = ScanHandler()
    
    //load in the saved data instead
    private override init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([foodItem].self, from: savedItems) {
                scannedItems = decodedItems
                return
            }
        }
        
        scannedItems = []
    }
    
    
    func getUPC(code : String) {
        //@Binding var scannedItems : [foodOBJ]
        
        var returnvar : foodItem?
        returnvar = nil
        
        currentItem = nil
        
        
        let headers = [
            "X-RapidAPI-Host": "nutritionix-api.p.rapidapi.com",
            "X-RapidAPI-Key": "ENTER_API_KEY_HERE"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://nutritionix-api.p.rapidapi.com/v1_1/item?upc=" + code)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
                returnvar = foodItem(upc: code, quantity: 1, foodOBJ: foodOBJ(item_name: "Try again later", brand_name: "Server Error"))
                return
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse as Any)
                print(data as Any)
                
                
                var food : foodOBJ?
                food = nil
                
                let decoder = JSONDecoder()
                do {
                    food = try decoder.decode(foodOBJ.self, from: data!)
                }
                catch {
                    print("error: ", error)
                    returnvar = foodItem(upc: code, quantity: 0, foodOBJ: food ?? foodOBJ(item_name: "Try again later", brand_name: "Server Error"))
                }
                
                print(food as Any)
                
                returnvar = foodItem(upc: code, quantity: 1, foodOBJ: food ?? foodOBJ(item_name: "Item name not set", brand_name: "Brand name not set"))
                
                
                
                
            }
        })
        
        dataTask.resume()
        //wait for the result to show up
        while (returnvar == nil) {
            print("not done")
        }
        
        //self.scannedItems.append(returnvar!)
        
        print("done returnvar = ")
        print(returnvar as Any)
        self.currentItem = returnvar
        //return returnvar
    }
    
    
}



