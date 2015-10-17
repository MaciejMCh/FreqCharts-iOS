//
//  FCEquationsDataSource.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 17.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCEquationsDataSource: NSObject {

    func equations() -> [FCEquation] {
        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(self.storagePath()) as! [[String: AnyObject]]?
        if (array == nil) {
            return []
        }
        
        return array!.map({ (input) -> FCEquation in
            FCSymbolParser.parse(input) as! FCEquation
        })
    }

    func addEquation(equation: FCEquation) {
        var array = self.equations()
        array.append(equation)
        NSKeyedArchiver.archiveRootObject(array.map { (input) -> [String: AnyObject] in
            return input.dictionaryValue()
            }, toFile: self.storagePath())
    }
    
    
    func storagePath() -> String {
        var storageDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last as String!
        storageDirectory = storageDirectory + "/models"
        return storageDirectory
    }
    
}
