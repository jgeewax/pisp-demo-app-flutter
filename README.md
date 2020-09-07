# MojaPay
## Introduction

[Mojapay](https://github.com/mojaloop/pisp-demo-app-flutter) was developed to demonstrate the ability of Mojaloop to make end to end transfers. It's a payment initiation app, which allows people to send money to one another. The basic features of the app are

1. Login/Authentication
2. Account Linking
3. Dashboard
4. Transfers

The goal of this document is to serve as a good starting point for someone onboarding onto Mojapay. The document talks about the architecture, design and decisions made in the app and also how one might proceed to add a new feature.

## Tech Stack

1. Mojapay uses flutter for the frontend and uses firebase as a datastore and for authentication.
2. We use [Get](https://pub.dev/packages/get) for state management. Thanks to Get, we have great separation of concerns in our codebase and it vastly reduces the verbosity of flutter syntax.

## Local Setup

1. Clone [this](https://github.com/mojaloop/pisp-demo-app-flutter) repository.
2. [Install](https://flutter.dev/docs/get-started/install) the flutter sdk.
3. [Install](https://developer.android.com/studio/install) Android Studio.
4. Install flutter and dart plugin on android studio. Go to File->Settings->Plugins and install flutter plugin.
5. Clone the repository and open the pisp\_app from android studio
6. Go to settings -> flutter and add the path to flutter SDK if not already present.
7. Get your google-services.json from firebase. Follow the steps [here](https://www.digitalocean.com/community/tutorials/flutter-firebase-setup) This is necessary to build the app successfully.
8. Make sure you enter the app's SHA-1 fingerprint under the [Settings page](https://console.firebase.google.com/u/0/project/_/settings/general) of your Firebase console as this is required to ensure that Google sign-in functions properly. You can get the app's debug SHA-1 fingerprint by running this command: `keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore`.
9. Connect device/ emulator and run the app.

## JSON Serialization

To generate the files that handle JSON encoding/decoding for model objects (e.g. consent.g.dart), run `flutter pub run build_runner build` in the project directory.
   
## Docs

Read the docs [here](docs/)
The linking diagrams are [here](https://github.com/mojaloop/pisp-demo-server/tree/master/docs/assets/diagrams/transfer)
