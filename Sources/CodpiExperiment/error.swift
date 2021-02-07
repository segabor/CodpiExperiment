//
//  error.swift
//  Codpi
//
//  Created by Gábor Sebestyén on 2017. 06. 29..
//

import Foundation

import Codpi

// for easier debugging
extension String: Error {}

public struct DriverErrorInfo {
    let code : Int32 // ORA error code
    let offset : UInt32
    let message : String // error message
    // let encoding : String
    let functionName : String
    let action : String
    let sqlState : String
    let recoverable : Bool


    // build error info from dpiErrorInfo
    init(info: dpiErrorInfo) {
        code = info.code
        offset = info.offset
        message = String(cString: info.message)
        functionName = String(cString: info.fnName)
        action = String(cString: info.action)
        sqlState = String(cString: info.sqlState)
        recoverable = info.isRecoverable == 1
    }


    // build error info from driver context
    init() {
        var info = dpiErrorInfo()
        dpiContext_getError(DriverContext.shared.context, &info)

        self.init(info: info)
    }

    public var description: String {
        return "Message: \(message)\nFunction Name: \(functionName)\nAction: \(action)"
    }
}


public enum DriverError: Error {
    case DatabaseInitFailed
    case PreparedStatementInitFailed
}


public func die() -> Never {
    let error = DriverErrorInfo()
    
    fatalError("Message: \(error.message)\nFunction Name: \(error.functionName)\nAction: \(error.action)")
}
