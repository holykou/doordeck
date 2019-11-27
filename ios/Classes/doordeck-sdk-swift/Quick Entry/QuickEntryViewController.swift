//
//  QuickEntryViewController.swift
//  Doordeck
//
//  Copyright © 2018 Doordeck. All rights reserved.
//

import UIKit

class QuickEntryViewController: UIViewController {
    var lockMan: LockManager!
    var apiClient: APIClient!
    var certificateChain: CertificateChainClass!
    var delegate: DoordeckProtocol?
    var controlDelegate: DoordeckControl?
    var readerType: Doordeck.ReaderType = Doordeck.ReaderType.automatic
    var sodium: SodiumHelper!
    
    fileprivate let quickStoryboard = "QuickEntryStoryboard"
    fileprivate let bottomNFCView = "bottomViewNFC"
    fileprivate let bottomQRView = "bottomViewQR"
    fileprivate let VerificationScreen = "VerificationScreen"
    fileprivate let lockUnlockStoryboard =  "LockUnlockScreen"
    fileprivate let lockUnlockIdentifier = "LockUnlock"
    
    init(_ apiClient: APIClient,
         chain: CertificateChainClass,
         sodiumTemp: SodiumHelper) {
        
        self.sodium = sodiumTemp
        self.apiClient = apiClient
        self.certificateChain = chain
        self.lockMan = LockManager(self.apiClient)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpQuickEntry()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .doordeckPrimaryColour()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UserDefaults().getDarkUI() ? .lightContent : .default
    }
}

extension QuickEntryViewController: quickEntryDelegate {
    func showQRCode() {
        
    }
    
    func checkQuickEntryChoice() {
        setUpQuickEntry()
    }
    
    fileprivate func setUpQuickEntry() {
        if UIDevice.supportNFC() == true {
            
            if view.subviews.count > 0 {
                for view in view.subviews {
                    view.removeFromSuperview()
                }
            }
            if readerType == Doordeck.ReaderType.qr {
                addQRVC()
            } else {
                addNFCVC()
            }
        } else {
            addQRVC()
        }
    }

    fileprivate func addNFCVC () {
        if #available(iOS 11, *) {
            let podBundle = Bundle(for: Doordeck.self)
            if let bundleURL = podBundle.url(forResource: "Doordeck", withExtension: "bundle") {
                if let bundle = Bundle(url: bundleURL) {
            let storyboard: UIStoryboard = UIStoryboard(name: quickStoryboard, bundle:bundle )
            let bottomViewVC = storyboard.instantiateViewController(withIdentifier: bottomNFCView) as! BottomViewController
            bottomViewVC.view.frame = self.view.frame
            bottomViewVC.view.layoutIfNeeded()
            bottomViewVC.delegate = self
            bottomViewVC.controlDelegate = self.controlDelegate
            addChild(bottomViewVC)
            self.view.addSubview(bottomViewVC.view)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { [weak self] () -> Void in
                self?.view.layoutIfNeeded()
                }, completion: nil)
                }
            }
            
        } else {
            addQRVC()
        }
    }
    
    fileprivate func addQRVC () {
        let podBundle = Bundle(for: Doordeck.self)
        if let bundleURL = podBundle.url(forResource: "Doordeck", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                let storyboard: UIStoryboard = UIStoryboard(name: quickStoryboard, bundle:bundle )
                let bottomViewVC = storyboard.instantiateViewController(withIdentifier: bottomQRView) as! BottomViewControllerQR
                bottomViewVC.view.frame = self.view.frame
                bottomViewVC.view.layoutIfNeeded()
                bottomViewVC.delegate = self
                bottomViewVC.controlDelegate = self.controlDelegate
                addChild(bottomViewVC)
                self.view.addSubview(bottomViewVC.view)
                
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { [weak self]  () -> Void in
                    self?.view.layoutIfNeeded()
                    }, completion: nil)
            }
        }
    }
    
    func lockDetected(_ UUID: String) {
        showLockVerificationScreen(UUID, autoUnlock: true)
    }
    
    
    func showLockVerificationScreen(_ UUID: String, autoUnlock:Bool = false) {
        lockMan.findLock(UUID, success: { [weak self] (lock) in
            SDKEvent().event(.RESOLVE_TILE_SUCCESS)
            self?.showLockScreen(lock)
        }) { [weak self] in
            SDKEvent().event(.RESOLVE_TILE_FAILED)
            self?.showLockScreenFail()
            return
        }
    }
    
    func showLockScreen(_ lockTemp: LockDevice)  {
        let podBundle = Bundle(for: Doordeck.self)
        if let bundleURL = podBundle.url(forResource: "Doordeck", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
        if let vc = UIStoryboard(name: lockUnlockStoryboard, bundle: bundle).instantiateViewController(withIdentifier: lockUnlockIdentifier) as? LockUnlockViewController {
            vc.certificateChain = self.certificateChain
            vc.sodium = self.sodium
            vc.lockVariable = lockUnlockScreen(origin: .internalApp, lock: lockTemp)
            present(vc, animated: true, completion: nil)
        }
            }
        }
        
    }
    
    func showLockScreenFail()  {
        let podBundle = Bundle(for: Doordeck.self)
        if let bundleURL = podBundle.url(forResource: "Doordeck", withExtension: "bundle") {
        if let bundle = Bundle(url: bundleURL) {
        if let vc = UIStoryboard(name: lockUnlockStoryboard, bundle: bundle).instantiateViewController(withIdentifier: lockUnlockIdentifier) as? LockUnlockViewController {
            vc.certificateChain = self.certificateChain
            vc.sodium = self.sodium
            present(vc, animated: true, completion: nil)
        }
            }
        }
    }
    
    
}
