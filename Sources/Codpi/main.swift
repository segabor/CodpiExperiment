import Foundation

import odpi

var gContext: UnsafeMutablePointer<dpiContext>?
var error = dpiErrorInfo()

/// --- HELPERS ---

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

/// --- EFFECTIVE CODE STARTS HERE ---

// InitializeDPI()
if dpiContext_create(UInt32(DPI_MAJOR_VERSION), UInt32(DPI_MINOR_VERSION), &gContext, &error) < 0 {
  showError(info: error)
}

// GetConnection()
var conn : UnsafeMutablePointer<dpiConn>?

let uname = "CMS"
let passwd = "CMS"
let connStr = "<connection string>"

var commonParams = dpiCommonCreateParams()
// dpiContext_initCommonCreateParams(gContext, &commonParams)
// var createParams = dpiConnCreateParams()
let c_uname = uname.cString(using: String.Encoding.ascii)
let c_passwd = passwd.cString(using: String.Encoding.ascii)
let c_conn = connStr.cString(using: String.Encoding.ascii)

if dpiConn_create(gContext,
    c_uname!, UInt32(uname.characters.count),
    c_passwd!, UInt32(passwd.characters.count),
    c_conn!, UInt32(connStr.characters.count),
    &commonParams, nil, &conn) < 0 {
  showError(context: gContext!)
}

let query = "select count(*) from relationship"
let c_query = query.cString(using: String.Encoding.utf8)

var stmt : UnsafeMutablePointer<dpiStmt>?
if dpiConn_prepareStmt(conn, 0, c_query!, UInt32(query.characters.count), nil, 0, &stmt) < 0 {
  showError(context: gContext!)
}

var numQueryColumns : UInt32 = 0
if dpiStmt_execute(stmt, DPI_MODE_EXEC_DEFAULT, &numQueryColumns) < 0 {
  showError(context: gContext!)
}

/* if dpiStmt_defineValue(stmt, 1, DPI_ORACLE_TYPE_NUMBER, DPI_NATIVE_TYPE_BYTES, 0, 0, nil) < 0 {
  showError(context: gContext!)
} */

// fetch rows
print("Fetch rows")

var found : Int32 = 0
var bufferRowIndex : UInt32 = 0
while true {
  if dpiStmt_fetch(stmt, &found, &bufferRowIndex) < 0 {
    showError(context: gContext!)
  }
  
  if found == 0 {
    break
  }
  
  // process row
  var valueType : dpiNativeTypeNum = DPI_NATIVE_TYPE_DOUBLE
  var value : UnsafeMutablePointer<dpiData>?
  if dpiStmt_getQueryValue(stmt, 1, &valueType, &value) < 0 {
    showError(context: gContext!)
  }
  
  // extract value
  if let v = value?.pointee.value {
    switch valueType {
    case DPI_NATIVE_TYPE_INT64:
      print("\(v.asInt64)")
    case DPI_NATIVE_TYPE_DOUBLE:
      print("\(v.asDouble)")
    default:
      print("I don't know")
    }
  }
}

dpiStmt_release(stmt)
dpiConn_release(conn)

print("Done")

// bye
dpiContext_destroy(gContext)

