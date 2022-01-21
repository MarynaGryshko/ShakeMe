//
//  Message.swift
//  ShakeMe
//
//  Created by MARINA on 13.01.2022.
//

import Foundation
import UIKit

struct Message: Codable {
    var question: String? = nil
    let answer: String
    var type: String = "Neutral"
    //var type: answerType = .neutral nor sure about list of types, will implement later
    //https://stackoverflow.com/questions/49695780/codable-enum-with-default-case-in-swift-4
}

struct Answer: Codable {
    var magic: Message
}
 
enum answerType: String, Codable, CaseIterable
{
    case neutral = "Neutral"
    case contrary = "Contrary"
    case affirmative = "Affirmative"
    var color: UIColor {
        switch self {
            case .neutral: return UIColor.yellow
            case .contrary: return UIColor.red
            case .affirmative: return UIColor.green
    }}
}

