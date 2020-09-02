//
//  ScripturesOfTheDay.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/27/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import UIKit

struct ScripturesOfTheDay: Codable{
    
    var scriptureimg: String
    var biblelink: String

}

struct ScriptureResponseData: Decodable {
    var scriptureInfo: [ScripturesOfTheDay]
}

func loadDailyScriptureJson(filename fileName: String) -> [ScripturesOfTheDay]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(ScriptureResponseData.self, from: data)
            return jsonData.scriptureInfo
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}
