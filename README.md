# flutter_module_to_react_native
- create react app and react module
<br/>
<br/>
<br/>

# CONFIG

## android -> app -> src -> main -> AndroidManifest (react app)
   - add

    <activity
            android:name="io.flutter.embedding.android.FlutterActivity"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:exported="false"
            android:theme="@style/AppTheme"
            android:windowSoftInputMode="adjustResize" />

## android -> app -> build.gradle (react app and react module)
- add/update repositories (react app and react module)
  

        def storageUrl =  System.env.FLUTTER_STORAGE_BASE_URL ?: "https://storage.googleapis.com"
        repositories { 
            maven {
                url '\\flutter_module_to_react_native\\build\\host\\outputs\\repo'
            }
            maven {
                url "$storageUrl/download.flutter.io"
            }
            google()
            mavenCentral()
        }


- add/update dependencies (react app)

        dependencies {
            implementation fileTree(dir: 'libs', include: ['*.aar'])
            // The version of react-native is set by the React Native Gradle Plugin
            implementation("com.facebook.react:react-android")
            implementation("com.facebook.react:flipper-integration")

            if (hermesEnabled.toBoolean()) {
                implementation("com.facebook.react:hermes-android")
            } else {
                implementation jscFlavor
            }
            debugImplementation 'com.example.flutter_module_to_react_native:flutter_debug:1.0'
            profileImplementation 'com.example.flutter_module_to_react_native:flutter_profile:1.0'
            releaseImplementation 'com.example.flutter_module_to_react_native:flutter_release:1.0'
        }

- add/update dependencies (react module)

        dependencies {
            debugImplementation 'com.example.flutter_module_to_react_native:flutter_debug:1.0'
            profileImplementation 'com.example.flutter_module_to_react_native:flutter_profile:1.0'
            releaseImplementation 'com.example.flutter_module_to_react_native:flutter_release:1.0'
        }

## cache flutter engine (react app) android -> app -> src -> main -> .... MainApplication
- import
    
        import io.flutter.embedding.engine.FlutterEngine
        import io.flutter.embedding.engine.FlutterEngineCache
        import io.flutter.embedding.engine.dart.DartExecutor

- onCreate
  
        private const val FLUTTER_ENGINE_ID = "flutter_engine"

        lateinit var flutterEngine : FlutterEngine
        
        override fun onCreate() {
            super.onCreate()

            flutterEngine = FlutterEngine(this)

            flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
            )

            FlutterEngineCache
            .getInstance()
            .put(FLUTTER_ENGINE_ID, flutterEngine)

            SoLoader.init(this, false)
            if (BuildConfig.IS_NEW_ARCHITECTURE_ENABLED) {
            // If you opted-in for the New Architecture, we load the native entry point for this app.
            load()
            }
            ReactNativeFlipper.initializeFlipper(this, reactNativeHost.reactInstanceManager)
        }

# open page
- create function (react module)

        @ReactMethod
        fun openFlutterPage() {
            val currentActivity: Activity? = currentActivity
            if(currentActivity == null) {
            Log.d("OPEN", "currentActivity: null")
            }

            currentActivity!!.startActivity(
                FlutterActivity.withCachedEngine("flutter_engine").build(currentActivity)
            )
        }
    
- call function
            import { openFlutterPage } from './modules/react_module/src';


            function open () {
                openFlutterPage();
            }