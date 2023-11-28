//
//  SourceEditorCommand.swift
//  MyXCodeExt
//
//  Created by GaoXudong on 2023/6/2.
//

import Foundation
import XcodeKit

let cmdClassName = SourceEditorCommand.className()

protocol CommandDefine {
    static var idKey: String { get }
    static var nameKey: String { get }
    static func configInfo() -> [XCSourceEditorCommandDefinitionKey: String]
}

extension CommandDefine {
    static func configInfo() -> [XCSourceEditorCommandDefinitionKey: String] {
        return [
            .classNameKey: cmdClassName,
            .identifierKey: Self.idKey,
            .nameKey: Self.nameKey
        ]
    }
}

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        switch invocation.commandIdentifier {
        case NewLine.idKey:
            NewLine().perform(with: invocation, completionHandler: completionHandler)
        case PrettyFunc.idKey:
            PrettyFunc().perform(with: invocation, completionHandler: completionHandler)
        default:
            print("unrecongnized command identifier")
        }
    }
}

func whiteSpaceLen(of lineStr: String?) -> Int {
    let whiteSpaceIndex = lineStr?.firstIndex(where: { $0 != " "})
    guard let lineStr, let whiteSpaceIndex else { return 0 }
    return lineStr.distance(from: lineStr.startIndex, to: whiteSpaceIndex)
}
