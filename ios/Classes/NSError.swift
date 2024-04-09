//
//  NSError.swift
//  nb_navigation_flutter
//
//  Created by qiuyu on 2023/3/1.
//

import Foundation
extension NSError {
    func toastError() -> String {
        var errorStr = "errorcode: \(self.code)\n"
        if let failedReason = self.userInfo[NSLocalizedFailureReasonErrorKey] {
            errorStr += "\(failedReason) \n"
        } else {
            errorStr += self.localizedDescription
        }
        return errorStr
    }
}
