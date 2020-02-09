# adhan_flutter

This plugin is an Intergration for [adhan-java](https://github.com/batoulapps/adhan-java) Library in Flutter using [Platform Intergration/Platform Channels](https://flutter.dev/docs/development/platform-integration/platform-channels).

## Installation

In the `dependencies:` section of your `pubspec.yaml`, add the following line:

```yaml
  adhan_flutter: <latest_version>
```

## Usage

```dart
// intl package for formatting date & time
import 'package:intl/intl.dart';
import 'package:adhan_flutter/adhan_flutter.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // getTodayFajrTime()
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getTodayFajrTime(),
            builder: (context, AsyncSnapshot<DateTime> snapshot) {
              if (snapshot.hasData) {
                final dateTime = snapshot.data.toLocal();
                return Text(DateFormat.jm().format(dateTime), style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold
                ),);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Text('Waiting...');
              }
            },
          ),
        ),
        
        // getCurrentPrayer()
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getCurrentPrayer(),
            builder: (context, AsyncSnapshot<Prayer> snapshot) {
              if (snapshot.hasData) {
                final prayer = snapshot.data;
                return Text(prayer.toString(), style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold
                ),);
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return Text('Waiting...');
              }
            },
          ),
        ),
      ]
    );
  }
  
  Future<DateTime> getTodayFajrTime() async {
    final adhan = AdhanFlutter.create(Coordinates(latitude, longitude), DateTime.now(), CalculationMethod.KARACHI);
    return await adhan.fajr;
  }

  Future<Prayer> getCurrentPrayer() async {
    final adhan = AdhanFlutter.create(Coordinates(latitude, longitude), DateTime.now(), CalculationMethod.KARACHI);
    return await adhan.currentPrayer();
  }
}
```

## Example

View the Flutter app in the `example` directory to see all the available `Examples`.

## Projects Used

- ### [adhan-java](https://github.com/batoulapps/adhan-java)
   - Java (Android) implementation
   
## TODO
- Add iOS Support using [adhan-swift](https://github.com/batoulapps/adhan-swift)
- Port [adhan-java](https://github.com/batoulapps/adhan-java) to Dart.
