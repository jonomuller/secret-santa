//
//  ParseJSON.swift
//  secret-santa
//
//  Created by Jono Muller on 08/11/2017.
//  Copyright © 2017 Jono Muller. All rights reserved.
//

import Foundation

func parsePeople() -> List {
  let data = NSData(contentsOfFile: CommandLine.arguments[1]) as! Data
  
  var json = JSON()
  do {
    json = try JSON(data: data)
  } catch {
    print("error")
    exit(0)
  }
  
  let people = parseNames(json: json)
  let conditions = parseConditions(json: json)
  
  return List(people: people, assignedNames: [], conditions: conditions)
}

func parseNames(json: JSON) -> [Person] {
  return []
}

func parseConditions(json: JSON) -> [String: String] {
  return [:]
}
