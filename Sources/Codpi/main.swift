import Foundation

import odpi

var error = dpiErrorInfo()

/// --- EFFECTIVE CODE STARTS HERE ---

let uname = "CMS"
let passwd = "CMS"
let connStr = "<connection string>"

let connection = try! Connection(connection: connStr, username: uname, password: passwd)

let pstmt = try! PreparedStatement(query: "select count(*) from relationship", connection: connection)

var numQueryColumns : UInt32 = 0
if dpiStmt_execute(pstmt.stmt, DPI_MODE_EXEC_DEFAULT, &numQueryColumns) < 0 {
  die()
}

/* if dpiStmt_defineValue(stmt, 1, DPI_ORACLE_TYPE_NUMBER, DPI_NATIVE_TYPE_BYTES, 0, 0, nil) < 0 {
  showError(context: gContext!)
} */

// fetch rows
print("Fetch rows")

var found : Int32 = 0
var bufferRowIndex : UInt32 = 0
while true {
  if dpiStmt_fetch(pstmt.stmt, &found, &bufferRowIndex) < 0 {
    die()
  }
  
  if found == 0 {
    break
  }
  
  // process row
  var valueType : dpiNativeTypeNum = DPI_NATIVE_TYPE_DOUBLE
  var value : UnsafeMutablePointer<dpiData>?
  if dpiStmt_getQueryValue(pstmt.stmt, 1, &valueType, &value) < 0 {
    die()
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

// dpiStmt_release(stmt)

print("Done")

