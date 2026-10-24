#  App Setting Dynamic Change "Domain" and "Force Update Dialog Popup"

-----

-----

## Features :

### Dynamic Change Base Url & Feature Force Update New Version From Google Play and Apple Store"

### Guide For Backend & Mobile Developer :  Setup Dynamic Domain Link & Force Update Mini version

-----

-----

## Screenshots Result :

### Force Update
<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/forceupdate_screen.png" alt="Force Update Google Play or Apple Store" width="200" />

### Postman Get Data
<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/postman_get_app_setting.png" alt="postman_get_app_setting" width="600" />

-----

-----

# Guide For Backend Developer:

## 1- Config Firebase Authentication : 

* create account email from console of firebase project
* visit link Console, then enable Authentication Type Email :
  https://console.firebase.google.com/project/example-project-name/authentication/users

<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/firebase_enable_auth_by_email.png" alt="firebase_enable_auth_by_email" width="600" />


* create account
```
- Email   :
developer.firebase@yourdomain.com

- Password   account:" 
12345678

```

<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/firebase_create_user_email.png" alt="firebase_create_user_email" width="600" />


### Notice: This password for testing mode, don't forget to change it in live


## 2- create realtime database, set rules  (copy/past) :

```
{
  "rules": {
    "app_setting": {
      ".read": "true",
      ".write": "auth != null && auth.token.email == 'developer.firebase@yourdomain.com'",
      
    }
  }
}

```
<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/firebase_create_rules.png" alt="firebase_create_rules" width="600" />


## 3- create realtime database data :

* manuel create data at path    /app_setting/
```
{
    "base_url_dynamic": "http://new.com",
    "min_version_ios": 116,
    "min_version_android": 116,
    "min_version_web": 116
}
```

<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/firebase_create_data.png" alt="firebase_create_data" width="600" />



## 4- To update from Postman RESTFul api

### Config at HTTP Request :

* create new request in postman type "PUT" with url of project-id

* To Get Url with project id :
  . Just visit console firebase  >> realtime database >> will found in database url
  .  example like to:    https://example-project-name-firebase-id.firebasedatabase.app/


* Header add : "Content-Type" value "application/json"
  
<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/postman_update_header.png" alt="postman_update_header" width="600" />
 

#### How to Get URL Of Your ProjectId Of firebase:

* Firebase Console >> Realtime Database >> Click on Tab "Data" >> you will found url here

* formula:
  https://<project-id>.firebaseio.com/

* example
  https://example-project-name-firebase-id.firebasedatabase.app/

<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/firebase_create_data.png" alt="firebase_create_data" width="600" />


### How to Get dynamic app setting  :

* this public data, make it public to get this information no validation needed

* full url : project id with endpoint + end with ".json"
  https://example-project-name-firebase-id.firebasedatabase.app/app_setting/

* full with .json
  GET https://example-project-name-firebase-id.firebasedatabase.app/app_setting.json

<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/postman_get_app_setting.png" alt="postman_get_app_setting" width="600" />


### How to get Access Token Firebase :
*  Access Token Firebase : Needed to be allowed in edit information of baseUrl or ForceUpdate Version or another.

1. Get Web API KEY:
* Firebase project's Web API key (from Firebase Console → Project Settings → General → Web API Key
* Register new <> web application, will show value here :
  const firebaseConfig =  {  apiKey: "AIza************************",  ..... }

<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/firebase_web_config.png" alt="firebase_web_config" width="600" />


2. in postman http request : POST https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=YOUR_WEB_API_
* payload :
```
{
  "email": "developer.firebase@yourdomain.com",
  "password": "12345678",
  "returnSecureToken": true
}
```
<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/postman_get_access_token.png" alt="postman_get_access_token" width="600" />



* postman save variable >> script tab >> post response (copy/past):
```
  
let responseData = pm.response.json();
pm.environment.set("firebase_access_token_admin", responseData.idToken);
 
```

(   the above code show the "idToken" will be saved at variable named "firebase_access_token_admin" )

<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/postman_get_access_set_variable.png" alt="postman_get_access_set_variable" width="600" />


### How to update min version ( force update feature ) :

- endpoint
  /app_setting/force_update_min_version

- example: Http Request with .json + auth in paramter:
  PATCH https://example-project-name-firebase-id.firebasedatabase.app/app_setting.json?auth={{firebase_access_token_admin}}
* payload
```
{
    "min_version_ios": 116,
    "mmin_version_android": 116
}
```

<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/postman_update_force_update.png" alt="postman_update_force_update" width="600" />


### How to update base url dynamic :

- endpoint
  /app_setting/base_url_dynamic

- example: Http Request with .json + auth in paramter:  
  PATCH https://example-project-name-firebase-id.firebasedatabase.app/app_setting.json?auth={{firebase_access_token_admin}}
* payload
```
{
    "base_url_dynamic":  "https://new.com"
}
```

<img src="https://raw.githubusercontent.com/AbdallahDafa/DynamicBaseUrlAndForceUpdate/refs/heads/main/screenshot/postman_update_baseurl_dynamic.png" alt="postman_update_baseurl_dynamic" width="600" />

------

------

# Guide For Mobile Developer :

## Config In Flutter:

* one import for everything (`AppSettingDynamicNotifier`, `AppSettingDynamicRunApp`, `AppSettingForceUpdateCheckerWidget`, ...):
```
import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update.dart';
```


### 1. How to Get URL with ProjectId firebase:

* Firebasee Console >> Realtime Database >> Tab "Data" >> found url here

* formula:
  https://<project-id>.firebaseio.com/

* example
  https://example-project-name-firebase-id.firebasedatabase.app/


### 2. Set method reRegister in "di" ( Optional For DependentInjection  )

( skip this step in case you not set "dio" at "di" )

* At your code class "Di" DependentInjection, update "Dio Helper" class
```` 
Future reRegisterDependentInjectionForDioHelper() async {
  // Step 2: Unregister the previous one if already registered
  if (sl.isRegistered<ApiUtil>()) {
    print("reRegisterDependentInjectionForDioHelper() - Unregister the previous one");
    sl.unregister<ApiUtil>();
  }
  /// network
  ApiUtil api = await ApiUtil.instance();
  sl.registerLazySingleton<ApiUtil>(() => api);
}
````


### 3. in main method write :

* before call the "di" dependence injection, set default baseUrl and **await** it:
```
Future<void> main() async {

  /// before init Dio Helper Config ("di")
  ///    also loads the last setting saved on the device (cache):
  ///    local read, no network, works offline
  await AppSettingDynamicNotifier.instance.setConfigBaseUrls(
    domainDefault: 'https://test4.maqsafy.com',
    firebaseBaseUrl: "https://maqsafy-egypt-default-rtdb.firebasedatabase.app",
  );

  await di.init(); // dio helper reads AppSettingDynamicNotifier.instance.domain

  runApp( ... ); // next step
}
```
(  If app not have "DI" write before runApp() at any line)

* wrap MyApp()  in case there, then update "di/dio helper"
* `AppSettingDynamicRunApp` provides `AppSettingDynamicNotifier` (Provider `ChangeNotifier`) to all the app
```
  runApp( AppSettingDynamicRunApp(
      currentVersionValidateForForceUpdate: versionDevelopment,
      linkUpdateApplestore: "https://apps.apple.com/ag/app/%D9%85%D9%82%D8%B5%D9%81%D9%8A/id12345678",
      linkUpdateGoogleplay:  "https://play.google.com/store/apps/details?id=com.example.app",
      onNeedUpdateDioHelperBaseUrl: (){
        /// called only when the base url changes while the app is running
        /// (a new url downloaded from firebase)
        di.reRegisterDependentInjectionForDioHelper();
      },
      builder: (context)   {
        return myApp;
      },
  ));
```

* nothing is downloaded from `main()` or `AppSettingDynamicRunApp`, nothing blocks the app start:
  the download starts only from screens, the splash (optional, step 4) and the home page (required, step 5)


### 4. Splash Screen (optional) : start the download early, never wait for it

* the splash screen can **start** the download to save time, never `await` it:
  with fast, slow or no internet the splash takes the same time, and the app works
  with the cached setting (or `domainDefault`) until the new one is downloaded.
  The home page shares the same request (no second download)

*  Code at initState() :
```
  import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update.dart';
  import 'package:provider/provider.dart';

  @override
  void initState() {
    super.initState();
    /// background download: never throws, never hangs, DON'T await it
    context.read<AppSettingDynamicNotifier>().download();
  }
```

* navigate to home when your splash is done (animation / timer / video), nothing about the network:
```
  /// example: video splash screen, at video player controller listener
  listenerVideoCompleted() {
      navigateToHome();
  }
```

* Notice : method    "navigateToHome();" make Navigate to screen after splash, example home screen


### 5. Home Page : Download + Check Force Update (required)

* the home page always downloads the app setting (or shares the splash download) and checks force update, wrap its content:
```
  import 'package:dynamic_base_url_and_force_update/dynamic_base_url_and_force_update.dart';

  @override
  Widget build(BuildContext context) {
    return AppSettingForceUpdateCheckerWidget(
      child: Scaffold( ... ),
    );
  }
```

* it checks right away with the cached setting, then again when the download finishes
* it starts the download in background when the home page opens (if the splash didn't), and tries
  again a failed download (app opened offline) when the home page opens and when the app comes back to the foreground
* the force-update dialog is shown above all pages and the back button can't close it.
  It closes by itself when the new download says no update is needed (example: you decreased the min version)
* apps with a login screen (that calls your api) before the home page: start the download from the splash,
  and add `AppSettingForceUpdateCheckerWidget` to the login page too. On the first install there is no cache yet,
  so if `domainDefault` stopped working the user would never reach the home page.
  It's safe: the download and the dialog are shared, never doubled

* Or rebuild any widget when the setting changes:
```
  final appSetting = context.watch<AppSettingDynamicNotifier>();

  appSetting.status;                  // download: initial, loading, loaded, failed
  appSetting.isLoading;
  appSetting.isCompleteDownloadData;
  appSetting.response;                // AppSettingFirebaseDynamicResponse? (remote, else cache)
  appSetting.remoteResponse;          // downloaded in this session
  appSetting.cachedResponse;          // last download saved on the device
  appSetting.domain;
  appSetting.domainSource;            // remote, cache, domainDefault
```

### 6- How To Get New BaseUrl Domain Dynamic

* `domain` returns the base url by priority (sync, never waits for the network):
  1. remote response (downloaded in this session), if found
  2. cache (last download saved on the device), if found
  3. `domainDefault` written in `setConfigBaseUrls()`

* Get BaseUrl dynamic (works without BuildContext, example: dio helper / di)
```
var baseUrl = AppSettingDynamicNotifier.instance.domain; 
```

* inside widgets you can also use
```
var baseUrl = context.read<AppSettingDynamicNotifier>().domain; 
```

* How to get From Endpoint Variable
#### => old way
```
static String baseUrlv2 = '${AppSettingDynamicNotifier.instance.domain}/api/v2/';
```
#### => New way get dynamic using method return "=>"
```
  static String baseUrlv2() =>  AppSettingDynamicNotifier.instance.domain + '/api/v2/';
```
(Notice: need to remove "static" or change static filed to method function . 
Due to static fields are initialized only once when the class is first loaded into memory. )

### 7- Apps Opened Offline

* the app opens normally: `domain` comes from the cache (or `domainDefault` on the first install),
  the download fails silently and is tried again when the home page opens and when the app comes back to the foreground
* the cached setting is saved by `shared_preferences`, one per `firebaseBaseUrl`
* force update is checked offline too: with the cached min version (last download)
* for testing: `AppSettingDynamicNotifier.instance.clearCache()`

### 8- Migrate From `AppSettingDynamicInstaller` (deprecated)

| Old | New |
|---|---|
| `AppSettingDynamicInstaller.setConfigBaseUrls(...)` | `await AppSettingDynamicNotifier.instance.setConfigBaseUrls(...)` |
| `AppSettingDynamicInstaller.download()` | splash (optional): `context.read<AppSettingDynamicNotifier>().download()` (don't await it), home: `AppSettingForceUpdateCheckerWidget` |
| `AppSettingDynamicInstaller.getDomain()` | `AppSettingDynamicNotifier.instance.domain` |
| `AppSettingDynamicInstaller.isCompleteDownloadData()` | `appSetting.isCompleteDownloadData` |
| `AppSettingDynamicInstaller.isValidVersionMinAllowed(v)` | `appSetting.isValidVersionMinAllowed(v)` |
| `AppSettingDynamicInstaller.addOnCompleteSplash(...)` | not needed: the splash doesn't wait, use `AppSettingForceUpdateCheckerWidget` or `context.watch<AppSettingDynamicNotifier>()` |

* upgrading from 1.0.7: `AppSettingDynamicRunApp` doesn't show the force-update screen on the root anymore,
  add `AppSettingForceUpdateCheckerWidget` to your home page (step 5)

## Use at Any Framework : Like Native kotlin or swift :
* How to Get dynamic app setting  Json Data :

* this public data, make it public to get this information no validation needed

* full url : project id with endpoint + end with ".json" + parmeter auth token "auth=accessToken"
  https://example-project-name-firebase-id.firebasedatabase.app/app_setting/

* full with .json
  GET https://example-project-name-firebase-id.firebasedatabase.app/app_setting.json



-----

-----


# Developed By 
  

<table style="background-color: #1B4354; border-collapse: collapse; " >
 
  <tr>
    <td>
      <img src="https://raw.githubusercontent.com/AbdallahDafa/hyper_pay_flutter_plugin/refs/heads/main/screenshot/dev-abdallah.png"  width="80"/>
    </td>
    <td>
      <h3>Created by Flutter Developer <br/>Abdallah Mahmoud<br/>
      <a href="https://www.linkedin.com/in/abdallah-android-app/">Linkedin</a><br/>
      at MASARAT company</h3>
    </td>
  </tr>
 

</table>


-----

-----

 
