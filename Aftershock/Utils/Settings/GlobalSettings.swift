//
//  GlobalSettings.swift
//  Aftershock
//
//  Created by Anatoly Vdovichev on 30/04/2019.
//  Copyright © 2019 ASVCorp. All rights reserved.
//

import Foundation

/// A holder of application settings. This class may contain
/// only validated set of setting.
class GlobalSettings {

    static let instance = GlobalSettings()

    /// timestamp of settings in user defaults
    var defaultsSettingTimestamp: Double = 0

    /// timestamp of settings loaded from user defaults
    var loadedSettigsTimeStamp: Double = 0

    private var loadedSettings : InstanceSettings?

    var settings: InstanceSettings? {
        set(newSettings) {
            loadedSettings = newSettings
            loadedSettigsTimeStamp = Date().timeIntervalSince1970
            // send notification that settings were updated //
            NotificationHelper
                .sendNotification(keyword: NotificationHelper.Keyword.settings)
        }
        get {
            if (defaultsSettingTimestamp > loadedSettigsTimeStamp) {
                return nil;
            }
            return loadedSettings
        }
    }
}
