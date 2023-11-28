//
//  MainApp.swift
//  MyXCode
//
//  Created by GaoXudong on 2023/11/23.
//

import Cocoa

class MainSplitViewController: NSSplitViewController {
    @IBOutlet weak var pSideBarItem: NSSplitViewItem!
    @IBOutlet weak var pDetailItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let sidebarVC = pSideBarItem.viewController as? PluginSidebarViewController,
           let detailVC = pDetailItem.viewController as? PluginConfigViewController else { return }
        sidebarVC.actionDelegate = detailVC
    }
}

struct PluginInfo {
    let name: String
    let usage: String
    let config: PluginConfig?
}

struct PluginConfig {
    let configs: String
    let name: String
}

extension PluginInfo {
    static var newLine: Self {
        PluginInfo(name: "New Line", usage: "添加空白行到当前行的下一行", config: nil)
    }
    static var prettyFunc: Self {
        let name = "Pretty Func"
        let usage = "格式化当前选中Swift代码块"
        let configName = ConstValue.swiftFormatConfigName
        let def = PluginInfo(name: name, usage: usage, config: PluginConfig(configs: "", name: configName))
        guard let groupUrl = ConstValue.groupUrl else { return def }
        let ruleUrl = groupUrl.appending(component: configName)
        guard let rulesStr = try? String(contentsOf: ruleUrl, encoding: .utf8) else { return def }
        return PluginInfo(name: name, usage: usage, config: PluginConfig(configs: rulesStr, name: configName))
    }
}


let kPluginNameCell = NSUserInterfaceItemIdentifier(rawValue: "plugin_name_cell")

extension NSNotification.Name {
    public static let kPluginConfigUpdated = NSNotification.Name("k_plugin_config_updated")
}
