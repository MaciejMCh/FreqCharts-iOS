//
//  FCEquationsDataSource.swift
//  FreqCharts
//
//  Created by Maciej Chmielewski on 17.10.2015.
//  Copyright © 2015 maciejCh. All rights reserved.
//

import UIKit

class FCEquationsDataSource: NSObject {
    
    static var cache: [FCEquation]?

    func equations() -> [FCEquation] {
        if (FCEquationsDataSource.cache != nil) {
            return FCEquationsDataSource.cache!
        }
        
        let array = NSKeyedUnarchiver.unarchiveObjectWithFile(self.storagePath()) as! [[String: AnyObject]]?
        if (array == nil) {
            FCEquationsDataSource.cache = []
            return FCEquationsDataSource.cache!
        }
        
        FCEquationsDataSource.cache =  array!.map({ (input) -> FCEquation in
            FCSymbolParser.parse(input) as! FCEquation
        })
        return FCEquationsDataSource.cache!
    }

    func addEquation(equation: FCEquation) {
        FCEquationsDataSource.cache!.append(equation)
        self.synchronize()
    }
    
    func removeEquation(equation: FCEquation) {
        let index = FCEquationsDataSource.cache!.indexOf(equation)
        if (index != nil) {
            FCEquationsDataSource.cache!.removeAtIndex(index!)
        }
        self.synchronize()
    }
    
    func synchronize() {
        NSKeyedArchiver.archiveRootObject(FCEquationsDataSource.cache!.map { (input) -> [String: AnyObject] in
            return input.dictionaryValue()
            }, toFile: self.storagePath())
    }
    
    
    func storagePath() -> String {
        var storageDirectory = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last as String!
        storageDirectory = storageDirectory + "/models"
        return storageDirectory
    }
    
}
