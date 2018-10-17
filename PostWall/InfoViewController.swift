//
//  InfoViewController.swift
//  ViewControllersAndLogs
//
//  Created by Ilya Aleshin on 21.06.2018.
//  Copyright © 2018 Bakh. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = version
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Info экран был показан")
    }
    
}
