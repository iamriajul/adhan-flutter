# *** Use [adhan](https://pub.dev/packages/adhan) for best compatibility and performances ***

# *** DEPRECATED ***

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

**CalculationMethod**

| Value | Description |
| ----- | ----------- |
| `MUSLIM_WORLD_LEAGUE` | Muslim World League. Fajr angle: 18, Isha angle: 17 |
| `EGYPTIAN` | Egyptian General Authority of Survey. Fajr angle: 19.5, Isha angle: 17.5 |
| `KARACHI` | University of Islamic Sciences, Karachi. Fajr angle: 18, Isha angle: 18 |
| `UMM_AL_QURA` | Umm al-Qura University, Makkah. Fajr angle: 18, Isha interval: 90. *Note: you should add a +30 minute custom adjustment for Isha during Ramadan.* |
| `DUBAI` | Method used in UAE. Fajr and Isha angles of 18.2 degrees. |
| `QATAR` | Modified version of Umm al-Qura used in Qatar. Fajr angle: 18, Isha interval: 90. |
| `KUWAIT` | Method used by the country of Kuwait. Fajr angle: 18, Isha angle: 17.5 |
| `MOON_SIGHTING_COMMITTEE` | Moonsighting Committee. Fajr angle: 18, Isha angle: 18. Also uses seasonal adjustment values. |
| `SINGAPORE` | Method used by Singapore. Fajr angle: 20, Isha angle: 18. |
| `NORTH_AMERICA` | Referred to as the ISNA method. This method is included for completeness but is not recommended. Fajr angle: 15, Isha angle: 15 |
| `KUWAIT` | Kuwait. Fajr angle: 18, Isha angle: 17.5 |
| `OTHER` | Fajr angle: 0, Isha angle: 0. This is the default value for `method` when initializing a `CalculationParameters` object. |

**Madhab**

| Value | Description |
| ----- | ----------- |
| `SHAFI` | Earlier Asr time |
| `HANAFI` | Later Asr time |

**HighLatitudeRule**

| Value | Description |
| ----- | ----------- |
| `MIDDLE_OF_THE_NIGHT` | Fajr will never be earlier than the middle of the night and Isha will never be later than the middle of the night |
| `SEVENTH_OF_THE_NIGHT` | Fajr will never be earlier than the beginning of the last seventh of the night and Isha will never be later than the end of the first seventh of the night |
| `TWILIGHT_ANGLE` | Similar to `SEVENTH_OF_THE_NIGHT`, but instead of 1/7, the fraction of the night used is fajrAngle/60 and ishaAngle/60 |

## Example

View the Flutter app in the `example` directory to see all the available `Examples`.

## Projects Used

- ### [adhan-java](https://github.com/batoulapps/adhan-java)
   - Java (Android) implementation
   
## TODO
- Add iOS Support using [adhan-swift](https://github.com/batoulapps/adhan-swift)
- ~~Port [adhan-java](https://github.com/batoulapps/adhan-java) to Dart.~~ Done, here you go: [adhan](https://pub.dev/packages/adhan) for dart.
