//
//  main.swift
//  secret-santa
//
//  Created by Jono Muller on 24/11/2016.
//  Copyright © 2016 Jono Muller. All rights reserved.
//

import Foundation

var list = parseList()
assign()

/*
 * Optional script to delete the emails sent (to remove any trace of the assigned names)
 */
// runScript(path: "/Users/jonomuller/Documents/secret-santa/secret-santa/delete_emails.scpt")

// run script to quit Mail
