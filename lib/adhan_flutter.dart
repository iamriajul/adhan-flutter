import 'dart:async';

import 'package:flutter/services.dart';

class AdhanFlutter {
  static const MethodChannel _channel = const MethodChannel('adhan_flutter');

  static Adhan create(Coordinates coordinates, DateTime date, CalculationMethod method) {
    return Adhan(coordinates, date, method);
  }
}

class Adhan {
  Coordinates _coordinates;
  DateTime _date;
  CalculationMethod _method;
  double _fajrAngle;
  double _ishaAngle;
  int _ishaInterval;
  Madhab _madhab;
  HighLatitudeRule _highLatitudeRule;

  Adhan(this._coordinates, this._date, this._method);

  void setMadhab(Madhab madhab) {
    _madhab = madhab;
  }

  void setHighLatitudeRule(HighLatitudeRule highLatitudeRule) {
    _highLatitudeRule = highLatitudeRule;
  }

  Map<String, dynamic> _buildArguments() {
    final arguments = <String, dynamic>{
      'latitude': _coordinates.latitude,
      'longitude': _coordinates.longitude,
      'date': _date.millisecondsSinceEpoch,
      'method': _method.toString(),
    };
    if (_madhab != null) {
      arguments['madhab'] = _madhab.toString();
    }
    if (_fajrAngle != null) {
      arguments['fajrAngle'] = _fajrAngle;
    }
    if (_ishaAngle != null) {
      arguments['ishaAngle'] = _ishaAngle;
    }
    if (_ishaInterval != null) {
      arguments['ishaInterval'] = _ishaInterval;
    }
    if (_highLatitudeRule != null) {
      arguments['highLatitudeRule'] = _highLatitudeRule.toString();
    }
    return arguments;
  }

  Future<Prayer> currentPrayer() async {
    String prayerName = await AdhanFlutter._channel.invokeMethod<String>('currentPrayer', _buildArguments());
    return prayerName.toPrayer();
  }

  Future<Prayer> nextPrayer() async {
    String prayerName = await AdhanFlutter._channel.invokeMethod<String>('nextPrayer', _buildArguments());
    return prayerName.toPrayer();
  }

  Future<DateTime> timeForPrayer(Prayer prayer) async {
    final arguments = _buildArguments();
    arguments['prayer'] = prayer.toString();
    int prayerTime = await AdhanFlutter._channel.invokeMethod<int>('timeForPrayer', arguments);
    return DateTime.fromMillisecondsSinceEpoch(prayerTime);
  }

  Future<DateTime> get fajr async {
    int prayerTime = await AdhanFlutter._channel.invokeMethod<int>('fajr', _buildArguments());
    return DateTime.fromMillisecondsSinceEpoch(prayerTime);
  }

  Future<DateTime> get sunrise async {
    int prayerTime = await AdhanFlutter._channel.invokeMethod<int>('sunrise', _buildArguments());
    return DateTime.fromMillisecondsSinceEpoch(prayerTime);
  }

  Future<DateTime> get dhuhr async {
    int prayerTime = await AdhanFlutter._channel.invokeMethod<int>('dhuhr', _buildArguments());
    return DateTime.fromMillisecondsSinceEpoch(prayerTime);
  }

  Future<DateTime> get asr async {
    int prayerTime = await AdhanFlutter._channel.invokeMethod<int>('asr', _buildArguments());
    return DateTime.fromMillisecondsSinceEpoch(prayerTime);
  }

  Future<DateTime> get maghrib async {
    int prayerTime = await AdhanFlutter._channel.invokeMethod<int>('asr', _buildArguments());
    return DateTime.fromMillisecondsSinceEpoch(prayerTime);
  }

  Future<DateTime> get isha async {
    int prayerTime = await AdhanFlutter._channel.invokeMethod<int>('isha', _buildArguments());
    return DateTime.fromMillisecondsSinceEpoch(prayerTime);
  }
}

extension PrayerString on String {
  Prayer toPrayer() {
    switch (this) {
      case "NONE": {
        return Prayer.NONE;
      }
      case "SUNRISE": {
        return Prayer.SUNRISE;
      }
      case "FAJR": {
        return Prayer.FAJR;
      }
      case "DHUHR": {
        return Prayer.DHUHR;
      }
      case "ASR": {
        return Prayer.ASR;
      }
      case "MAGHRIB": {
        return Prayer.MAGHRIB;
      }
      case "ISHA": {
        return Prayer.ISHA;
      }
    }
  }
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates(this.latitude, this.longitude);
}

enum Prayer {
  NONE,
  FAJR,
  SUNRISE,
  DHUHR,
  ASR,
  MAGHRIB,
  ISHA,
}

enum CalculationMethod {
  MUSLIM_WORLD_LEAGUE,
  EGYPTIAN,
  KARACHI,
  UMM_AL_QURA,
  DUBAI,
  QATAR,
  KUWAIT,
  MOON_SIGHTING_COMMITTEE,
  SINGAPORE,
  NORTH_AMERICA,
  OTHER,
}

enum Madhab {
  SHAFI,
  HANAFI,
}

enum HighLatitudeRule {
  MIDDLE_OF_THE_NIGHT,
  SEVENTH_OF_THE_NIGHT,
  TWILIGHT_ANGLE,
}