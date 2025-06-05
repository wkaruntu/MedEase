import java.util.Properties // Import the Properties class

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Define and load local.properties at the top
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().buffered().use { localProperties.load(it) }
}

android {
    namespace = "com.example.medease"
    compileSdk = flutter.compileSdkVersion.toString().toInt()
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.medease"
        minSdkVersion(23)
        targetSdkVersion((localProperties.getProperty("flutter.targetSdkVersion") ?: flutter.targetSdkVersion.toString()).toInt())
        versionCode = (localProperties.getProperty("flutter.versionCode")?.toInt()) ?: flutter.versionCode.toString().toInt()
        versionName = localProperties.getProperty("flutter.versionName") ?: flutter.versionName.toString()
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
