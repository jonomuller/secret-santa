//
//  ParseJSON.swift
//  secret-santa
//
//  Created by Jono Muller on 08/11/2017.
//  Copyright © 2017 Jono Muller. All rights reserved.
//

import Foundation

func parseList() -> List {
  let data = NSData(contentsOfFile: CommandLine.arguments[1]) as! Data
  
  var json = JSON()
  do {
    json = try JSON(data: data)
  } catch {
    print("error")
    exit(0)
  }
  
  let people = parsePeople(json: json)
  let conditions = parseConditions(json: json)
  
  return List(people: people, assignedPeople: [], conditions: conditions)
}

func parsePeople(json: JSON) -> [Person] {
  var people: [Person] = []
  
  for (_, subJson): (String, JSON) in json["people"] {
    var suggestions: [String] = []
    
    for (_, subSubJson): (String, JSON) in subJson["suggestions"] {
      suggestions.append(subSubJson.stringValue)
    }
    
    let person = Person(name: subJson["name"].stringValue,
                        email: subJson["email"].stringValue,
                        imagePath: subJson["image_path"].stringValue,
                        suggestions: suggestions)
    people.append(person)
  }
  
  return people
}

func parseConditions(json: JSON) -> [String: String] {
  var conditions: [String: String] = [:]
  
  for (_, subJson): (String, JSON) in json["conditions"] {
    conditions[subJson["first"].stringValue] = subJson["second"].stringValue
  }
  
  return conditions
}
