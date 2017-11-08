//
//  main.swift
//  secret-santa
//
//  Created by Jono Muller on 24/11/2016.
//  Copyright © 2016 Jono Muller. All rights reserved.
//

import Foundation

let names: [String] = []
let emails: [String] = []
var assignedNames: [String] = []

let ERROR: String = "error"

func sendEmail(name: String, assigned: String) {
  let email = emails[names.index(of: name)!]
  let script = NSAppleScript.init(source:
    "set emailSender to \"Weird Fish\"\n" +
      "set emailTo to \"\(email)\"\n" +
      "set theSubject to \"Secret Santa\"\n" +
      "set theContent to \"Dear \(name),\n\nYou have been assigned \(assigned) for Secret Santa.\"\n" +
      "set theAttachmentFile to \"Hawkeye:Users:jonomuller:Documents:secret-santa:secret-santa:\(assigned).png\"\n" +
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

func generatePerson(name: String) -> String {
  let index = names.index(of: name)
  var random = 0
  
  repeat {
    random = Int(arc4random_uniform(UInt32(names.count)))
    
    // Error case if last person can only be assigned to themself
    // Move to method cannotBeAssigned() -> Bool and check for other permutations
    if assignedNames.count == names.count - 1 && random == index {
      return ERROR
    }
  } while (random == index || assignedNames.contains(names[random]))
  
  assignedNames.append(names[random])
  return names[random]
}

func assign() {
  var valid = true
  
  names.forEach { (name) in
    if generatePerson(name: name) == ERROR {
      valid = false
    }
  }
  
  if !valid {
    assignedNames = []
    assign()
  } else {
    for (i, name) in names.enumerated() {
      let assignedName = assignedNames[i]
      // Do assertions here
      assert(name != assignedName, "Failed")
      // sendEmail(name: name, assigned: assignedName)
    }
  }
}

func runScript(path: String) {
  let task = Process()
  task.launchPath = "/usr/bin/osascript"
  task.arguments = [path]
  task.launch()
  print("Completed executing \(path)")
}

//assign()
parsePeople()
print("hello")

/*
 * Optional script to delete the emails sent (to remove any trace of the assigned names)
 */
// runScript(path: "/Users/jonomuller/Documents/secret-santa/secret-santa/delete_emails.scpt")

