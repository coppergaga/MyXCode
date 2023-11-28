//
//  PrettyFunc.swift
//  MyXCodeExt
//
//  Created by GaoXudong on 2023/11/21.
//

import Foundation
import XcodeKit
import SwiftFormat


class PrettyFunc: NSObject {
    var lines: NSMutableArray = []
    var range = NSRange()
    var indent: Int = 0
}

extension PrettyFunc: CommandDefine {
    static var idKey: String {
        "PrettyFuncCommand"
    }
    
    static var nameKey: String {
        "pretty func command"
    }
}

extension PrettyFunc: XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        defer {
            completionHandler(nil)
        }
        
        guard let select = invocation.buffer.selections.firstObject as? XCSourceTextRange else { return }
        let startLine = select.start.line
        let endLine = select.end.line
        
        range = NSRange(location: startLine, length: endLine - startLine + 1)
        
        let source = invocation.buffer.lines.subarray(with: range) as? [String]
        guard let source else { return }
        
        guard let groupUrl = ConstValue.groupUrl else { return }
        let ruleUrl = groupUrl.appending(component: ConstValue.swiftFormatConfigName)
        guard let rulesData = try? Data(contentsOf: ruleUrl),
              let config = try? JSONDecoder().decode(Configuration.self, from: rulesData) else { return }
        
        lines = invocation.buffer.lines
        indent = whiteSpaceLen(of: invocation.buffer.lines[startLine] as? String)
        
        var outputStream = self
        try? SwiftFormatter(configuration: config).format(source: source.joined(), assumingFileURL: nil, to: &outputStream)
    }
}

extension PrettyFunc: TextOutputStream {
    func write(_ string: String) {
        let indentSpace = String(repeating: " ", count: indent)
        let formatted = string.split(separator: "\n")
            .map { eachLine in
                indentSpace + eachLine + "\n"
            }
        lines.replaceObjects(in: range, withObjectsFrom: formatted)
    }
}
