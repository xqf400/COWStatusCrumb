//
//  String.swift
//  COWStatusCrumb
//
//  Created by XQF on 04.03.23.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
