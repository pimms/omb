//
//  AdState.swift
//  Ballout
//
//  Created by Joakim Stien on 18/07/2017.
//  Copyright © 2017 Joakim Stien. All rights reserved.
//

import Foundation
import GameplayKit
import GoogleMobileAds

class AdState: GameState, GADInterstitialDelegate {
    private let adMobAppId = "ca-app-pub-2426541477953992~7218783869"
    private let adMobUnitId = "ca-app-pub-2426541477953992/8695517065"
    
    private var interstitial: GADInterstitial?

    
    required init(scene s: BalloutScene) {
        super.init(scene: s)
        
        loadAd()
    }
    
    override func didEnter(from previousState: GKState?) {
        if !showAd() {
            print(" --> Unable to show ad!")
            self.stateMachine?.enter(SpawnState.self)
        }
    }
    
    override func willExit(to nextState: GKState) {
        loadAd()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == SpawnState.self
    }
    
    
    private func loadAd() {
        print(" --> Loading ad!")
        self.interstitial = GADInterstitial(adUnitID: self.adMobUnitId)
        self.interstitial?.delegate = self
        let request = GADRequest()
        self.interstitial?.load(request)
    }
    
    private func showAd() -> Bool {
        if (self.interstitial?.isReady)! {
            // Good practices to hell, I just want this out the door
            self.interstitial?.present(fromRootViewController: GameViewController.activeInstance!)
            return true
        }
        return false
    }
    
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print(" !! interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        self.stateMachine?.enter(SpawnState.self)
    }
    
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
    }
}
