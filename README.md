#  App Setting Dynamic Change "Domain" and "Force Update Dialog Popup"

## Dynamic Change Base Url & Feature Force Update New Version From Google Play and Apple Store"

## Guide For Backend & Mobile Developer :  Setup Dynamic Domain Link & Force Update Mini version

-----

-----

# Guide For Backend Developer:

## 1- create account email from console of firebase project

* visit link:
  https://console.firebase.google.com/project/maqsafy-egypt/authentication/users

* create account
```
- Email   :
developer.firebase@dafagate.com

- Password   account:" 
12345678

```

### Notice: This password for testing mode, don't forget to change it in live


## 2- create realtime database, set rules  (copy/past) :

```
{
  "rules": {
    "app_setting": {
      ".read": "true",
      ".write": "auth != null && auth.token.email == 'developer.firebase@dafagate.com'",
      
    }
  }
}

```


## 3- create realtime database data :

* manuel create data at path    /app_setting/
```
{
    "base_url_dynamic": "http://new.com",
    "min_version_ios": 116,
    "mmin_version_android": 116
}
```


## 4- To update from Postman RESTFul api

### Config at HTTP Request :

* create new request in postman type "PUT" with url of project-id

* To Get Url with project id :
  . Just visit console firebase  >> realtime database >> will found in database url
  .  exmaple like to:    https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app/


* Header add : "Content-Type" value "application/json"


#### How to Get URL with ProjectId firebase:

* Firebasee Console >> Realtime Database >> Tab "Data" >> found url here

* formula:
  https://<project-id>.firebaseio.com/

* example
  https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app/

### How to Get dynamic app setting  :

* this public data, make it public to get this information no validation needed

* full url : project id with endpoint + end with ".json"
  https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app/app_setting/

* full with .json
  GET https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app/app_setting.json


### How to get Access Token  (to be have access to update setting ) :
1. Get Web API KEY:
* Firebase project's Web API key (from Firebase Console → Project Settings → General → Web API Key
* Register new <> web application, will show vlaue here :
  const firebaseConfig =  {  apiKey: "AIza************************",  ..... }

2. in postman http request : POST https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=YOUR_WEB_API_
* payload :
```
{
  "email": "developer.firebase@dafagate.com",
  "password": "12345678",
  "returnSecureToken": true
}
```

* postman save variable >> script tab >> post response (copy/past):
```
  
let responseData = pm.response.json();
pm.environment.set("firebase_access_token_admin", responseData.idToken);
 
```

* the above code show the "idToken" will be saved at variable named "firebase_access_token_admin"


### How to update min version ( force update feature ) :

- endpoint
  /app_setting/force_update_min_version

- example: Http Request with .json + auth in paramter:
  PATCH https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app/app_setting.json?auth={{firebase_access_token_admin}}
* payload
```
{
    "min_version_ios": 116,
    "mmin_version_android": 116
}
```

### How to update base url dynamic :

- endpoint
  /app_setting/base_url_dynamic

- example: Http Request with .json + auth in paramter:  
  PATCH https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app/app_setting.json?auth={{firebase_access_token_admin}}
* payload
```
{
    "base_url_dynamic":  "https://new.com"
}
```
 
------

------

# Guide For Mobile Developer :

## Config In Flutter:


### 1. How to Get URL with ProjectId firebase:

* Firebasee Console >> Realtime Database >> Tab "Data" >> found url here

* formula:
  https://<project-id>.firebaseio.com/

* example
  https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app/


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

* before call the "di" dependence injection , set default baseUrl:
``` 
  /// before init Dio Helper Config 
  ///    >> example if you using dependant   indjection 
  ///        must to set baseUrl default before init dio helper class
  AppSettingDynamicInstaller.setConfigBaseUrls(
    domainDefault: 'https://test4.maqsafy.com',
    firebaseBaseUrl: "https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app",
  );

```
(  If app not have "DI" write before runApp() at any line)

* wrap MyApp()  in case there, then update "di/dio helper"
```
  runApp( AppSettingDynamicRunApp(
      currentVersionValidateForForceUpdate: versionDevelopment,
      linkUpdateApplestore: "https://apps.apple.com/ag/app/%D9%85%D9%82%D8%B5%D9%81%D9%8A/id1493287507",
      linkUpdateGoogleplay:  "https://play.google.com/store/apps/details?id=com.maqsafy",
      onNeedUpdateDioHelperBaseUrl: (){
        /// (Optional In Case Use "DI" )update "di" dependant inject of baseurl
        di.reRegisterDependentInjectionForDioHelper();
      },
      builder: (context)   {
        return myApp;
      },
  ));
```


### 4. In Video Splash Screen

* in case you have video splash screen, we can save time of user, while user watching on video splash
  we download data of Setting Dynamic

#### - example: we assume you have screen called "SplashVideoScreen.dart" type WidgetStateFull

*  Code at initState() :
```
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async { 
      await setupAppSettingDynamicListener(); 
    });
  }

  setupAppSettingDynamicListener() async {
    await AppSettingDynamicInstaller.addOnCompleteSplash( ( response ) {

        /// case:  video in progress, while api setting completed before video
        if(isVideoSplashCompleted  == false ) {
          return;

          /// case:  video completed, while api setting completed after video
        } else {
          chooseNextPageLive();
        }

      });
  }

```

* Code at video player controller listener
* set the "isVideoSplashCompleted" to be true, when video controller say it's completed video showing
``` 
  listenerVideoCompleted() async {
     
      isVideoSplashCompleted = true;

      if( AppSettingDynamicController.isCompleteDownloadData() ){
          navigateToHome();
      }
    }
  }
```

* Notice : method    "navigateToHome();" make Navigate to screen after splash, example home screen

### 5- How To Get New BaseUrl Domain Dynamic
* By Using Method
```
var baseUrl = AppSettingDynamicInstaller.getDomain(); 
```

## Use at Any Framework : Like Native kotlin or swift :
* How to Get dynamic app setting  Json Data :

* this public data, make it public to get this information no validation needed

* full url : project id with endpoint + end with ".json" + parmeter auth token "auth=accessToken"
  https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app/app_setting/

* full with .json
  GET https://maqsafy-egypt-default-rtdb.asia-southeast1.firebasedatabase.app/app_setting.json



-----

-----


# Developed By Company MASARAT

## Company

<img style="width: 100%;" src="https://raw.githubusercontent.com/AbdallahDafa/hyper_pay_flutter_plugin/refs/heads/main/screenshot/company/cover_masarat.png"  />


<table style="background-color: #f0f0f0; border-collapse: collapse; width: 100%;" >

  <tr  > 
    <td >
      <img src="https://raw.githubusercontent.com/AbdallahDafa/hyper_pay_flutter_plugin/refs/heads/main/screenshot/company/logo_masarat.png"  width="80"/>
    </td>
    <td>
      <h3>MASARAT<br/>
      <a href="https://www.linkedin.com/company/dafa-sa/">Linkedin</a><br/>
      <a href="https://masaratech.com/">Website</a></h3>
    </td>
  </tr>
</table>


## Team Member

<table style="background-color: #1B4354; border-collapse: collapse; " >


  <tr style="background-color: #a9a9a9;" > 
    <td >
      <img src="https://raw.githubusercontent.com/AbdallahDafa/hyper_pay_flutter_plugin/refs/heads/main/screenshot/dev-teachlead.png"  width="80"/>
    </td>
    <td>
      <h3>Teach Lead<br/>Elamir Mahmoud<br/>
      <a href="https://www.linkedin.com/in/elamir-mahmoud-b37029104/">Linkedin</a><br/>
      at MASARAT company</h3>
    </td>
  </tr>

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


## MASARAT Proprietary Software License

````
MASARAT Proprietary Software License

Copyright © 2025 MASARAT Company. All rights reserved.

This software is licensed, not sold. By downloading or using this software, you agree to the following terms:

1. Permitted Use
   You are granted a non-exclusive, non-transferable, revocable license to download and use this software only in its original form for personal or internal business purposes.

2. Restrictions
   You may not, under any circumstance:
   - Copy or reproduce any part of the software or its source code.
   - Modify, adapt, translate, reverse-engineer, decompile, or disassemble the software.

3. Ownership
   All rights, title, and interest in and to the software remain the exclusive property of MASARAT.

4. Termination
   This license is effective until terminated. It will terminate automatically without notice if you breach any of its terms. Upon termination, you must cease all use and delete all copies.

5. No Warranty
   This software is provided "as is", without warranty of any kind. MASARAT shall not be liable for any damages resulting from its use.

````

