//
//  Extensions.swift
//  FavouritePlaces
//
//  Created by Ramanjaneyulu Koduri on 05/05/22.
//

import Foundation


extension String {
    
    func removeEmptySpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
}
