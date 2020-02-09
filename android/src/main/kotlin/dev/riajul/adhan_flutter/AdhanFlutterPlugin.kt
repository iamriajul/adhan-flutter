package dev.riajul.adhan_flutter

import android.util.Log
import androidx.annotation.NonNull;
import com.batoulapps.adhan.*
import com.batoulapps.adhan.data.DateComponents
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.Exception
import java.util.*

/** AdhanFlutterPlugin */
public class AdhanFlutterPlugin: FlutterPlugin, MethodCallHandler {
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "adhan_flutter")
    channel.setMethodCallHandler(AdhanFlutterPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "adhan_flutter")
      channel.setMethodCallHandler(AdhanFlutterPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    try {
      when (call.method) {
        "currentPrayer" -> {
          val prayerTimes = initPrayerTimes(call)
          result.success(prayerTimes.currentPrayer().name)
        }
        "nextPrayer" -> {
          val prayerTimes = initPrayerTimes(call)
          result.success(prayerTimes.nextPrayer().name)
        }
        "timeForPrayer" -> {
          val prayerTimes = initPrayerTimes(call)
          val prayer = call.argument<String>("prayer")!!.toPrayer()
          result.success(prayerTimes.timeForPrayer(prayer).time)
        }
        "fajr" -> {
          val prayerTimes = initPrayerTimes(call)
          result.success(prayerTimes.fajr.time)
        }
        "sunrise" -> {
          val prayerTimes = initPrayerTimes(call)
          result.success(prayerTimes.sunrise.time)
        }
        "dhuhr" -> {
          val prayerTimes = initPrayerTimes(call)
          result.success(prayerTimes.dhuhr.time)
        }
        "asr" -> {
          val prayerTimes = initPrayerTimes(call)
          result.success(prayerTimes.asr.time)
        }
        "maghrib" -> {
          val prayerTimes = initPrayerTimes(call)
          result.success(prayerTimes.maghrib.time)
        }
        "isha" -> {
          val prayerTimes = initPrayerTimes(call)
          result.success(prayerTimes.isha.time)
        }
        else -> {
          result.notImplemented()
        }
      }
    } catch (e: Exception) {
      Log.d("Riajul", e.message)
      result.error("500", e.message, e.localizedMessage.toString())
    }
  }

  private fun initPrayerTimes(call: MethodCall): PrayerTimes {
    val coordinates = Coordinates(call.argument<Double>("latitude")!!, call.argument<Double>("longitude")!!)
    val date = DateComponents.from(Date(call.argument<Long>("date")!!))
    val method = call.argument<String>("method")!!.toCalculationMethod()

    val params = method.parameters

    if (call.hasArgument("madhab")) {
      params.madhab = call.argument<String>("madhab")!!.toMadhab()
    }
    if (call.hasArgument("fajrAngle")) {
      params.fajrAngle = call.argument<Double>("fajrAngle")!!
    }
    if (call.hasArgument("ishaAngle")) {
      params.ishaAngle = call.argument<Double>("ishaAngle")!!
    }
    if (call.hasArgument("ishaInterval")) {
      params.ishaInterval = call.argument<Int>("ishaInterval")!!
    }
    if (call.hasArgument("highLatitudeRule")) {
      params.highLatitudeRule = call.argument<String>("highLatitudeRule")!!.toHighLatitudeRule()
    }

    val prayerTimes = PrayerTimes(coordinates, date, params)
    return prayerTimes
  }

  private fun String.toCalculationMethod(): CalculationMethod {
    return when(this.replace("CalculationMethod.", "")) {
      "MUSLIM_WORLD_LEAGUE" -> CalculationMethod.MUSLIM_WORLD_LEAGUE
      "EGYPTIAN" -> CalculationMethod.EGYPTIAN
      "KARACHI" -> CalculationMethod.KARACHI
      "UMM_AL_QURA" -> CalculationMethod.UMM_AL_QURA
      "DUBAI" -> CalculationMethod.DUBAI
      "QATAR" -> CalculationMethod.QATAR
      "KUWAIT" -> CalculationMethod.KUWAIT
      "MOON_SIGHTING_COMMITTEE" -> CalculationMethod.MOON_SIGHTING_COMMITTEE
      "SINGAPORE" -> CalculationMethod.SINGAPORE
      "NORTH_AMERICA" -> CalculationMethod.NORTH_AMERICA
      "OTHER" -> CalculationMethod.OTHER
      else -> {
       throw Exception("Invalid CalculationMethod")
     }
    }
  }

  private fun String.toHighLatitudeRule(): HighLatitudeRule {
    return when(this.replace("HighLatitudeRule.", "")) {
      "MIDDLE_OF_THE_NIGHT" -> HighLatitudeRule.MIDDLE_OF_THE_NIGHT
      "SEVENTH_OF_THE_NIGHT" -> HighLatitudeRule.SEVENTH_OF_THE_NIGHT
      "TWILIGHT_ANGLE" -> HighLatitudeRule.TWILIGHT_ANGLE
      else -> {
        throw Exception("Invalid HighLatitudeRule")
      }
    }
  }

  private fun String.toMadhab(): Madhab {
    return when(this.replace("Madhab.", "")) {
      "SHAFI" -> Madhab.SHAFI
      "HANAFI" -> Madhab.HANAFI
      else -> {
        throw Exception("Invalid Madhab")
      }
    }
  }

  private fun String.toPrayer(): Prayer {
    return when(this.replace("Prayer.", "")) {
      "NONE" -> Prayer.NONE
      "FAJR" -> Prayer.FAJR
      "SUNRISE" -> Prayer.SUNRISE
      "DHUHR" -> Prayer.DHUHR
      "ASR" -> Prayer.ASR
      "MAGHRIB" -> Prayer.MAGHRIB
      "ISHA" -> Prayer.ISHA
      else -> {
        throw Exception("Invalid Prayer")
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {}
}
