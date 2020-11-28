//
//  Authentication.swift
//  AgileHomework
//
//  Created by Виталий Овсянников on 27.11.2020.
//

import Foundation

enum PasswordError {
    case tooShort
    case noUpperCaseLetter
    case noLowerCaseLetter
    case noNumber
}

class Authentication{
    private static func findContents(in login: String, completion: (([String]) -> Void)) {
        func cleanUp(_ contents: inout [String]) {
            var itemsToDelete: [Int] = []
            for (index, item) in contents.enumerated() {
                if item.isEmpty { itemsToDelete.append(index) }
            }
            
            for index in itemsToDelete{
                contents.remove(at: index)
            }
        }
        
        var contents: [String] = []
        var tempString: String = ""
        var atFound: Bool = false
        
        for c in login {
            if c == "'" || c == " " { continue }
            
            tempString.append("\(c)")
            if c == "@"{
                if !tempString.isEmpty { contents.append("\(tempString.dropLast())") }
                contents.append("@")
                tempString = ""
                atFound = true
            }
            if atFound {
                if c == "." {
                    if !tempString.isEmpty { contents.append("\(tempString.dropLast())") }
                    tempString = "."
                }
            }
        }
        contents.append(tempString)
        
        cleanUp(&contents)
        completion(contents)
    }
    
    static func loginIsCorrect(for login: String) -> Bool {
        if login.isEmpty { return false }
        var isCorrect = false
        
        findContents(in: login) { contents in
            if contents.count < 4 { isCorrect = false }
            else {
                if contents[0] == "@" || contents[0] == "." { isCorrect = false }
                if contents.last!.count <= 2 { isCorrect = false }
                if contents[1] == "@" {
                    if contents[3].starts(with: ".") && contents[3].count > 2 { isCorrect = true }
                }
            }
        }
        
        return isCorrect
    }
    
    static func passwordIsStrong(for pass: String) -> [PasswordError] {
        var passwordErrorStack: [PasswordError] = []
        
        var containsLowerCase: Bool = false
        var containsUpperCase: Bool = false
        var containsNumber: Bool = false
        
        for c in pass{
            if c.isLowercase { containsLowerCase = true }
            if c.isUppercase { containsUpperCase = true }
            if c.isNumber { containsNumber = true }
        }
        
        if pass.count < 6 { passwordErrorStack.append(.tooShort) }
        if !containsNumber { passwordErrorStack.append(.noNumber) }
        if !containsUpperCase { passwordErrorStack.append(.noUpperCaseLetter) }
        if !containsLowerCase { passwordErrorStack.append(.noLowerCaseLetter) }
        
        return passwordErrorStack
    }
}
