//
//  SourceEditorExtension.swift
//  MyXCodeExt
//
//  Created by GaoXudong on 2023/6/2.
//

import Foundation
import XcodeKit

class SourceEditorExtension: NSObject, XCSourceEditorExtension {
    
    func extensionDidFinishLaunching() {
        // If your extension needs to do any work at launch, implement this optional method.
        print("gxd -- debug")
    }
    
    var commandDefinitions: [[XCSourceEditorCommandDefinitionKey: Any]] {
        // If your extension needs to return a collection of command definitions that differs from those in its Info.plist, implement this optional property getter.
        return [
            NewLine.configInfo(),
            PrettyFunc.configInfo()
        ]
    }
    
}
