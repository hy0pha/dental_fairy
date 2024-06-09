package com.example.capstone2

import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.net.wifi.WifiNetworkSpecifier
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.opencv.android.OpenCVLoader
import org.opencv.core.Core
import org.opencv.core.Mat
import org.opencv.core.Scalar
import org.opencv.imgcodecs.Imgcodecs
import org.opencv.imgproc.Imgproc

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.capstone2/network"
    private lateinit var connectivityManager: ConnectivityManager
    private lateinit var networkCallback: ConnectivityManager.NetworkCallback

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (!OpenCVLoader.initDebug())
            Log.e("OpenCV", "Unable to load OpenCV!")
        else
            Log.d("OpenCV", "OpenCV loaded Successfully!")

        connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        networkCallback = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                connectivityManager.bindProcessToNetwork(network)
            }

            override fun onLost(network: Network) {
                connectivityManager.bindProcessToNetwork(null)
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "openWifiSettings" -> {
                    openWifiSettings()
                    result.success(null)
                }
                "connectToWifi" -> {
                    val ssid = call.argument<String>("ssid")
                    val password = call.argument<String>("password")
                    if (ssid != null && password != null) {
                        connectToWifi(ssid, password)
                        result.success(null)
                    } else {
                        result.error("UNAVAILABLE", "WiFi credentials not available.", null)
                    }
                }
                "analyzeImage" -> {
                    val imagePath = call.argument<String>("path")
                    if (imagePath != null) {
                        val analysisResult = analyzeImage(imagePath)
                        result.success(analysisResult)
                    } else {
                        result.error("UNAVAILABLE", "Image path not available.", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun openWifiSettings() {
        val intent = Intent(Settings.ACTION_WIFI_SETTINGS)
        startActivity(intent)
    }

    private fun connectToWifi(ssid: String, password: String) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val specifier = WifiNetworkSpecifier.Builder()
                .setSsid(ssid)
                .setWpa2Passphrase(password)
                .build()

            val request = NetworkRequest.Builder()
                .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
                .setNetworkSpecifier(specifier)
                .build()

            connectivityManager.requestNetwork(request, networkCallback)
        } else {
            // Handle connection for devices with API level below 29
        }
    }

    private fun analyzeImage(imagePath: String): String {
        val image = Imgcodecs.imread(imagePath)
        if (image.empty()) {
            return "Invalid image"
        }

        val hsvImage = Mat()
        Imgproc.cvtColor(image, hsvImage, Imgproc.COLOR_BGR2HSV)

        val lowerRed = Scalar(0.0, 206.0, 24.0)
        val upperRed = Scalar(89.0, 255.0, 42.0)
        val lowerRed2 = Scalar(11.0, 206.0, 24.0)
        val upperRed2 = Scalar(179.0, 255.0, 42.0)

        val mask1 = Mat()
        val mask2 = Mat()
        Core.inRange(hsvImage, lowerRed, upperRed, mask1)
        Core.inRange(hsvImage, lowerRed2, upperRed2, mask2)

        val mask = Mat()
        Core.bitwise_or(mask1, mask2, mask)

        val redPixels = Core.countNonZero(mask)
        val totalPixels = image.rows() * image.cols()
        val redRatio = redPixels.toDouble() / totalPixels * 100

        return if (redRatio > 20) {
            "Detected cavities: $redRatio%"
        } else {
            "No cavities detected: $redRatio%"
        }
    }
}
