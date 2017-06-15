import Foundation

import odpi

var gContext: UnsafeMutablePointer<dpiContext>?
var error = dpiErrorInfo()

/// HELPERS

func showError(info: dpiErrorInfo) -> Never {
  let msg = String(cString: info.message)
  let fnName = String(cString: info.fnName)
  let action = String(cString: info.action)

  fatalError("Message: \(msg)\nFunction Name: \(fnName)\nAction: \(action)")
}

func showError(context: UnsafeMutablePointer<dpiContext>) -> Never {
  var err: dpiErrorInfo = dpiErrorInfo()

  dpiContext_getError(context, &err)
  showError(info: err)
}

// InitializeDPI()
if dpiContext_create(UInt32(DPI_MAJOR_VERSION), UInt32(DPI_MINOR_VERSION), &gContext, &error) < 0 {
  showError(info: error)
}

// GetConnection()
var conn : UnsafeMutablePointer<dpiConn>?

let uname = "CMS"
let passwd = "CMS"
// let connStr = "192.168.253.33:1521/DBEU16"
let connStr = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.253.33)(PORT=1521))(CONNECT_DATA=(SID=DBEU02)))"

var commonParams = dpiCommonCreateParams()
// dpiContext_initCommonCreateParams(gContext, &commonParams)
// var createParams = dpiConnCreateParams()
let c_uname = uname.cString(using: String.Encoding.utf8)
let c_passwd = passwd.cString(using: String.Encoding.utf8)
let c_conn = connStr.cString(using: String.Encoding.utf8)

if dpiConn_create(gContext,
    c_uname!, UInt32(uname.characters.count),
    c_passwd!, UInt32(passwd.characters.count),
    c_conn!, UInt32(connStr.characters.count),
    &commonParams, nil, &conn) < 0 {
  showError(context: gContext!)
}

// bye
dpiContext_destroy(gContext)

