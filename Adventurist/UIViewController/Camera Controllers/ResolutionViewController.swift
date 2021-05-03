//
//  ResolutionViewController.swift
//  capio
//
//  Created by Roman on 2/12/17.
//  Copyright © 2017 theroman. All rights reserved.
//

import UIKit
import AVFoundation


enum ResMenuType{
    case label, picker
}

class LabelCell: UITableViewCell{
    
    var _videoResDimensions: CMVideoDimensions = CMVideoDimensions.init()
    
    var videoResDimensions: CMVideoDimensions {
        set {
            videResLabel.text = String(newValue.width) + "x" + String(newValue.height)
        }
        get {
            return self._videoResDimensions
        }
    }
    
    var photoResDimensions: CMVideoDimensions {
        set {
            photoResLabel.text = String(newValue.width) + "x" + String(newValue.height)
        }
        get {
            return self._videoResDimensions
        }
    }
    
    @IBOutlet weak var videResLabel: UILabel!
    @IBOutlet weak var slomoLabel: UILabel!
    @IBOutlet weak var fpsLabel: UILabel!
    @IBOutlet weak var photoResLabel: UILabel!
}

class PickerCell: UITableViewCell {
    @IBOutlet weak var resPicker: UIPickerView!
}

class ResolutionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    var captureSessionManager:                  CaptureSessionManager! = CaptureSessionManager.sharedInstance
    
    //todo: do a local hot observer from cameraSettingsObservable

    var menu:[ResMenuType] = [ResMenuType]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu = [ResMenuType]()
        
        menu.append(.label)
        menu.append(.picker)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        processSubscribers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return captureSessionManager.resolutionFormatsArray.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return captureSessionManager.resolutionFormatsArray[row].name
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        onPickerRowSelected(row)
    }
    
    private func onPickerRowSelected(_ row: Int) {
        let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! LabelCell
        
        cell._videoResDimensions = captureSessionManager.resolutionFormatsArray[row].videoResolution
        cell.photoResDimensions = captureSessionManager.resolutionFormatsArray[row].photoResolution
        
        cell.fpsLabel.text = String(Int(captureSessionManager.resolutionFormatsArray[row].fpsRange.maxFrameRate))
        cell.slomoLabel.alpha = captureSessionManager.resolutionFormatsArray[row].isSlomo == true ? 1 : 0.4
        
        captureSessionManager.setResolution(captureSessionManager.resolutionFormatsArray[row])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        switch menu[(indexPath as NSIndexPath).item]{
        case .label:
            let labelCell = tableView.dequeueReusableCell(withIdentifier: "cell_label", for: indexPath) as! LabelCell

            cell = labelCell
        case .picker:
            let pickerCell  = tableView.dequeueReusableCell(withIdentifier: "cell_picker", for: indexPath) as! PickerCell
            
            pickerCell.resPicker.dataSource = self
            pickerCell.resPicker.delegate = self

            cell = pickerCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch menu[(indexPath as NSIndexPath).item]{
        case .label:
            return 70
        case .picker:
            return 60
        }
    }
    
    private var currentBuffedFormat: ResolutionFormat!
    
    private func processSubscribers() {
        captureSessionManager.cameraSettingsObservable.subscribe(onNext: { (newCameraSettings: CameraSessionSettings) in
            if newCameraSettings.activeResFormat != nil && self.currentBuffedFormat != newCameraSettings.activeResFormat {
                let newFormat = newCameraSettings.activeResFormat!
                self.currentBuffedFormat = newCameraSettings.activeResFormat
                //todo: figure a better way to pass the index right away here instead of lookup
                let rowIndex = self.captureSessionManager.resolutionFormatsArray.firstIndex { (format: ResolutionFormat) -> Bool in
                    return format.photoResolution.width == newFormat.photoResolution.width && format.videoResolution.height == newFormat.videoResolution.height && format.name == newFormat.name && format.fpsRange == newFormat.fpsRange && format.isSlomo == newFormat.isSlomo
                }
                
                let cell = self.tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! PickerCell
                
                cell.resPicker.selectRow(rowIndex!, inComponent: 0, animated: true)
                self.onPickerRowSelected(rowIndex!)
            }
        })
    }
}
