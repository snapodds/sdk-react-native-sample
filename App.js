import { StatusBar } from 'expo-status-bar';
import React from 'react';
import { StyleSheet, View, Text, Button } from 'react-native';
import { NativeModules } from 'react-native';
const { SnapscreenSDKModule } = NativeModules;

export default function App() {
  
  const testNativeModule = () => {
    SnapscreenSDKModule.testNativeModule();
  };

  const initializeSDK = () => {
    // These are trial client ID and secret - replace with your own configuration
    SnapscreenSDKModule.setupWithClientId("u9jYT9g1q6gTxY8i", "RMkiJPYCipP5bbG4YbtqzpdYne1b0hPSDItvq3YV");
  };

  const setCountryAndStateConfiguration = () => {
    SnapscreenSDKModule.setCountry("US")
    SnapscreenSDKModule.setUsState("NJ")
  };

  const presentSportMediaFlow = () => {
    SnapscreenSDKModule.presentSportMediaFlowWithConfiguration({ 
      "automaticSnap": false,
      "autosnapTimeoutDuration": 30,
      "autosnapIntervalInSeconds": 0.5,
      "navigationBackground": "#FFFFFF",
      "navigationForeground": "#2DD4BF"
    });
  };

  const presentOperatorFlow = () => {
    SnapscreenSDKModule.presentOperatorFlowWithConfiguration({ 
      "automaticSnap": false,
      "autosnapTimeoutDuration": 30,
      "autosnapIntervalInSeconds": 0.5,
      "navigationBackground-light": "#FFFFFF",
      "navigationBackground-dark": "#2DD4BF",
      "navigationForeground-light": "#2DD4BF",
      "navigationForeground-dark": "#000000"
    }, (snapResult) => {
      console.log(`Snapped sport event ID ${snapResult.externalId}`);
    });
  };

  const setSnapUIConfiguration = () => {
    SnapscreenSDKModule.updateSnapUIConfiguration({ 
      "snapHintText": "My Custom Snap Hint", 
      "snapProgressText": "Custom Progress",
      "snapErrorGeneralText": "Custom Error",
      "snapErrorConnectionIssueText": "Custom Connection Error",
      "snapErrorNoResultsText": "Custom No Results",
      "hidePoweredBySnapOddsBranding": true
    });
  };

  const setOddsUIConfiguration = () => {
    SnapscreenSDKModule.updateOddsUIConfiguration({ 
      "dismissButtonText": "Dismiss",
      "title": "Custom Odds Title", 
      "loadingText": "Custom Loading",
      "errorText": "Custom Error",
      "tryAgainText": "Custom Try Again",
      "moneyTitle": "M",
      "spreadTitle": "S",
      "totalTitle": "T",
      "bestOddsTitle": "BEST",
      "hidePoweredBySnapOddsBranding": true 
    });
  };

  const updateColorConfiguration = () => {
    SnapscreenSDKModule.updateColorConfiguration({
      "textPrimary": "#000000",
      "textAccent": "#000000",
      "backgroundWhite": "#FFFFFF",
      
      "background-light": "#E5E5E5",
      "background-dark": "#4B4B4B",

      "backgroundMuted": "#F2f2F2",
      "border": "#E5E5E5",
      "backgroundAccent": "#2DD4BF",
      "backgroundAccentShade": "#D5F6F2",
      "error": "#EA436E",
      "errorShade": "#FBD9E2"
    });
  }

  return (
    <View style={styles.container}>
      <StatusBar style="auto" />
      <Button title="Test native module integration" onPress={testNativeModule} />
      
      <Text/>

      <Button title="Initialize SnapOdds SDK" onPress={initializeSDK} />

      <Text/>
      
      <Button title="Set SDK configuration" onPress={setCountryAndStateConfiguration} />

      <Text/>

      <Button title="Present Sport Media flow" onPress={presentSportMediaFlow} />

      <Text/>
      
      <Button title="Present Operator flow" onPress={presentOperatorFlow} />

      <Text/>
      
      <Button title="Modify Snap UI Configuration" onPress={setSnapUIConfiguration} />

      <Text/>
      
      <Button title="Modify Odds UI Configuration" onPress={setOddsUIConfiguration} />

      <Text/>
      
      <Button title="Modify Color Configuration" onPress={updateColorConfiguration} />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  }
});
