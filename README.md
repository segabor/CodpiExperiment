An experiment to fetch some data from Oracle DB using ODPI-C thin API

== Requirements

- Oracle Instant Client
- Swift 4.2 or newer

== Build

```swift
swift build -Xlinker -L/usr/local/lib
```

== Run the example

Example expects connection parameters put into `config.json` file,

```json
{
    "database": {
        "connection": "<connection string>",
        "username": "<uname>",
        "password": "<passwd>"
    }
}
```

Copy / link `libclntsh.dylib` library isto `/usr/local/lib`.
Now start the code

```swift
swift run -Xlinker -L/usr/local/lib
```

