//
//  ClassExtension.swift
//  SampleProject
//
//  Created by Jakub Krystek on 10.12.2016.
//  Copyright © 2016 Jakub Krystek. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localizedWithComment(comment:String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: comment)
    }

}
