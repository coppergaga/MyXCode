//
//  PluginConfigViewController.swift
//  MyXCode
//
//  Created by GaoXudong on 2023/11/27.
//

import Cocoa

class PluginConfigViewController: NSViewController {
    @IBOutlet weak var pNameLabel: NSTextField!
    @IBOutlet weak var pUsageLabel: NSTextField!
    @IBOutlet weak var pSaveButton: NSButton!
    @IBOutlet var pConfigView: NSTextView!
    
    var plugin: PluginInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showEmptyView()
    }
    
    @IBAction func saveConfig(_ sender: NSButton) {
        guard let plugin, let config = plugin.config else { return }
        let configStr = pConfigView.string
        guard let configData = configStr.data(using: .utf8),
              let _ = try? JSONSerialization.jsonObject(with: configData)
        else {
            showErrorToast("Invalid Json Format")
            return
        }
        
        guard let groupUrl = ConstValue.groupUrl else { return }
        let ruleUrl = groupUrl.appending(component: config.name)
        do {
            try configData.write(to: ruleUrl, options: .atomic)
            NotificationCenter.default.post(name: NSNotification.Name.kPluginConfigUpdated, object: nil)
            showSuccessToast("Save Config Successed")
        } catch let err {
            showErrorToast("Save Config Failed: \(err.localizedDescription)")
        }
    }
    
    private func showEmptyView() {
        pNameLabel.isHidden = true
        pUsageLabel.isHidden = true
        pSaveButton.isHidden = true
        pConfigView.isHidden = true
    }
    
    private func showErrorToast(_ content: String) {
        view.makeToast(content)
    }
    private func showSuccessToast(_ content: String) {
        view.makeToast(content)
    }
}

extension PluginConfigViewController: PluginSidebarActionDelegate {
    func didSelectPlugin(with pluginInfo: PluginInfo?) {
        plugin = pluginInfo
        guard let pluginInfo else {
            showEmptyView()
            return
        }
        
        pNameLabel.isHidden = false
        pUsageLabel.isHidden = false
        
        pNameLabel.stringValue = pluginInfo.name
        pUsageLabel.stringValue = pluginInfo.usage
        if let config = pluginInfo.config {
            pSaveButton.isHidden = false
            pConfigView.isHidden = false
            pConfigView.string = config.configs
        } else {
            pSaveButton.isHidden = true
            pConfigView.isHidden = true
            pConfigView.string = ""
        }
    }
}
