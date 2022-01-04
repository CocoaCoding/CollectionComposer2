//  FileHelperError.swift
//  Created by Holger Hinzberg on 04.01.22.

import Foundation

public enum FileHelperError : Error {
    case couldNotCopyFile(source:String? , destination:String?, description:String)
    case unexpected(code: Int)
}

extension FileHelperError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .couldNotCopyFile:
            return "The provided password is not valid."
        case .unexpected(_):
            return "An unexpected error occurred."
        }
    }
}
