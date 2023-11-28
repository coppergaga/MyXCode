//
//  NewLine.swift
//  MyXCodeExt
//
//  Created by GaoXudong on 2023/11/21.
//

import Foundation
import XcodeKit

class NewLine: NSObject {
}

extension NewLine: CommandDefine {
    static var idKey: String {
        "NewLineCommand"
    }
    
    static var nameKey: String {
        "new line command"
    }
}

extension NewLine: XCSourceEditorCommand {
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        defer {
            completionHandler(nil)
        }
        guard let select = invocation.buffer.selections.firstObject as? XCSourceTextRange else { return }
        let lineNum = select.end.line
        let lineStr = invocation.buffer.lines[lineNum] as? String
        let whiteSpaceLen1 = whiteSpaceLen(of: lineStr)
        
        let totalLineCount = invocation.buffer.lines.count
        var whiteSpaceLen2 = 0
        let nextLineNum = lineNum + 1
        if nextLineNum < totalLineCount {
            let nextLineStr = invocation.buffer.lines[nextLineNum] as? String
            whiteSpaceLen2 = whiteSpaceLen(of: nextLineStr)
        }
        
        let newLineHeadWhiteSpaceLen = max(whiteSpaceLen1, whiteSpaceLen2)
        let newLineStr = String(repeating: " ", count: newLineHeadWhiteSpaceLen) + "\n"
        if nextLineNum <  totalLineCount {
            invocation.buffer.lines.insert(newLineStr, at: nextLineNum)
        } else {
            invocation.buffer.lines.add(newLineStr)
        }
        invocation.buffer.selections.removeAllObjects()
        invocation.buffer.selections.add(
            XCSourceTextRange(
                start: XCSourceTextPosition(line: nextLineNum, column: newLineHeadWhiteSpaceLen),
                end: XCSourceTextPosition(line: nextLineNum, column: newLineHeadWhiteSpaceLen)
            )
        )
    }
}
