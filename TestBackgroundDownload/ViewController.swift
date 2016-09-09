//
//  ViewController.swift
//  TestBackgroundDownload
//
//  Created by Wilson Yuan on 16/9/6.
//  Copyright © 2016年 Wilson-Yuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progress: UIProgressView!
    
    var delegate = DownloadSessionDelegate.shareInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //TestBackgroundDownload
        let urlString = "http://7xqgm2.com2.z0.glb.qiniucdn.com/snap/video/e5652bd3-876b-4ddc-a33c-f43c78a63e02.mp4"
        guard let url = URL(string: urlString) else { return }
        
        let config = URLSessionConfiguration.background(withIdentifier: UUID().uuidString)
        config.sessionSendsLaunchEvents = true
        config.isDiscretionary = true
        
        let session = URLSession(configuration: config, delegate: delegate, delegateQueue: nil)
        let task = session.downloadTask(with: url)
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
