//
//  Extension+MusicVC.swift
//  AppleMusic
//
//  Created by Kleiton Mendes on 21/08/22.
//

import Foundation
import UIKit

extension MusicViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else { return }
        
        DownloadService.activeDownloads[sourceURL] = nil
        let destination = localFilePath(for: sourceURL)
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destinationURL)
        do {
            try fileManager.copyItem(at: location, to: destinationURl)
        } catch let erro {
            print("No copy file to disk: \(NSLocalizedDescription)")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalbytesExpectedToWrite: Int64) {
        if let url = downloadTask.originalRequest?.url, let _ = DownloadService.activeDownloads[url] {
            let progress = round(Float(totalBytesWritten) / Float(totalByteesExpectedToWrite) * 100)
            
            print("carregando: \(progress) %")
        }
    }
}

extension MusicViewController: URLSessionDelegate {
    func urlSessionDidFinishEventes(forBackgroundURLSession session: URLSession) {
        OperationQueue.main.addOperation {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let completionHander = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHander()
            }
        }
    }
}
