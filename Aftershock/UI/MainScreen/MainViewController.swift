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
    @IBOutlet weak var pollButton: UIButton!

    let logger = Logger.instance
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat = "HH:mm:ss"
        console.dataSource = self
        console.delegate = self

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {

        pollButton.isEnabled = GlobalSettings.instance.settings != nil;

        // Subscribe to log notifications for updating console content //
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.logChanged),
            name: Notification.Name(NotificationHelper.Keyword.log.rawValue),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onSettingsUpdate),
            name: Notification.Name(NotificationHelper.Keyword.settings.rawValue),
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

    @objc func onSettingsUpdate() {
        // update can be done with valid settings only //
        pollButton.isEnabled = true;
    }

    @IBAction func onPollClicked(_ sender: Any) {
        Logger.instance.log(message: "Polling is not implemented yet");
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
            cell.setText(date: dateFormatter.string(from: message.date),
                         message: message.text)
        } else {
            cell.setText(date: "", message: "")
        }
        return cell;
    }
}
