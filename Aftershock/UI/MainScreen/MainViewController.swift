//
//  ViewController.swift
//  Aftershock
//
//  Created by Anatoly Vdovichev on 24/03/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var console: UITableView!

    let logger: Logger = Logger.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        console.dataSource = self
        console.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        // Subscribe to log notifications for updating console content //
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.logChanged),
            name: Notification.Name(Logger.NOTIFICATION_KEY),
            object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        // Unsubscribe from log notifications //
        NotificationCenter.default.removeObserver(self)
    }

    /// Update console with new log messages
    @objc func logChanged() {
        DispatchQueue.main.async {
            self.console.reloadData()
        }
    }
}

/// Console data source and console table view delegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return logger.count;
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ConsoleLine") as! ConsoleLine

        if let message = logger.getMessage(index: indexPath.row) {
            cell.setText(text: message.text)
        } else {
            cell.setText(text: "")
        }
        return cell;
    }
}
