# Weather App

This is a weather application developed in Swift that queries a weather service to obtain the user's current location and displays the weather forecast in the device's language.

<img height="400" alt="weatherapp" src="https://github.com/AlexLopezDevelop/weatherapp/assets/32960226/a7d84a6c-0a20-435e-ac36-af1f28ca6c5c">
<img height="400" alt="weatherapp" src="https://github.com/AlexLopezDevelop/weatherapp/assets/32960226/710364f7-0ac7-48cc-b939-b566b0a4853a">
<img height="400" alt="weatherapp" src="https://github.com/AlexLopezDevelop/weatherapp/assets/32960226/37c93703-db83-4ad4-9b15-98e56b142cd8">
<img height="400" alt="weatherapp" src="https://github.com/AlexLopezDevelop/weatherapp/assets/32960226/a7ed5552-0bdf-40f1-927b-aff28ae019c9">

## APIs Used

This application utilizes the [OpenWeatherMap One Call API](https://openweathermap.org/api/one-call-api) to access weather information.

## Requirements

- Swift 5.0 or later
- Xcode 11.0 or later

## Installation

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. In the project navigator, locate the `Development.xconfig` file.
4. Open the `Development.xconfig` file and add your API key from [OpenWeatherMap](https://openweathermap.org/api/one-call-api) in the following format:

    ```
    API_KEY = // Add your API key
    ```

   Replace `// Add your API key` with your actual API key.

5. Save the `Development.xconfig` file.

6. Build and run the application in Xcode.

## Language Support

The Weather App supports the following languages:

- English 🇺🇸
- Spanish 🇪🇸
- French 🇫🇷

To change the language of the app, ensure that your device is set to one of the supported languages.


## License

This project is licensed under the [MIT License](LICENSE).

## Comments

- `enableLocationView` has been created to showcase how to build a view without using Storyboards. However, the rest of the project has been developed using Storyboards and XIBs, as they are what I'm most accustomed to and allowed me to progress more quickly.

- No external libraries have been used, so there was no need for CocoaPods. In my opinion, it's generally better to rely on the tools provided by the Swift API, as it avoids dependency issues that may arise when migrating the app to a newer Swift version. However, in the part where obtaining the city name from the user's location, it could be improved by implementing a library that handles all possible cases. Unusual scenarios have been tested, such as locations in the northern part of Greenland, where the city name may not be available due to limited data.

- The `.xcconfig` file has been added to store the ApiKey, providing convenience for configuration purposes.




