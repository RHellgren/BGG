//
//  String+Extensions.swift
//  BGG
//
//  Created by Robin Hellgren on 27/08/2020.
//  Copyright © 2020 Robin Hellgren. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {

    /// Helper to clean whitespace and default back to empty string when matching XML values
    var cleanedXML: String {
        (self ?? "").cleanedXML
    }
}

extension String {

    /// Helper to clean whitespace and default back to empty string when matching XML values
    var cleanedXML: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
