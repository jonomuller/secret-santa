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
    // Move to method cannotBeAssigned() -> Bool and check for other permutations
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
      print("\(person.name) got \(assignedPerson.name)")
      assert(person.name != assignedPerson.name, "Failed - person assigned to themself")
      assert(list.conditions[person.name] != assignedPerson.name, "Condition fail")
      assert(list.conditions[assignedPerson.name] != person.name, "Condition fail")
      // sendEmail(name: name, assigned: assignedName)
    }
  }
}

// MARK: - Script helpers

func sendEmail(person: Person, assigned: Person) {
  let script = NSAppleScript.init(source:
    "set emailSender to \"Weird Fish\"\n" +
      "set emailTo to \"\(person.email)\"\n" +
      "set theSubject to \"Secret Santa\"\n" +
      "set theContent to \"Dear \(person.name),\n\nYou have been assigned \(assigned.name) for Secret Santa.\"\n" +
      "set theAttachmentFile to \"Hawkeye:Users:jonomuller:Documents:secret-santa:secret-santa:\(assigned.imagePath).png\"\n" +
      "tell application \"Mail\"\n" +
      "set newMessage to make new outgoing message with properties {sender:emailSender, subject:theSubject, content:theContent, visible:true}\n" +
      "tell newMessage\n" +
      "make new to recipient at end of to recipients with properties {address:emailTo}\n" +
      "make new attachment with properties {file name:theAttachmentFile as alias}\n" +
      "delay 1" +
      "send\n" +
      "end tell\n" +
    "end tell\n")
  
  var error: NSDictionary?
  script?.executeAndReturnError(&error)
  if (error != nil) {
    //        print("error: \(error)")
  }
}

func runScript(path: String) {
  let task = Process()
  task.launchPath = "/usr/bin/osascript"
  task.arguments = [path]
  task.launch()
  print("Completed executing \(path)")
}
