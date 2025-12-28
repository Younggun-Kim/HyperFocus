//
//  HyperFocusApp.swift
//  HyperFocus
//
//  Created by 김영건 on 12/7/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct HyperFocusApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            FocusHomeView(store: Store(initialState: FocusHomeFeature.State()) {
                FocusHomeFeature()
            })
//            AppView(
//                store: Store(initialState: AppFeature.State()) {
//                    AppFeature()
//                }
//            )
        }
    }
}
