//
//  SourceEditorCommand.swift
//  MyXCodeExt
//
//  Created by GaoXudong on 2023/6/2.
//

import Foundation
import XcodeKit

let cmdClassName = SourceEditorCommand.className()

enum CommandDef {
    case newLine
    
    func configInfo() -> [XCSourceEditorCommandDefinitionKey: String] {
        switch self {
        case .newLine:
            return [
                .classNameKey: cmdClassName,
                .identifierKey: idKey,
                .nameKey: nameKey
            ]
        }
    }
    
    var idKey: String {
        switch self {
        case .newLine: return "NewLineCommand"
        }
    }
    
    var nameKey: String {
        switch self {
        case .newLine: return "new line command"
        }
    }
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        switch invocation.commandIdentifier {
        case CommandDef.newLine.idKey:
            if let select = invocation.buffer.selections.firstObject as? XCSourceTextRange {
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
        default:
            print("unrecongnized command identifier")
        }
        completionHandler(nil)
    }
    
    
    private func whiteSpaceLen(of lineStr: String?) -> Int {
        let whiteSpaceIndex = lineStr?.firstIndex(where: { $0 != " "})
        guard let lineStr, let whiteSpaceIndex else { return 0 }
        return lineStr.distance(from: lineStr.startIndex, to: whiteSpaceIndex)
    }
}
