//
//  DownloadSessionDelegate.swift
//  TestBackgroundDownload
//
//  Created by Wilson Yuan on 16/9/9.
//  Copyright © 2016年 Wilson-Yuan. All rights reserved.
//

import UIKit

typealias CompletionHandlerBlock = () -> Void

class DownloadSessionDelegate: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    var handlerQueue: [String : CompletionHandlerBlock]!
    
    static var shareInstance: DownloadSessionDelegate = {
        let shareInstance = DownloadSessionDelegate()
        shareInstance.handlerQueue = [String : CompletionHandlerBlock]()
        return shareInstance
    }()
    
    //MARK: - URLSessionDelegate
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint("session error: \(error)")
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error == nil {
            print("session \(session) download completed")
        } else {
            print("session \(session) download failed with error \(error?.localizedDescription)")
        }
    }
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("background session \(session) finished events.")
        
        guard let identifier = session.configuration.identifier else { return }
        callCompletionHandlerForSession(identifier: identifier)
        
    }

    
    //MARK: - URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("session \(session) has finished the download task \(downloadTask) of URL \(location).")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        print("session \(session) download task \(downloadTask) wrote an additional \(bytesWritten) bytes (total \(totalBytesWritten) bytes) out of an expected \(totalBytesExpectedToWrite) bytes.")
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        
        print("session \(session) download task \(downloadTask) resumed at offset \(fileOffset) bytes out of an expected \(expectedTotalBytes) bytes.")
    }
    
    
    //MARK: - Completion headler
    func addCompletionHandler(handler: @escaping CompletionHandlerBlock, identifier: String)  {
        handlerQueue[identifier] = handler
    }
    
    func callCompletionHandlerForSession(identifier: String) {
        assert(handlerQueue[identifier] != nil, "handler queue can't be nil")
        let handler: CompletionHandlerBlock = handlerQueue[identifier]!
        handlerQueue.removeValue(forKey: identifier)
        handler()
    }
}

