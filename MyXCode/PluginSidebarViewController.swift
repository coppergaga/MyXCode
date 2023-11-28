//
//  PluginSidebarViewController.swift
//  MyXCode
//
//  Created by GaoXudong on 2023/11/27.
//

import Cocoa

protocol PluginSidebarActionDelegate {
    func didSelectPlugin(with pluginInfo: PluginInfo?)
}

class PluginSidebarViewController: NSViewController {
    @IBOutlet weak var pTableView: NSTableView!
    private var datas: [PluginInfo] = [
        .newLine, .prettyFunc
    ]
    var actionDelegate: PluginSidebarActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(pluginConfigUpdated(_:)), name: .kPluginConfigUpdated, object: nil)
    }
    
    @objc
    private func pluginConfigUpdated(_ notification: Notification) {
        datas = [
            .newLine, .prettyFunc
        ]
        let selectedRow = pTableView.selectedRow
        pTableView.reloadData()
        pTableView.selectRowIndexes(IndexSet(integer: selectedRow), byExtendingSelection: true)
    }
}

extension PluginSidebarViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let view = tableView.makeView(withIdentifier: kPluginNameCell, owner: self) as? NSTableCellView {
            view.textField?.stringValue = datas[row].name
            return view
        }
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = pTableView.selectedRow
        actionDelegate?.didSelectPlugin(with: selectedRow >= 0 ? datas[selectedRow] : nil)
    }
}

extension PluginSidebarViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        datas.count
    }
}
