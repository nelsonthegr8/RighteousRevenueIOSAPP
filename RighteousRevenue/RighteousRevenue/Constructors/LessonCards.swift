//
//  LessonCards.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/2/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import Foundation
import UIKit

struct LessonCards: Decodable{
    
    var img: String
    var title: String
    var subheading: String
    var lesson: String
    var videolink: String

}

struct ResponseData: Decodable {
    var lessoninfo: [LessonCards]
}

func loadJson(filename fileName: String) -> [LessonCards]? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(ResponseData.self, from: data)
            return jsonData.lessoninfo
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}
