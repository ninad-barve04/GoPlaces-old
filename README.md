# GoPlaces

For a visitor in new city/town it’s hard to find places worth visit and explore the city by visiting the locations that are the centre of attraction.  
So here is the solution.. GoPlaces, an app which acts as guide for you by suggesting the places nearby that are worth a visit, also provides information about the place along with images for you to decide whether to visit it or not. Provides the functionality of rating and liking the place which will be helpful for other users.

## Getting Started

On downloading the app, you are requested to sign in using your Google account. On sign-in, you are requested to enable location permission for the app, else th itenarary function and guidance function will not work.

## Features of the app

Clicking on the marker denoting any place of interest opens a pop up window.  
Here at the top, you are shown a slideshow in images of the place.  
Below this, You get the star rating on the left and like button on the right.  
Next, you have a scrollable information about the place.

### Rating

In this application you can give the touristic place a star based rating of your choice. You have to drag across the stars to submit your rating.  
The star rating displayed is an average of all the ratings given by various users of the app.

You also can like the place.  
The number of likes is updated for all users

### My Places/Visit Later

You can add the places of interest in your My Places list using the Visit Later option. This list data is stored with your Google account. This enables you to have your personal list on any device as long as you login with your account.

### Lets Go

The Lets Go... option provides you a route/directions to visit the selected place.

### Make a trip for me

Another exiting feature of this app is that it will give you a custom itenarary for a city tour. The order is determined by the nearest point of interest from your current loaction and subsequent nearest locations.

## Languages used

- Backend: Python Flask
- SQLite3 for database
- AWS EC2 Linux virtual machine for database and Flask App
- Mobile App (Frontend): Flutter
  - Cross platform mobile framework (Android + iOS + Web)
  - Currently, maps api is not supported on flutter web platform

## To run g.dart file creation

WARNING : Use these commnads only while building the app from the source code in this repository.  
You should have flutter installed in your device.

```sh
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter pub run flutter_launcher_icons:main
```

## TODOs

- Add audio guide
- Pre-planned itinerary for city tour
- Generating suggestions:
  - Based on location types user visited in past
  - Based on popularity of places near current location
- Social Media features
  - Check-in: Visited this place status on social media
  - Share reviews on social media
