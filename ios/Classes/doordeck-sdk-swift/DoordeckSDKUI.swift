//
//  DoordeckSDKUIViewController.swift
//  doordeck-sdk-swift-sample
//
//  Created by Marwan on 03/07/2019.
//  Copyright © 2019 Doordeck. All rights reserved.
//

import UIKit

class DoordeckSDKUI: DoordeckUI {

    func openVerificationStoryboard(_ delegate: DoordeckInternalProtocol,
                                    sdkMode: Bool,
                                    controlDelegate: DoordeckControl?,
                                    apiClient:APIClient,
                                    sodiumHelper: SodiumHelper )  {
        
        guard let view : UIViewController = UIApplication.topViewController() else { return }
        
        if let vc = getVerificationScreen(delegate,
                                       controlDelegate: controlDelegate,
                                       apiClient: apiClient,
                                       sodiumHelper: sodiumHelper)
        {
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.isNavigationBarHidden = true
            if sdkMode == false {
                view.addChild(navigationController)
            } else {
                view.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    func getVerificationScreen(_ delegate: DoordeckInternalProtocol,
                               controlDelegate: DoordeckControl?,
                               apiClient:APIClient,
                               sodiumHelper: SodiumHelper ) -> VerificationViewController? {
        let podBundle = Bundle(for: Doordeck.self)
        if let bundleURL = podBundle.url(forResource: "Doordeck", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storyboard  = UIStoryboard(name: "VerificationStoryboard", bundle: bundle)
                let vc : VerificationViewController = storyboard.instantiateViewController(withIdentifier: "VerificationNoNavigation") as! VerificationViewController
                vc.delegate = delegate
                vc.controlDelegate = controlDelegate
                vc.apiClient = apiClient
                vc.sodium = sodiumHelper
                return vc
            }
        }
        return nil
    }
    
    func showUnlockScreenSuccess (_ lockManager: LockManager,
                                    readerType: Doordeck.ReaderType,
                                    delegate: DoordeckProtocol?,
                                    controlDelegate: DoordeckControl?,
                                    apiClient: APIClient,
                                    chain: CertificateChainClass,
                                    sodium: SodiumHelper) {
        
        guard let view : UIViewController = UIApplication.topViewController() else { return }
        
        if let quickEntryView = getQuickEntryVC(lockManager,
                                             readerType: readerType,
                                             delegate: delegate,
                                             controlDelegate: controlDelegate,
                                             apiClient: apiClient,
                                             chain: chain,
                                             sodium: sodium)
        {
        let navigationController = UINavigationController(rootViewController: quickEntryView)
        navigationController.isNavigationBarHidden = true
        view.present(navigationController, animated: true, completion: nil)
        }
    }
    
    func getQuickEntryVC(_ lockManager: LockManager,
                         readerType: Doordeck.ReaderType,
                         delegate: DoordeckProtocol?,
                         controlDelegate: DoordeckControl?,
                         apiClient: APIClient,
                         chain: CertificateChainClass,
                         sodium: SodiumHelper) -> QuickEntryViewController? {
        let podBundle = Bundle(for: Doordeck.self)
        if let bundleURL = podBundle.url(forResource: "Doordeck", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
        let storyboard : UIStoryboard = UIStoryboard(name: "QuickEntryStoryboard", bundle: bundle)
        let vc : QuickEntryViewController = storyboard.instantiateViewController(withIdentifier: "QuickEntryNoNavigation") as! QuickEntryViewController
        vc.lockMan = lockManager
        vc.readerType = readerType
        vc.delegate = delegate
        vc.controlDelegate = controlDelegate
        vc.apiClient = apiClient
        vc.certificateChain = chain
        vc.sodium = sodium
        
        return vc
            }}
        return nil
    }
}
