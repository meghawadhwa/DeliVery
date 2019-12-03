# DeliVery
To run this app, please follow following steps:

1. Open terminal and go to root project folder where .podfile is stored.
2. Run "pod install/update" to get all required dependencies.
3. Once command run successfully, go to project folder and open .xcworkspace file in xcode.

# Requirements

- XCode 10.2
- MAC 10.14

# App Version

- 1.0

# Supported iOS Versions

- iOS 10.0 +

# Language 

- Swift 5.1

# Test Requirements

- Test driven developement
- Used OHTTPStubs for unit testing purpose
- XCUITest not covered in this project.

# App Architecture

Delivery challenge app test driven developement and protocol oriented design using the given design patterns
1. MVVM
2. Adapter design pattern
3. Facade Design pattern

Please find below the different layers of the architecture:

1. View / View Controller - This layer is responsible for getting UI interactions and updating UI based on callback from viewModel class.
2. ViewModel - This layer contains all business logic and list of models required for the view controller.
3. NetworkAdaptor - This layer makes and recieves the data from the network which is parsed by model layer.
4. Cache - Responsible to handle data from DB.
5. Config - Configurators like CoreDataStack and URL RequestConfigurator - used by Cache and networkAdaptors for configuring requests.
6. Models - Seperate Cache Models and Data transfer response models used for UI.

Architechture Diagram:

![ScreenShot](https://github.com/meghawadhwa/DeliveryChallenge/blob/master/Screenshots/Architecture.png)


# Offline Support

1. App using CoreData with Sqlite to make cache of JSON response.
2. For Image caching, App is using third party library SDWebImage.
3. App has implemented pull to refresh functionality in following way:
  - If user make pull to refresh class and either internet is off OR server return error, previous rendered list will remain unchanged in that case.
  - If server return error but cache found, then app displays initial data in TableView.
  - If server return proper response, app display data and call for DB cache.
4. Data is refreshed by deleting the old cache after fetching new response

# Assumptions        
1. App supports Localization, but for this version app contains only english strings.     
2. App supports iPhone device in Portrait mode only. 
3. Supported mobile platforms are iOS (10.x, 11.x, 12.x,13.x)        
4. All iphones supported the supported iOS versions.

# Crashlytics

App has implemented crashlytics using Fabric. Here is the steps for crashlytics setup.
1. Create Organization on Fabric, it can be named as your company.
2. Then simply update app configurations as per your organization. Please follow https://fabric.io/kits/ios/crashlytics/install for the same.

# Lint using Swiftlint
1. Install the SwiftLint is by downloading SwiftLint.pkg from latest GitHub release and running - https://github.com/realm/SwiftLint/releases
2. Or by HomeBrew by running "brew install swiftlint" command
3. Add the run script in the xcode (target -> Build phase -> run script -> add the script) if not added
4. If need to change the rules of swiftlint, go to root folder of the project
5. Open the .swiftlint.yml file and modify the rules based on the requirement

# Libraries used

- SDWebImage
- ReachabilitySwift
- OHTTPStubs
- Firebase
- Crashlytics
- SnapKit
- SwiftLint
# Network Calls

App used native NSURLSession for making network calls.

# App Data Flow

As soon DeliveryChallenge App is launched, we display a list of deliveries to be shipped. It fetches all deliveries listing from the API if nothing is already available in local cache. Once fetched from the API, it stores all the fetched deliveries in cache and uses it to be fetched next time when app opens up. 

1. App makes a fetch request from local DB.
2. In case data is not found, a network request is made based on the desired page and offset.
3. In case of successful network request, deliveries are cached and displayed and next page can be fetched.
4. In case of any error from API or no reachability of network, appropriate error is displayed.


# Displaying Map

1. Once user select any addess, app shows annotation to selected address and user details.

# Pagination Approach

App checks if more pages are available in cache first and then fetches from server. This continues until no data is found.
In case of offline mode, app will continue to fetch from cache or server and gives appropriate errors if data is not found.

# ScreenShots

![ScreenShot](https://github.com/meghawadhwa/DeliveryChallenge/blob/master/Screenshots/List.png)
![ScreenShot](https://github.com/meghawadhwa/DeliveryChallenge/blob/master/Screenshots/Detail.png)


# TODO / Improvements

-  UI test cases
- CI/ CD
