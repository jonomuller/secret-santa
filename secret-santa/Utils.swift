//
//  Utils.swift
//  secret-santa
//
//  Created by Jono Muller on 13/11/2017.
//  Copyright © 2017 Jono Muller. All rights reserved.
//

import Foundation

let ERROR: String = "error"

// MARK: - Person assignment

func generatePerson(person: Person) -> (assigned: Person?, error: String?) {
  let index = list.people.index(where: { $0.name == person.name })
  var random = 0
  repeat {
    random = Int(arc4random_uniform(UInt32(list.people.count)))
    
    // Error case if last person can only be assigned to themself
    if list.assignedPeople.count == list.people.count - 1 && random == index {
      return (nil, ERROR)
    }
  } while (invalidAssignment(index: index!, random: random))
  
  let assignedPerson = list.people[random]
  list.assignedPeople.append(assignedPerson)
  return (assignedPerson, nil)
}

func invalidAssignment(index: Int, random: Int) -> Bool {
  return random == index
    || list.assignedPeople.contains(where: { $0.name == list.people[random].name })
    || list.conditions[list.people[index].name] == list.people[random].name
    || list.conditions[list.people[random].name] == list.people[index].name
}

func assign() {
  var valid = true
  
  list.people.forEach { (person) in
    if generatePerson(person: person).error == ERROR {
      valid = false
    }
  }
  
  if !valid {
    list.assignedPeople = []
    assign()
  } else {
    for (i, person) in list.people.enumerated() {
      let assignedPerson = list.assignedPeople[i]
//      print("\(person.name) got \(assignedPerson.name)")
      
      assert(person.name != assignedPerson.name, "Failed - person assigned to themself")
      assert(list.conditions[person.name] != assignedPerson.name, "Condition fail")
      assert(list.conditions[assignedPerson.name] != person.name, "Condition fail")
      
      sendEmail(person: person, assigned: assignedPerson)
    }
  }
}

// MARK: - Script helpers

func sendEmail(person: Person, assigned: Person) {
  let imagePath = CommandLine.arguments[2] + assigned.imagePath
  var arguments = [person.name, person.email, assigned.name, imagePath]
  
  if assigned.suggestions.count > 0 {
    let formattedSuggestions = "\u{2022} " + assigned.suggestions.joined(separator: "\n\u{2022} ")
    arguments.append(formattedSuggestions)
  }
  
  runScript(name: "send_email", arguments: arguments)
}

func runScript(name: String, arguments: [String]) {
  let task = Process()
  task.launchPath = "/usr/bin/osascript"
  
  if let path = Bundle.main.path(forResource: name, ofType: "scpt") {
    task.arguments = [path] + arguments
  } else {
    print("Script not found")
    exit(1)
  }
  
  let outPipe = Pipe()
  task.standardOutput = outPipe
  task.launch()
  let fileHandle = outPipe.fileHandleForReading
  let data = fileHandle.readDataToEndOfFile()
  task.waitUntilExit()
  
  let status = task.terminationStatus
  if status != 0 {
    let error = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
    print(error)
  }

  print("Completed executing \(name)")
}
