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

let uname = "cust"
let passwd = "cust"
// let connStr = "192.168.253.33:1521/DBEU16"
let connStr = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.253.33)(PORT=1521))(CONNECT_DATA=(SID=DBEU16)))"

var commonParams = dpiCommonCreateParams()
// dpiContext_initCommonCreateParams(gContext, &commonParams)
// var createParams = dpiConnCreateParams()


let unamePtr : UnsafeBufferPointer<CChar>? = uname.utf8CString.withUnsafeBufferPointer { $0 }
let passwdPtr : UnsafeBufferPointer<CChar>? = passwd.utf8CString.withUnsafeBufferPointer { $0 }
let connStrPtr : UnsafeBufferPointer<CChar>? = connStr.utf8CString.withUnsafeBufferPointer { $0 }

if dpiConn_create(gContext,
    unamePtr!.baseAddress, UInt32(uname.characters.count),
    passwdPtr!.baseAddress, UInt32(passwd.characters.count),
    connStrPtr!.baseAddress, UInt32(connStr.characters.count),
    &commonParams, nil, &conn) < 0 {
  showError(context: gContext!)
}

// bye
dpiContext_destroy(gContext)

