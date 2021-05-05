//
//  FirstViewController.swift
//  capio
//
//  Created by Roman on 7/10/16.
//  Copyright © 2016 theroman. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import CoreMotion

import JQSwiftIcon

import Photos

import ScalePicker
import CariocaMenu

enum SettingMenuTypes {
    case none, cameraSliderMenu, resolutionMenu, flashMenu, allStatsMenu, miscMenu
}

class Singleton {

    //MARK: Shared Instance

    static let sharedInstance : Singleton = {
        let instance = Singleton()
        return instance
    }()

    //MARK: Local Variable

    var emptyStringArray : [String]? = nil

    //MARK: Init

    convenience init() {
        self.init(array : [])
    }

    //MARK: Init Array

    init( array : [String]) {
        emptyStringArray = array
    }
}

class FirstViewController:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIGestureRecognizerDelegate,
    CariocaMenuDelegate, CAAnimationDelegate {

    let VIDEO_RECORD_INTERVAL_COUNTDOWN:        Double = 1

    @IBOutlet var myCamView:                    UIView!
    @IBOutlet var doPhotoBtn:                   UIButton!
    @IBOutlet var doVideoBtn:                   UIButton!
    @IBOutlet var actionToolbar:                UIToolbar!
    @IBOutlet var menuHostView:                 MenuHostView!
    @IBOutlet var FPSLabel:                     UILabel!
    @IBOutlet var videoCounterLabel:            UILabel!
    @IBOutlet var videoRecordIndicator:         UIImageView!
    @IBOutlet var resolutionHostBlurView:       SharedBlurView!
    @IBOutlet var enablePermsView:              SharedBlurView!
    @IBOutlet var gridHostView:                 UIView!

    var captureSessionManager:                  CaptureSessionManager! = CaptureSessionManager.sharedInstance

    var logging:                                Bool = true

    private var videoRecordCountdownSeconds:    Double = 0.0
    private var videRecordCountdownTimer:       Timer!

    private var optionsMenu:                    CariocaMenu?
    private var cariocaMenuViewController:      CameraMenuContentController?

    //menu controllers here
    private var cameraOptionsViewController:    CameraOptionsViewController?
    private var cameraSecondaryOptions:         RightMenuSetViewController?
    private var cameraResolutionSideMenu:       ResolutionSideMenuViewController?
    private var cameraResolutionMenu:           ResolutionViewController?

    private var focusZoomView:                  FocusZoomViewController?

    private var gridManager:                    GridManager!

    //flag that determines if a user gave all required perms: photo library, video, microphone
    private var isAppUsable:                    Bool = false
    private var isPhotoOnly:                    Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        addCoreObservers()
        processUi()
        self.actionToolbar.isHidden = false
        // logo mask
        self.view.layer.mask = CALayer()
        self.view.layer.mask?.contents = UIImage(named: "cio_inapp_ico_new")!.cgImage
        self.view.layer.mask?.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.view.layer.mask?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view.layer.mask?.position = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2)

        // logo mask background view
        let maskBgView = UIView(frame: self.view.frame)
        maskBgView.backgroundColor = UIColor.white
        self.view.addSubview(maskBgView)
        self.view.bringSubviewToFront(maskBgView)

        // logo mask animation
        let transformAnimation = CAKeyframeAnimation(keyPath: "bounds")
        transformAnimation.delegate = self
        transformAnimation.duration = 1
        transformAnimation.beginTime = CACurrentMediaTime() + 1 //add delay of 1 second
        let initalBounds = NSValue(cgRect: (self.view.layer.mask?.bounds)!)
        let secondBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 40, height: 40))
        let thirdBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 50, height: 50))
        let finalBounds = NSValue(cgRect: CGRect(x: 0, y: 0, width: 5000, height: 5000))
        transformAnimation.values = [initalBounds, secondBounds, thirdBounds, finalBounds]
        transformAnimation.keyTimes = [0, 0.3, 0.6, 1]
        transformAnimation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut), CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)]
        transformAnimation.isRemovedOnCompletion = false
        transformAnimation.fillMode = CAMediaTimingFillMode.forwards
        self.view.layer.mask?.add(transformAnimation, forKey: "maskAnimation")

        // logo mask background view animation
        UIView.animate(withDuration: 0.1,
                       delay: 1.35,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                        maskBgView.alpha = 0.0
                       },
                       completion: { finished in
                        maskBgView.removeFromSuperview()
                       })

        // root view animation
        UIView.animate(withDuration: 0.25,
                       delay: 1.3,
                       options: [],
                       animations: {
                        self.view.transform = CGAffineTransform(scaleX: 1.0005, y: 1.0005)
                       },
                       completion: { finished in
                        UIView.animate(withDuration: 0.3,
                                       delay: 0.0,
                                       options: UIView.AnimationOptions.curveEaseInOut,
                                       animations: {
                                        self.view.transform = .identity
                                       },
                                       completion: { finished in self.view.layer.mask = nil})
        })
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToUpload(_:)), name: Notification.Name("photoCaptured"), object: nil)
    }
    
    
    
    @objc func goToUpload(_  sender: Notification){
        
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: UploadPhotoVC.identifier) as? UploadPhotoVC {
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        print("[didReceiveMemoryWarning] memory warning happened.")
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if (optionsMenu?.hostView == nil) {
            optionsMenu?.addInView(self.view)
        }

        gridManager = GridManager.init(gridView: gridHostView, storyBoard: self.storyboard!, parentViewDimensions: gridHostView.bounds)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }  

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }    

    /////////////////// Carioca Menu Overrides START

    func cariocaMenuDidSelect(_ menu:CariocaMenu, indexPath:IndexPath) {
        cariocaMenuViewController?.menuWillClose()

        hideActiveSetting() {_ in
            print("Done hiding from show")

            //todo -> switchcase for misc menu
            self.menuHostView.setActiveMenu(self.cameraOptionsViewController!, menuType: .cameraSliderMenu)

            self.menuHostView.setCameraSliderViewControllerForIndex(indexPath.row, callbackToOpenMenu: self.showActiveSetting)
            self.optionsMenu?.moveToTop()
        }
    }

    func cariocaMenuWillOpen(_ menu:CariocaMenu) {
        cariocaMenuViewController?.menuWillOpen()
        if logging {
            print("carioca MenuWillOpen \(menu)")
        }
    }

    func cariocaMenuDidOpen(_ menu:CariocaMenu){
        if logging {
            switch menu.openingEdge{
            case .left:
                print("carioca MenuDidOpen \(menu) left")
                break;
            default:
                print("carioca MenuDidOpen \(menu) right")
                break;
            }
        }
    }

    func cariocaMenuWillClose(_ menu:CariocaMenu) {
        cariocaMenuViewController?.menuWillClose()
        if logging {
            print("carioca MenuWillClose \(menu)")
        }
    }

    func cariocaMenuDidClose(_ menu:CariocaMenu){
        if logging {
            print("carioca MenuDidClose \(menu)")
        }
    }
    /////////////////// Carioca Menu Overrides END

    @IBAction func onDoPhotoTrigger(_ sender: AnyObject) {
        captureImage()
    }

    @IBAction func onDoVideo(_ sender: UIButton) {
        startStopRecording()
    }

    @objc func captureImage() {
        if isAppUsable {
            if cameraSecondaryOptions?.timerScale != TimerScales.off  {
                if (cameraSecondaryOptions?.timerState != TimerStates.ticking) {
                    doPhotoBtn.isEnabled = false
                    doPhotoBtn.alpha = 0.4
                    cameraSecondaryOptions?.startTimerTick {
                        self.doPhotoBtn.isEnabled = true
                        self.doPhotoBtn.alpha = 1
                        self.captureSessionManager.captureImage()
                    }
                }
            } else {
                doPhotoBtn.alpha = 1
                doPhotoBtn.isEnabled = true
                self.captureSessionManager.captureImage()
            }
        }
    }

    @objc func startStopRecording() {
        if isAppUsable && !isPhotoOnly {
            self.captureSessionManager.startStopRecording()
        }
    }

    @objc func applicationDidEnterBackground() {
        print("[applicationDidEnterBackground] start")
        onDispose()
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if isAppUsable {
            var point: CGPoint = gestureRecognizer.location(in: gestureRecognizer.view)

            if (gestureRecognizer.state == .began) {
                if(self.focusZoomView == nil) {
                    self.focusZoomView = self.storyboard?.instantiateViewController(withIdentifier: "FocusZoomView") as? FocusZoomViewController
                }

                self.focusZoomView?.resetView()

                gestureRecognizer.view?.addSubview((self.focusZoomView?.view)!)

                self.focusZoomView?.view.transform = CGAffineTransform.init(translationX: point.x - (focusZoomView?.view.bounds.width)!/2, y: point.y - (focusZoomView?.view.bounds.height)!/2)

                self.focusZoomView?.appear()
            }

            if (gestureRecognizer.state == .changed) {
                self.focusZoomView?.view.transform = CGAffineTransform.init(translationX: point.x - (focusZoomView?.view.bounds.width)!/2, y: point.y - (focusZoomView?.view.bounds.height)!/2)
            }

            if (gestureRecognizer.state == .ended) {
                let centerDelta: CGFloat = 100.0
                if (point.x <= (gestureRecognizer.view?.bounds.width)!/2 + centerDelta &&
                    point.x >= (gestureRecognizer.view?.bounds.width)!/2 - centerDelta &&
                    point.y <= (gestureRecognizer.view?.bounds.height)!/2 + centerDelta &&
                    point.y >= (gestureRecognizer.view?.bounds.height)!/2 - centerDelta ) {

                    point = CGPoint.init(x: (gestureRecognizer.view?.bounds.width)!/2, y: (gestureRecognizer.view?.bounds.height)!/2)

                    self.focusZoomView?.disolveToRemove()
                } else {
                    self.focusZoomView?.disolve()
                }

                self.focusZoomView?.view.transform = CGAffineTransform.init(translationX: point.x - (focusZoomView?.view.bounds.width)!/2, y: point.y - (focusZoomView?.view.bounds.height)!/2)

                self.captureSessionManager.setPointOfInterest(point)
            }
        }
    }

    @objc func handlerCamViewTap(_ gestureRecognizer: UIGestureRecognizer) {
        if isAppUsable {
            if (menuHostView != nil && menuHostView.activeMenuType != .none) {
                if (menuHostView.activeMenuType == .cameraSliderMenu) {
                    self.toggleCariocaIndicatorPin()
                }
                hideActiveSetting() {_ in
                    print("Done hiding from tap")
                }
            } else {
                if(self.focusZoomView == nil) {
                    self.focusZoomView = self.storyboard?.instantiateViewController(withIdentifier: "FocusZoomView") as? FocusZoomViewController
                }

                self.focusZoomView?.resetView()

                gestureRecognizer.view?.addSubview((self.focusZoomView?.view)!)
                var point: CGPoint = gestureRecognizer.location(in: gestureRecognizer.view)
                let centerDelta: CGFloat = 100.0
                if (point.x <= (gestureRecognizer.view?.bounds.width)!/2 + centerDelta &&
                    point.x >= (gestureRecognizer.view?.bounds.width)!/2 - centerDelta &&
                    point.y <= (gestureRecognizer.view?.bounds.height)!/2 + centerDelta &&
                    point.y >= (gestureRecognizer.view?.bounds.height)!/2 - centerDelta ) {

                    point = CGPoint.init(x: (gestureRecognizer.view?.bounds.width)!/2, y: (gestureRecognizer.view?.bounds.height)!/2)

                    self.focusZoomView?.disolveToRemove()
                } else {
                    self.focusZoomView?.disolve()
                }

                self.focusZoomView?.view.transform = CGAffineTransform.init(translationX: point.x - (focusZoomView?.view.bounds.width)!/2, y: point.y - (focusZoomView?.view.bounds.height)!/2)

                self.captureSessionManager.setPointOfInterest(point)
            }
        }
    }

    open func onShowResOptions() {
        if isAppUsable {
            if (menuHostView.activeMenuType != .resolutionMenu) {
                if (menuHostView.activeMenuType == .cameraSliderMenu) {
                    self.toggleCariocaIndicatorPin()
                }
                
                hideActiveSetting() { _ in
                    if(self.cameraResolutionMenu == nil) {
                        self.cameraResolutionMenu = self.storyboard?.instantiateViewController(withIdentifier: "CameraResolutionMenu") as? ResolutionViewController
                    }
                    
                    self.menuHostView.setActiveMenu(self.cameraResolutionMenu!, menuType: .resolutionMenu)
                    
                    self.showActiveSetting()
                }
            }
        }
    }
    
    private func getIsAppUsable(isVideoEnabled: Bool, isAudioEnabled: Bool, isPhotoLibraryEnabled: Bool) -> Bool {
        let isPhotoAndVideo = isVideoEnabled && isAudioEnabled && isPhotoLibraryEnabled
        isPhotoOnly = isVideoEnabled && !isAudioEnabled && isPhotoLibraryEnabled
        
        return isPhotoAndVideo || isPhotoOnly
    }

    @objc func requestPhotoVideoAudioPerms() {
        let videoAuthState      = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        let audioAuthState      = AVCaptureDevice.authorizationStatus(for: AVMediaType.audio)
        let libraryAuthState    = PHPhotoLibrary.authorizationStatus()
        var isVideoEnabled          = videoAuthState ==  AVAuthorizationStatus.authorized
        var isAudioEnabled          = audioAuthState ==  AVAuthorizationStatus.authorized
        var isPhotoLibraryEnabled   = libraryAuthState == PHAuthorizationStatus.authorized

        
        
        if  !isAudioEnabled {
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted :Bool) -> Void in
                isAudioEnabled = granted
                if !isVideoEnabled {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted :Bool) -> Void in
                        isVideoEnabled = granted

                        if (!isPhotoLibraryEnabled) {
                            PHPhotoLibrary.requestAuthorization({ (authorizationStatus: PHAuthorizationStatus) -> Void in
                                isPhotoLibraryEnabled = authorizationStatus == PHAuthorizationStatus.authorized
                                self.isAppUsable = self.getIsAppUsable(isVideoEnabled: isVideoEnabled, isAudioEnabled: isAudioEnabled, isPhotoLibraryEnabled: isPhotoLibraryEnabled)
                            })
                        }
                    });
                }
            });
        }

        isAppUsable = self.getIsAppUsable(isVideoEnabled: isVideoEnabled, isAudioEnabled: isAudioEnabled, isPhotoLibraryEnabled: isPhotoLibraryEnabled)
        if (isAppUsable) {
            self.captureSessionManager.resetCaptureSession(camView: myCamView, isPhotoOnly: isPhotoOnly)
            enableUi()
        } else {
            let areAnyStatesNotDetermined = videoAuthState == AVAuthorizationStatus.notDetermined ||
                audioAuthState == AVAuthorizationStatus.notDetermined ||
                libraryAuthState == PHAuthorizationStatus.notDetermined
            disableUi(areAnyStatesNotDetermined)
        }
    }

    func startStopVideoCounter(start: Bool) {
        if start {
            //video countdown counter starts here
            
            UIView.animate(withDuration: self.VIDEO_RECORD_INTERVAL_COUNTDOWN/2, delay: 0, options: .curveEaseOut, animations: {
                self.videoRecordIndicator.alpha = 0.5
                self.videoCounterLabel.alpha = 1.0
                self.videoCounterLabel.text = String(format: "%02d:%02d:%02d", 0.0, 0.0, 0.0)
            }) { success in

                if (self.videRecordCountdownTimer != nil) {
                    self.videRecordCountdownTimer.invalidate()
                }

                self.videRecordCountdownTimer = Timer.scheduledTimer(withTimeInterval: self.VIDEO_RECORD_INTERVAL_COUNTDOWN/2, repeats: true, block: {timer in
                    let videoRecordCountdownSeconds = (self.captureSessionManager.captureVideoOut?.recordedDuration.seconds)!

                    let seconds: Int = Int(videoRecordCountdownSeconds) % 60
                    let minutes: Int = Int((videoRecordCountdownSeconds / 60)) % 60
                    let hours: Int = Int(videoRecordCountdownSeconds) / 3600

                    DispatchQueue.main.async {
                        self.videoCounterLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                    }

                    UIView.animate(withDuration: self.VIDEO_RECORD_INTERVAL_COUNTDOWN/3, delay: 0, options: .curveEaseOut, animations: {
                        self.videoRecordIndicator.alpha = self.videoRecordIndicator.alpha == 0.5 ? 0.1 : 0.5
                    })
                })
            }
        } else {
                videRecordCountdownTimer.invalidate()
                videRecordCountdownTimer = nil

                UIView.animate(withDuration: self.VIDEO_RECORD_INTERVAL_COUNTDOWN/2, delay: 0, options: .curveEaseOut, animations: {
                    self.videoRecordIndicator.alpha = 0.0
                    self.videoRecordCountdownSeconds = 0.0
                    self.videoCounterLabel.alpha = 0.0

                }) { (success:Bool) in
                    DispatchQueue.main.async {
                    self.videoCounterLabel.text = String()
                }
            }
        }
    }

    private func onDispose(dealocateViews: Bool = true) {
        print("[onDispose] disposing")
        
        self.optionsMenu?.hideMenu()
        
        self.captureSessionManager.onSessionDispose()
        
        //cuz zoomView has a bounce timer
        //and order here MATTERS. MUST be before
        //the for loop bellow
        self.focusZoomView?.immediateReset()
        
        //must ALWAY go last. Release all other resources before
        //this for loop
        
        if dealocateViews, let layers = myCamView.layer.sublayers as [CALayer]? {
            for layer in layers  {
                layer.removeFromSuperlayer()
            }
        }
    }

    private func addCoreObservers() {

        requestPhotoVideoAudioPerms()
        
        //each time you spawn application back -> this observer gonna be triggered
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.requestPhotoVideoAudioPerms), name: UIApplication.didBecomeActiveNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)

        captureSessionManager.cameraSettingsObservable.subscribe(onNext: { (newCameraSettings: CameraSessionSettings) in
            let isFlashAvailable = newCameraSettings.isFlashAvailable

            if self.cameraSecondaryOptions != nil {
                if  isFlashAvailable &&
                    self.captureSessionManager.recodringState != RecordingStates.on {

                    self.cameraSecondaryOptions?.isFlashAvailable = true
                    self.captureSessionManager.flashModeState = (self.cameraSecondaryOptions?.flashModeState)!
                } else {
                    self.cameraSecondaryOptions?.isFlashAvailable = false
                    self.captureSessionManager.flashModeState = AVCaptureDevice.FlashMode.off
                }

//                let recordingState = newCameraSettings.recordingState
//                switch recordingState {
//                    case RecordingStates.on:
//                        self.doVideoBtn.titleLabel?.textColor = UIColor.red
//
//                        self.cameraSecondaryOptions?.isOrientationSwitchEnabled = false
//                        self.cameraSecondaryOptions?.isFlashAvailable = false
//                        self.captureSessionManager.flashModeState = AVCaptureDevice.FlashMode.off
//
//                        if (self.videRecordCountdownTimer == nil) {
//                            self.startStopVideoCounter(start: true)
//                        }
//
//                    case RecordingStates.off:
//                        self.doVideoBtn.titleLabel?.textColor = UIColor.white
//
//                        self.cameraSecondaryOptions?.isOrientationSwitchEnabled = true
//                        self.cameraSecondaryOptions?.isFlashAvailable = true
//                        self.captureSessionManager.flashModeState = (self.cameraSecondaryOptions?.flashModeState)!
//
//                        if (self.videRecordCountdownTimer != nil) {
//                            self.startStopVideoCounter(start: false)
//                        }
//                }
            }
        })
    }

    private func processUi() {
        //TODO: re-factor the method! it's too damn big
        
        let camViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.handlerCamViewTap))
        camViewTapRecognizer.numberOfTapsRequired = 1
        camViewTapRecognizer.numberOfTouchesRequired = 1

        let camViewDoubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.captureImage))
        camViewDoubleTapRecognizer.numberOfTapsRequired = 2
        camViewDoubleTapRecognizer.numberOfTouchesRequired = 1

//        let camViewTrippleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.startStopRecording))

//        camViewTrippleTapRecognizer.numberOfTapsRequired = 3
//        camViewTrippleTapRecognizer.numberOfTouchesRequired = 1

        let camViewLongTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(FirstViewController.handleLongPress))

        myCamView.addGestureRecognizer(camViewTapRecognizer)
        myCamView.addGestureRecognizer(camViewDoubleTapRecognizer)
//        myCamView.addGestureRecognizer(camViewTrippleTapRecognizer)
        myCamView.addGestureRecognizer(camViewLongTapRecognizer)

        //setting gesture priorities
        camViewTapRecognizer.require(toFail: camViewDoubleTapRecognizer)
//        camViewTapRecognizer.require(toFail: camViewTrippleTapRecognizer)
//        camViewDoubleTapRecognizer.require(toFail: camViewTrippleTapRecognizer)

        //todo: all settings processing should be moved in to a single unit
        cameraOptionsViewController = self.storyboard?.instantiateViewController(withIdentifier: "CameraOptionsSlider") as? CameraOptionsViewController

        setupCameraSettingsSwipeMenu()

        cameraSecondaryOptions = self.storyboard?.instantiateViewController(withIdentifier: "RightMenuViewController") as? RightMenuSetViewController

        view.addSubview((cameraSecondaryOptions?.view)!)

        var viewHeight = view.bounds.height
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first
            if (window != nil) {
                viewHeight = window!.safeAreaLayoutGuide.layoutFrame.height
            }
        }
        
        cameraSecondaryOptions?.view.transform = CGAffineTransform.init(translationX: view.bounds.width-(cameraSecondaryOptions?.view.bounds.width)! + 5, y: viewHeight - (cameraSecondaryOptions?.view.bounds.height)! - 80)
        
        cameraResolutionSideMenu = self.storyboard?.instantiateViewController(withIdentifier: "ResolutionSideMenuViewController") as? ResolutionSideMenuViewController
        
        view.addSubview((cameraResolutionSideMenu?.view)!)

        cameraResolutionSideMenu?.view.transform = CGAffineTransform.init(translationX: -2, y: viewHeight - (cameraResolutionSideMenu?.view.bounds.height)! - 70)
        
        cameraResolutionSideMenu?.setTouchEndCb(cb: onShowResOptions)

        self.cameraSecondaryOptions?.addObserver(self, forKeyPath: "orientationRawState", options: NSKeyValueObservingOptions.new, context: nil)
        self.cameraSecondaryOptions?.addObserver(self, forKeyPath: "gridRawState", options: NSKeyValueObservingOptions.new, context: nil)
        self.cameraSecondaryOptions?.addObserver(self, forKeyPath: "flashModeRawState", options: NSKeyValueObservingOptions.new, context: nil)

        doPhotoBtn.processIcons();
//        doVideoBtn.processIcons();
    }

    private func enableUi() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.doPhotoBtn.isEnabled = true
            self.doPhotoBtn.alpha = 1
            
            if self.isPhotoOnly {
                self.disableVideoRecording()
            } else {
//                self.doVideoBtn.isEnabled = true
//                self.doVideoBtn.alpha = 1
            }
            
            self.cameraSecondaryOptions?.view.isHidden = false
            self.cameraResolutionSideMenu?.view.isHidden = false
            self.enablePermsView.isHidden = true

            self.toggleCariocaIndicatorPin()
            
            //todo -> reload UI method
            self.cameraResolutionSideMenu?.resModePicker.reloadComponent(0)
        })
    }
    
    private func toggleCariocaIndicatorPin(isEnabled: Bool = true) {
        
        if (self.optionsMenu?.hostView == nil) {
            optionsMenu?.addInView(self.view)
        }
        
        var yOffset: CGFloat = -50
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first
            if (window != nil) {
                yOffset = -(view.bounds.height - window!.safeAreaLayoutGuide.layoutFrame.height) - 30
            }
        }
        
        if(!isEnabled) {
            yOffset = 50
        }
        
        self.optionsMenu?.showIndicator(.right, position: .bottom, offset: yOffset)
    }

    private func disableVideoRecording(_ areAnyStatesNotDetermined: Bool = false) {
        doVideoBtn.isEnabled = false
        doVideoBtn.alpha = 0.4
    }
    
    private func disableUi(_ areAnyStatesNotDetermined: Bool = false) {
        doPhotoBtn.isEnabled = false
        doPhotoBtn.alpha = 0.4
//        doVideoBtn.isEnabled = false
//        doVideoBtn.alpha = 0.4
        cameraSecondaryOptions?.view.isHidden = true
        cameraResolutionSideMenu?.view.isHidden = true
        if (!areAnyStatesNotDetermined) {
            enablePermsView.isHidden = false
        }
        hideActiveSetting { (AnyObject) in
            print("done hiding")
        }
        
        self.toggleCariocaIndicatorPin(isEnabled: false)
    }

    private func setupCameraSettingsSwipeMenu() {
        cariocaMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "CameraMenu") as? CameraMenuContentController

        //Set the tableviewcontroller for the shared carioca menu
        optionsMenu = CariocaMenu(dataSource: cariocaMenuViewController!)
        optionsMenu?.selectedIndexPath = IndexPath(item: 0, section: 0)

        optionsMenu?.delegate = self
        optionsMenu?.boomerang = .verticalAndHorizontal

        optionsMenu?.selectedIndexPath = IndexPath(row: (cariocaMenuViewController?.iconNames.count)! - 1, section: 0)

        //reverse delegate for cell selection by tap :
        cariocaMenuViewController?.cariocaMenu = optionsMenu
    }

    private func showActiveSetting() {
        if isAppUsable {
            menuHostView.center.x = self.view.center.x

            var tBefore = CGAffineTransform.identity
            tBefore = tBefore.translatedBy(x: 0, y: self.view.bounds.height/2 + self.menuHostView.bounds.height + self.actionToolbar.bounds.height)
            tBefore = tBefore.scaledBy(x: 0.6, y: 1)
            
            menuHostView.transform = tBefore
            
            menuHostView.isHidden = false

            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                var tAfter = CGAffineTransform.identity
                tAfter = tAfter.translatedBy(x: 0, y: self.view.bounds.height/2 - self.menuHostView.bounds.height - self.actionToolbar.bounds.height/2)
                tAfter = tAfter.scaledBy(x: 1, y: 1)
                
                self.menuHostView.transform = tAfter
            })
        }
    }

    private func hideActiveSetting(_ completion: @escaping (_ result: AnyObject) -> Void) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0, y: self.view.bounds.height/2 + self.menuHostView.bounds.height + self.actionToolbar.bounds.height)
            t = t.scaledBy(x: 1.4, y: 1)
            
            self.menuHostView.transform = t
        }) { (success:Bool) in
            self.menuHostView.isHidden = true

            self.menuHostView.unsetActiveMenu()
            completion(success as AnyObject)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let _keyPath: String = keyPath == nil ? "" : keyPath!

        switch _keyPath {
            case "orientationRawState":
                self.captureSessionManager.onLockUnLockOrientation((self.cameraSecondaryOptions?.orientationState)! as OrientationStates)
            case "gridRawState":
                switch (self.cameraSecondaryOptions?.gridState)! as GridFactor {
                case .off:
                    gridManager.gridFactor = .off
                case .double:
                    gridManager.gridFactor = .double
                case .quad:
                    gridManager.gridFactor = .quad
                }
            case "flashModeRawState":
                captureSessionManager.flashModeState = (cameraSecondaryOptions?.flashModeState)!

            default:
                break
        }

    }
}

class SharedBlurView: UIVisualEffectView {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds    = true
        self.layer.cornerRadius     = 5
    }    
}

class SharedButtonView: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    self.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
                    self.transform = CGAffineTransform.init(translationX: 2, y: 0)
                    self.alpha = 0.5
                })
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        DispatchQueue.global(qos: .userInteractive).async {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                    self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
                    self.transform = CGAffineTransform.init(translationX: -2, y: 0)
                    self.alpha = 1
                })
            }
        }
    }
}
