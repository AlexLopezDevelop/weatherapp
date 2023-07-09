//
//  weatherWidgetExtensionBundle.swift
//  weatherWidgetExtension
//
//  Created by Alex Lopez on 4/7/23.
//

import WidgetKit
import SwiftUI

@main
struct weatherWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        weatherWidgetExtension()
        weatherWidgetExtensionLiveActivity()
    }
}
