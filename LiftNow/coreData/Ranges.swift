//
//  Ranges.swift
//  LiftNow
//
//  Created by Prithiviraj on 14/06/22.
//

import Foundation

public class Ranges: NSObject, NSCoding {
    public var ranges: [QansModel] = []
    
    enum Key:String {
        case ranges = "ranges"
    }
    
    init(ranges: [QansModel]) {
        self.ranges = ranges
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(ranges, forKey: Key.ranges.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mRanges = aDecoder.decodeObject(forKey: Key.ranges.rawValue) as! [QansModel]
        
        self.init(ranges: mRanges)
    }
}

public class QansModel: NSObject, NSCoding {
    var question :String = "";
    var answer :String = "";
    
    enum Key:String {
        case question = "question"
        case answer = "answer"
    }
    
    init(question: String, answer: String) {
        self.question = question
        self.answer = answer
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(question, forKey: Key.question.rawValue)
        aCoder.encode(answer, forKey: Key.answer.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mquestion = aDecoder.decodeObject(forKey: Key.question.rawValue) as! String
        let manswer = aDecoder.decodeObject(forKey: Key.answer.rawValue) as! String
        self.init(question: String(mquestion), answer:
                    String(manswer))
    }
}
