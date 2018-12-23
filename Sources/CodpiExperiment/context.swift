//
//  context.swift
//  Codpi
//
//  Created by Gábor Sebestyén on 2017. 07. 10..
//

import Foundation

import Codpi


//
// wrapper class for dpiContext
//
public final class DriverContext {

    internal var context: OpaquePointer?

    public static let shared = DriverContext()

    private init() {
        var errInfo = dpiErrorInfo()

        if dpiContext_create(UInt32(DPI_MAJOR_VERSION), UInt32(DPI_MINOR_VERSION), &context, &errInfo) < 0 {
            let err = DriverErrorInfo(info: errInfo)
            fatalError("Failed to create global driver context; error=\(err.message)")
        }
    }

    deinit {
        dpiContext_destroy(context)
    }
}
