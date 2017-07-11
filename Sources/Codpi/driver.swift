//
//  driver.swift
//  Codpi
//
//  Created by Gábor Sebestyén on 2017. 06. 28..
//

import Foundation

import odpi


public class Connection {
  
  internal let conn : UnsafeMutablePointer<dpiConn>?
  
  public init(connection connStr: String, username uname: String, password passwd: String) throws {
    
    var commonParams = dpiCommonCreateParams()
    // dpiContext_initCommonCreateParams(gContext, &commonParams)
    // var createParams = dpiConnCreateParams()
    let c_uname = uname.cString(using: String.Encoding.ascii)
    let c_passwd = passwd.cString(using: String.Encoding.ascii)
    let c_conn = connStr.cString(using: String.Encoding.ascii)
    
    var _conn : UnsafeMutablePointer<dpiConn>?
    let ctx: UnsafeMutablePointer<dpiContext>? = DriverContext.shared.context
    
    if dpiConn_create(ctx,
        c_uname!, UInt32(uname.characters.count),
        c_passwd!, UInt32(passwd.characters.count),
        c_conn!, UInt32(connStr.characters.count),
        &commonParams, nil, &_conn) < 0 {
      throw DriverError.DatabaseInitFailed
    }
    
    conn = _conn
  }

  deinit {
    dpiConn_release(conn)
  }
}


public class PreparedStatement {
  internal var stmt : UnsafeMutablePointer<dpiStmt>?
  
  public init(query: String, connection: Connection) throws {
    let c_query = query.cString(using: String.Encoding.utf8) // FIXME encoding!
    
    if dpiConn_prepareStmt(connection.conn, 0, c_query!, UInt32(query.characters.count), nil, 0, &stmt) < 0 {
      throw DriverError.PreparedStatementInitFailed
    }
  }
  
  deinit {
    dpiStmt_release(stmt)
  }
}

