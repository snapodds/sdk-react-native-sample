//
//  SnapscreenSDKModule.swift
//  snapoddssample
//
//  Created by Martin Fitzka-Reichart on 17.06.22.
//

import Foundation
import SnapscreenFramework
import UIKit

@objc(SnapscreenSDKModule)
class SnapscreenSDKModule: NSObject {
  
  @objc(setupWithClientId:secret:)
  func setupWithClient(_ clientId: String, secret: String) {
    Snapscreen.setup(withClientId: clientId, clientSecret: secret, environment: .production)
  }
  
  @objc(setupForTestEnvironmentWithClientId:secret:)
  func setupForTestEnvironmentWithClientId(_ clientId: String, secret: String) {
    Snapscreen.setup(withClientId: clientId, clientSecret: secret, environment: .test)
  }
  
  @objc(setCountry:)
  func setCountry(_ country: String) {
    Snapscreen.instance?.country = country
  }
  
  @objc(setUsState:)
  func setUsState(_ usState: String) {
    Snapscreen.instance?.usState = usState
  }
  
  @objc(testNativeModule)
  func testNativeModule() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      let alert = UIAlertController(title: "Welcome to SnapOdds", message: "The Native SDK Module integration is working", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
  }
    
  @objc(presentSportMediaFlowWithConfiguration:)
  func presentSportMediaFlow(_ parameters: NSDictionary?) {
    DispatchQueue.main.async {
      let configuration = SnapConfiguration()
      
      if let automaticSnap = parameters?.object(forKey: "automaticSnap") as? Bool {
        configuration.automaticSnap = automaticSnap
      }
      if let autosnapTimeoutDuration = parameters?.object(forKey: "autosnapTimeoutDuration") as? NSNumber {
        configuration.autosnapTimeoutDuration = autosnapTimeoutDuration.doubleValue
      }
      if let autosnapIntervalInSeconds = parameters?.object(forKey: "autosnapIntervalInSeconds") as? NSNumber {
        configuration.autosnapIntervalInSeconds = autosnapIntervalInSeconds.doubleValue
      }
      
      let viewController = SnapViewController.forSportsMedia(configuration: configuration)
      viewController.navigationItem.backButtonTitle = ""
      viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelSnap))
      let customNavigationController = UINavigationController(rootViewController: viewController)
      
      var navigationBackgroundColor = UIColor.compatibleColorWith(light: UIColor.white, dark: UIColor.black)
      var navigationForegroundColor = UIColor.compatibleColorWith(light: UIColor.black, dark: UIColor.white)
      if let customNavigationBackgroundColor = UIColor.customColorWithName("navigationBackground", fromParameters: parameters) {
        navigationBackgroundColor = customNavigationBackgroundColor
      }
      if let customNavigationForegroundColor = UIColor.customColorWithName("navigationForeground", fromParameters: parameters) {
        navigationForegroundColor = customNavigationForegroundColor
      }
      
      customNavigationController.navigationBar.isTranslucent = false
      customNavigationController.navigationBar.barStyle = .default
      customNavigationController.navigationBar.barTintColor = navigationBackgroundColor
      customNavigationController.navigationBar.tintColor = navigationForegroundColor
      
      if #available(iOS 13.0, *) {
        let barAppearance = UINavigationBarAppearance()
        
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundImage = UIImage()
        barAppearance.backgroundColor = navigationBackgroundColor
        barAppearance.titleTextAttributes[.foregroundColor] = navigationForegroundColor
        barAppearance.buttonAppearance.normal.titleTextAttributes[.foregroundColor] = navigationForegroundColor
        
        customNavigationController.navigationBar.compactAppearance = barAppearance
        customNavigationController.navigationBar.standardAppearance = barAppearance
        customNavigationController.navigationBar.scrollEdgeAppearance = barAppearance
        if #available(iOS 15.0, *) {
          customNavigationController.navigationBar.compactScrollEdgeAppearance = barAppearance
        }
      }
      
      UIApplication.shared.keyWindow?.rootViewController?.present(customNavigationController, animated: true)
      self.presentedSnapViewController = viewController
    }
  }
  
  private var latestCallback: RCTResponseSenderBlock? = nil
  private weak var presentedSnapViewController: UIViewController? = nil
  
  @objc(presentOperatorFlowWithConfiguration:callback:)
  func presentOperatorFlow(_ parameters: NSDictionary?, callback: @escaping RCTResponseSenderBlock) {
    latestCallback = callback
    DispatchQueue.main.async {
      let configuration = SnapConfiguration()
      
      if let automaticSnap = parameters?.object(forKey: "automaticSnap") as? Bool {
        configuration.automaticSnap = automaticSnap
      }
      if let autosnapTimeoutDuration = parameters?.object(forKey: "autosnapTimeoutDuration") as? NSNumber {
        configuration.autosnapTimeoutDuration = autosnapTimeoutDuration.doubleValue
      }
      if let autosnapIntervalInSeconds = parameters?.object(forKey: "autosnapIntervalInSeconds") as? NSNumber {
        configuration.autosnapIntervalInSeconds = autosnapIntervalInSeconds.doubleValue
      }
      
      let viewController = SnapViewController.forSportsOperator(configuration: configuration, snapDelegate: self)
      viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelSnap))
      viewController.navigationItem.backButtonTitle = ""
      
      let customNavigationController = UINavigationController(rootViewController: viewController)
      
      var navigationBackgroundColor = UIColor.compatibleColorWith(light: UIColor.white, dark: UIColor.black)
      var navigationForegroundColor = UIColor.compatibleColorWith(light: UIColor.black, dark: UIColor.white)
      if let customNavigationBackgroundColor = UIColor.customColorWithName("navigationBackground", fromParameters: parameters) {
        navigationBackgroundColor = customNavigationBackgroundColor
      }
      if let customNavigationForegroundColor = UIColor.customColorWithName("navigationForeground", fromParameters: parameters) {
        navigationForegroundColor = customNavigationForegroundColor
      }
      
      customNavigationController.navigationBar.isTranslucent = false
      customNavigationController.navigationBar.barStyle = .default
      customNavigationController.navigationBar.barTintColor = navigationBackgroundColor
      customNavigationController.navigationBar.tintColor = navigationForegroundColor
      
      if #available(iOS 13.0, *) {
        let barAppearance = UINavigationBarAppearance()
        
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundImage = UIImage()
        barAppearance.backgroundColor = navigationBackgroundColor
        barAppearance.titleTextAttributes[.foregroundColor] = navigationForegroundColor
        barAppearance.buttonAppearance.normal.titleTextAttributes[.foregroundColor] = navigationForegroundColor
        
        customNavigationController.navigationBar.compactAppearance = barAppearance
        customNavigationController.navigationBar.standardAppearance = barAppearance
        customNavigationController.navigationBar.scrollEdgeAppearance = barAppearance
        if #available(iOS 15.0, *) {
          customNavigationController.navigationBar.compactScrollEdgeAppearance = barAppearance
        }
      }
      
      UIApplication.shared.keyWindow?.rootViewController?.present(customNavigationController, animated: true)
      self.presentedSnapViewController = viewController
    }
  }
  
  @objc private func cancelSnap() {
    latestCallback = nil
    presentedSnapViewController?.dismiss(animated:  true)
    presentedSnapViewController = nil
  }
  
  @objc(updateSnapUIConfiguration:)
  func updateSnapUIConfiguration(_ parameters: NSDictionary) {
    DispatchQueue.main.async {
      if let hideDefaultViewFinderAndQuadrangleDetection = parameters.object(forKey: "hideDefaultViewFinderAndQuadrangleDetection") as? Bool {
        Snapscreen.instance?.snapUIConfiguration.hideDefaultViewFinderAndQuadrangleDetection = hideDefaultViewFinderAndQuadrangleDetection
      }
      if let snapHintText = parameters.object(forKey: "snapHintText") as? String {
        Snapscreen.instance?.snapUIConfiguration.snapHintText = snapHintText
      }
      if let snapProgressText = parameters.object(forKey: "snapProgressText") as? String {
        Snapscreen.instance?.snapUIConfiguration.snapProgressText = snapProgressText
      }
      if let snapErrorGeneralText = parameters.object(forKey: "snapErrorGeneralText") as? String {
        Snapscreen.instance?.snapUIConfiguration.snapErrorGeneralText = snapErrorGeneralText
      }
      if let snapErrorConnectionIssueText = parameters.object(forKey: "snapErrorConnectionIssueText") as? String {
        Snapscreen.instance?.snapUIConfiguration.snapErrorConnectionIssueText = snapErrorConnectionIssueText
      }
      if let snapErrorNoResultsText = parameters.object(forKey: "snapErrorNoResultsText") as? String {
        Snapscreen.instance?.snapUIConfiguration.snapErrorNoResultsText = snapErrorNoResultsText
      }
      if let hidePoweredBySnapOddsBranding = parameters.object(forKey: "hidePoweredBySnapOddsBranding") as? Bool {
        Snapscreen.instance?.snapUIConfiguration.hidePoweredBySnapOddsBranding = hidePoweredBySnapOddsBranding
      }
    }
  }
  
  @objc(updateOddsUIConfiguration:)
  func updateOddsUIConfiguration(_ parameters: NSDictionary) {
    DispatchQueue.main.async {
      if let dismissButtonText = parameters.object(forKey: "dismissButtonText") as? String {
        Snapscreen.instance?.oddsUIConfiguration.dismissButtonText = dismissButtonText
      }
      if let title = parameters.object(forKey: "title") as? String {
        Snapscreen.instance?.oddsUIConfiguration.title = title
      }
      if let loadingText = parameters.object(forKey: "loadingText") as? String {
        Snapscreen.instance?.oddsUIConfiguration.loadingText = loadingText
      }
      if let errorText = parameters.object(forKey: "errorText") as? String {
        Snapscreen.instance?.oddsUIConfiguration.errorText = errorText
      }
      if let tryAgainText = parameters.object(forKey: "tryAgainText") as? String {
        Snapscreen.instance?.oddsUIConfiguration.tryAgainText = tryAgainText
      }
      if let moneyTitle = parameters.object(forKey: "moneyTitle") as? String {
        Snapscreen.instance?.oddsUIConfiguration.moneyTitle = moneyTitle
      }
      if let spreadTitle = parameters.object(forKey: "spreadTitle") as? String {
        Snapscreen.instance?.oddsUIConfiguration.spreadTitle = spreadTitle
      }
      if let totalTitle = parameters.object(forKey: "totalTitle") as? String {
        Snapscreen.instance?.oddsUIConfiguration.totalTitle = totalTitle
      }
      if let bestOddsTitle = parameters.object(forKey: "bestOddsTitle") as? String {
        Snapscreen.instance?.oddsUIConfiguration.bestOddsTitle = bestOddsTitle
      }
      if let hidePoweredBySnapOddsBranding = parameters.object(forKey: "hidePoweredBySnapOddsBranding") as? Bool {
        Snapscreen.instance?.oddsUIConfiguration.hidePoweredBySnapOddsBranding = hidePoweredBySnapOddsBranding
      }
    }
  }
  
  @objc(updateColorConfiguration:)
  func updateColorConfiguration(_ parameters: NSDictionary) {
    DispatchQueue.main.async {
      if let textPrimary = UIColor.customColorWithName("textPrimary", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.textPrimary = textPrimary
      }
      if let textAccent = UIColor.customColorWithName("textAccent", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.textAccent = textAccent
      }
      if let backgroundWhite = UIColor.customColorWithName("backgroundWhite", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.backgroundWhite = backgroundWhite
      }
      if let background = UIColor.customColorWithName("background", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.background = background
      }
      if let backgroundMuted = UIColor.customColorWithName("backgroundMuted", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.backgroundMuted = backgroundMuted
      }
      if let border = UIColor.customColorWithName("border", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.border = border
      }
      if let backgroundAccent = UIColor.customColorWithName("backgroundAccent", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.backgroundAccent = backgroundAccent
      }
      if let backgroundAccentShade = UIColor.customColorWithName("backgroundAccentShade", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.backgroundAccentShade = backgroundAccentShade
      }
      if let error = UIColor.customColorWithName("error", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.error = error
      }
      if let errorShade = UIColor.customColorWithName("errorShade", fromParameters: parameters) {
        Snapscreen.instance?.colorConfiguration.errorShade = errorShade
      }
    }
  }
}

extension UIColor {
  class func customColorWithName(_ name: String, fromParameters parameters: NSDictionary?) -> UIColor? {
    guard let parameters = parameters else {
      return nil
    }

    if let colorLightString = parameters.object(forKey: "\(name)-light") as? String,
        let colorDarkString = parameters.object(forKey: "\(name)-dark") as? String,
       let colorLight = UIColor(hexString: colorLightString),
       let colorDark = UIColor(hexString: colorDarkString) {
      return UIColor.compatibleColorWith(light: colorLight, dark: colorDark)
    } else if let colorString = parameters.object(forKey: name) as? String,
              let color = UIColor(hexString: colorString) {
      return color
    }
    return nil
  }
  
  class func compatibleColorWith(light: UIColor, dark: UIColor) -> UIColor {
      if #available(iOS 13.0, *) {
          return UIColor(dynamicProvider: { traitCollection in
              return traitCollection.userInterfaceStyle == .light ? light : dark
          })
      } else {
          return light
      }
  }
}

private extension Int64 {
    func duplicate4bits() -> Int64 {
        return (self << 4) + self
    }
}

private extension UIColor {
  private convenience init?(hex3: Int64, alpha: Float) {
      self.init(red:   CGFloat( ((hex3 & 0xF00) >> 8).duplicate4bits() ) / 255.0,
                green: CGFloat( ((hex3 & 0x0F0) >> 4).duplicate4bits() ) / 255.0,
                blue:  CGFloat( ((hex3 & 0x00F) >> 0).duplicate4bits() ) / 255.0,
                alpha: CGFloat(alpha))
  }

  private convenience init?(hex4: Int64, alpha: Float?) {
      self.init(red:   CGFloat( ((hex4 & 0xF000) >> 12).duplicate4bits() ) / 255.0,
                green: CGFloat( ((hex4 & 0x0F00) >> 8).duplicate4bits() ) / 255.0,
                blue:  CGFloat( ((hex4 & 0x00F0) >> 4).duplicate4bits() ) / 255.0,
                alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat( ((hex4 & 0x000F) >> 0).duplicate4bits() ) / 255.0)
  }

  private convenience init?(hex6: Int64, alpha: Float) {
      self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
                green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
                blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
  }

  private convenience init?(hex8: Int64, alpha: Float?) {
      self.init(red:   CGFloat( (hex8 & 0xFF000000) >> 24 ) / 255.0,
                green: CGFloat( (hex8 & 0x00FF0000) >> 16 ) / 255.0,
                blue:  CGFloat( (hex8 & 0x0000FF00) >> 8 ) / 255.0,
                alpha: alpha.map(CGFloat.init(_:)) ?? CGFloat( (hex8 & 0x000000FF) >> 0 ) / 255.0)
  }
  
  convenience init?(hexString: String, alpha: Float? = nil) {
      var hex = hexString

      // Check for hash and remove the hash
      if hex.hasPrefix("#") {
          hex = String(hex[hex.index(after: hex.startIndex)...])
      }

      guard let hexVal = Int64(hex, radix: 16) else {
          self.init()
          return nil
      }

      switch hex.count {
      case 3:
          self.init(hex3: hexVal, alpha: alpha ?? 1.0)
      case 4:
          self.init(hex4: hexVal, alpha: alpha)
      case 6:
          self.init(hex6: hexVal, alpha: alpha ?? 1.0)
      case 8:
          self.init(hex8: hexVal, alpha: alpha)
      default:
          // Note:
          // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
          // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
          // in future releases, not a feature. -- Apple Forum
          self.init()
          return nil
      }
  }
}

extension SnapscreenSDKModule: SnapscreenSnapDelegate {
  
  func snapscreenSnapViewController(_ viewController: SnapViewController, didSnapSportEvent sportEvent: SportEventSnapResultEntry) {
    if let jsonData = try? JSONEncoder().encode(sportEvent), let jsonString = String(data: jsonData, encoding: .utf8), let sportEventId = sportEvent.sportEvent?.externalId {
      latestCallback?([["externalId" : sportEventId, "snapResultEntry": jsonString]])
    }
    
    viewController.dismiss(animated: true)
    presentedSnapViewController = nil
    latestCallback = nil
  }
}
