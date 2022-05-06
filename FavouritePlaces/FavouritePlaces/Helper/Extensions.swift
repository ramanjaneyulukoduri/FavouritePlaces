//
//  Extensions.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 05/05/22.
//

import Foundation


extension String {
    
    /// Extension to remove empty spaces
    /// - Returns: text with no empty string
    func removeEmptySpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
