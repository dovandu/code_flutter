# code_flutter: gitub: https://github.com/flutter/flutter

## fix up store ios flutter 1.9: flutter build ios --release may use a debug Flutter.framework by mistake
- https://github.com/flutter/flutter/issues/37850#issuecomment-533209100
- https://stackoverflow.com/a/33699136

## Vòng đời flutter:
- https://viblo.asia/p/flutter-doi-dieu-can-ghi-nho-RQqKLN6zl7z
## bg tracking ios example:
- https://github.com/Kent-Mbn/TrackingLocationExample

## create plugin example:
- https://github.com/Lyokone/flutterlocation?fbclid=IwAR1TL-4-1ovvbr-vt1qoXLJgy6AmplCObfH1yotTYpBpON7qQA8iG1p5UU4

## 1. Example: 
- instagram clone: https://github.com/mohak1283/Instagram-Clone
- Twitter clone :https://github.com/devdennysegura/flutter-twitter-clone
- open source: https://github.com/nisrulz/flutter-examples
- example app (youtube): https://github.com/iampawan/FlutterExampleApps
- lib ui: https://github.com/Solido/awesome-flutter

## https://github.com/flutter/plugins

## 2. Dart language:
- basic: https://kipalog.com/tags/dart?count=4    https://kipalog.com/posts/Nhung-diem-danh-dau-khi-tim-hieu-ve-Dart

## 3. Flutter_redux
- base: https://viblo.asia/p/flutter-how-to-use-redux-1VgZvpgO5Aw
- demo: https://github.com/zrg-team/flutter_redux
- todoapp: https://github.com/xqwzts/flutter-redux-todo-list

## 4. Networking:
- example: https://github.com/PoojaB26/ParsingJSON-Flutter

## 5. Data local:
### 1. Shared Preferences: 
- example: https://medium.com/flutter-community/shared-preferences-how-to-save-flutter-application-settings-and-user-preferences-for-later-554d08671ae9
### 2. SQLite: 
- lib :https://github.com/tekartik/sqflite
- example: https://grokonez.com/flutter/flutter-sqlite-example-crud-sqflite-example
- tutorial: https://medium.com/flutter-community/using-sqlite-in-flutter-187c1a82e8b
- demo: https://github.com/Rahiche/sqlite_demo
- open asset file: https://stackoverflow.com/a/51387985

## 6. Native module code: 
- example: https://github.com/Nash0x7E2/Flutter-method-channel-tutorial

## 7. Views:
### 1. ListView: 
### a. Cơ bản
- http://eitguide.net/flutter-bai-9-button-va-listview/
- https://medium.com/flutter-community/flutter-listview-and-scrollphysics-a-detailed-look-7f0912df2754
### b. Loadmore
- https://medium.com/@KarthikPonnam/flutter-loadmore-in-listview-23820612907d
### c. Swipe To Refresh to Flutter app
- https://medium.com/flutterpub/adding-swipe-to-refresh-to-flutter-app-b234534f39a7

### d. Listview filter search in Flutter
- https://stackoverflow.com/a/50569613
### e. Add header:
- https://stackoverflow.com/a/49992238
```dart
ListView.builder(
    itemCount: data == null ? 1 : data.length + 1,
    itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
            // return the header
            return new Column(...);
        }
        index -= 1;

        // return row
        var row = data[index];
        return new InkWell(... with row ...);
    },
);
```

## 8. Flutter & Firebase Authentication demo
- https://github.com/bizz84/coding-with-flutter-login-demo

## 9. Json
- https://medium.com/flutter-community/parsing-complex-json-in-flutter-747c46655f51

## 10. AsyncMemoizer: it runs the function only once, and when called again, returns the cached future.
- https://medium.com/saugo360/flutter-my-futurebuilder-keeps-firing-6e774830bc2

## 11. Tablayout
- Flutter Switching to Tab Reloads Widgets and runs FutureBuilder: with AutomaticKeepAliveClientMixin
https://stackoverflow.com/a/51225879/10819917

## 12. Create flugin
- https://proandroiddev.com/build-your-own-plugin-for-flutter-cfee1a08ea3a

## 13. Action sheet (IOS)
- https://flatteredwithflutter.com/actionsheet-in-flutter/
- code: https://github.com/AseemWangoo/flutter_programs/blob/master/CupertinoActionSheet.dart

## 14. Bottom sheet (Android)
- https://flutterdoc.com/bottom-sheets-in-flutter-ec05c90453e7

## 15. Popup Menu Button 
- https://flutterrdart.com/flutter-popup-menu-button-example/

## 16: Bottom Tab:
- https://github.com/flutter/flutter/issues/11895#issuecomment-419297888

## 17. Image
- https://flutter.dev/docs/development/ui/widgets/assets

## 18. Keyword Android and IOS:
```sh 
The keyword for Android theme/style is Material (default design), the keyword for iOS theme/style is Cupertino. Every iOS theme widget has the prefix Cupertino. So that, for you requirement, we can guess the keyword is CupertinoDialog/CupertinoAlertDialog
```
- https://stackoverflow.com/a/53461389

## 19. Flutter calling child class function from parent class
- https://stackoverflow.com/a/53706941

## 20. Chat demo
- https://github.com/duytq94/flutter-chat-demo

## 21. Controlling State from outside of a StatefulWidget
- https://stackoverflow.com/questions/46057353/controlling-state-from-outside-of-a-statefulwidget

## 22. Scrolling Animation in Flutter
- https://medium.com/flutter-community/scrolling-animation-in-flutter-6a6718b8e34f

## 23. MVP, bloc, rxdart, dio..
- https://github.com/KingWu/flutter_starter_kit

## 24. extend class
- https://code-maven.com/slides/dart-programming/extending-class

## 25. Build Flutter
```sh
for that you need to run flutter build ios --release before you archive the app.
This is a known issue.
```
## 26: Hide bottom navigation bar on scroll down and vice versa
- https://stackoverflow.com/questions/54414268/hide-bottom-navigation-bar-on-scroll-down-and-vice-versa

## 27: errorCode

```sh
* 100 Continue
* 101 Switching Protocols
* 200 OK
* 201 Created
* 202 Accepted
* 203 Non-Authoritative Information
* 204 No Content
* 205 Reset Content
* 206 Partial Content
* 300 Multiple Choices
* 301 Moved Permanently
* 302 Found
* 303 See Other
* 304 Not Modified
* 307 Temporary Redirect
* 308 Permanent Redirect
* 400 Bad Request
* 401 Unauthorized
* 403 Forbidden
* 404 Not Found
* 405 Method Not Allowed
* 406 Not Acceptable
* 407 Proxy Authentication Required
* 408 Request Timeout
* 409 Conflict
* 410 Gone
* 411 Length Required
* 412 Precondition Failed
* 413 Payload Too Large
* 414 URI Too Long
* 415 Unsupported Media Type
* 416 Range Not Satisfiable
* 417 Expectation Failed
* 418 I'm a teapot
* 422 Unprocessable Entity
* 425 Too Early
* 426 Upgrade Required
* 428 Precondition Required
* 429 Too Many Requests
* 431 Request Header Fields Too Large
* 451 Unavailable For Legal Reasons
* 500 Internal Server Error
* 501 Not Implemented
* 502 Bad Gateway
* 503 Service Unavailable
* 504 Gateway Timeout
* 505 HTTP Version Not Supported
* 511 Network Authentication Required
```

### 28: Inapp purchase
1. Validating Receipts With the App Store: https://developer.apple.com/library/archive/releasenotes/General/ValidateAppStoreReceipt/Chapters/ValidateRemotely.html#//apple_ref/doc/uid/TP40010573-CH104-SW1
2. set up apk android: https://stackoverflow.com/a/35132936/10819917

### 29: 
1. Car play: https://stackoverflow.com/a/42762956
2. Android auto: https://stackoverflow.com/a/57844089/10819917


