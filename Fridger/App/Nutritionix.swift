//
//  Nutritionix.swift
//  Fridger
//
//  Created by Josh Osmanski on 4/5/22.
//

import Foundation
import SwiftUI
//import SwiftyJSON

struct foodOBJ : Codable {
    let old_api_id : String?
    let item_id:String?
    let item_name:String?
    let leg_loc_id:String?
    let brand_id:String?
    let brand_name:String?
    let item_description:String?
    let updated_at:String?
    let nf_ingredient_statement:String?
    let nf_water_grams:Double?
    let nf_calories:Double?
    let nf_calories_from_fat:Double?
    let nf_total_fat:Double?
    let nf_saturated_fat:Double?
    let nf_trans_fatty_acid:Double?
    let nf_polyunsaturated_fat:Double?
    let nf_monounsaturated_fat:Double?
    let nf_cholesterol:Double?
    let nf_sodium:Double?
    let nf_total_carbohydrate:Double?
    let nf_dietary_fiber:Double?
    let nf_sugars:Double?
    let nf_protein:Double?
    let nf_vitamin_a_dv:Double?
    let nf_vitamin_c_dv:Double?
    let nf_calcium_dv:Double?
    let nf_iron_dv:Double?
    let nf_refuse_pct:Double?
    let nf_servings_per_container:Double?
    let nf_serving_size_qty:Double?
    let nf_serving_size_unit:String?
    let nf_serving_weight_grams:Double?
    let allergen_contains_milk:Bool?
    let allergen_contains_eggs:Bool?
    let allergen_contains_fish:Bool?
    let allergen_contains_shellfish:Bool?
    let allergen_contains_tree_nuts:Bool?
    let allergen_contains_peanuts:Bool?
    let allergen_contains_wheat:Bool?
    let allergen_contains_soybeans:Bool?
    let allergen_contains_gluten:Bool?
    //"usda_fields":NULL
}

class ScanHandler: NSObject, ObservableObject {
    @Published var scannedItems: Array<foodOBJ> = []
    @Published var currentItem: foodOBJ? = nil
    
    static let shared = ScanHandler()
    
    private override init() {}
    
    
    func getUPC(code : String) {
        //@Binding var scannedItems : [foodOBJ]
        
        var returnvar : foodOBJ?
        returnvar = nil
        
        currentItem = nil
        
        
        let headers = [
            "X-RapidAPI-Host": "nutritionix-api.p.rapidapi.com",
            "X-RapidAPI-Key": "***REMOVED***"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://nutritionix-api.p.rapidapi.com/v1_1/item?upc=" + code)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                return
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                print(data)
                
                
                var food : foodOBJ?
                food = nil
                
                let decoder = JSONDecoder()
                do {
                    food = try decoder.decode(foodOBJ.self, from: data!)
                }
                catch {
                    print("error: ", error)
                }
                
                print(food)
                
                
                
                returnvar = food
                
                
                
                
            }
        })
        
        dataTask.resume()
        //dataTask.value(forKey: returnvar)
        while (returnvar == nil) {
            print("not done")
        }
        
        //self.scannedItems.append(returnvar!)
        
        print("done returnvar = ")
        print(returnvar)
        self.currentItem = returnvar
        //return returnvar
    }
    
}



