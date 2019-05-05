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
    var defaultsSettingTimestamp = 0

    /// timestamp of settings loaded from user defaults
    var loadedSettigsTimeStamp = 0

    private var loadedSettings : InstanceSettings?

    var settings: InstanceSettings? {
        set(newSettings) {
            loadedSettings = newSettings
            loadedSettigsTimeStamp = 1;
        }
        get {
            if (defaultsSettingTimestamp > loadedSettigsTimeStamp) {
                return nil;
            }
            return loadedSettings
        }
    }
}
