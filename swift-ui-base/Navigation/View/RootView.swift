//
//  NavigationView.swift
//  swift-ui-base
//
//  Created by Germán Stábile on 3/13/20.
//  Copyright © 2020 Rootstrap. All rights reserved.
//

import SwiftUI

struct RootView: View {
  @EnvironmentObject var router: ViewRouter
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    AppRootView()
      .environmentObject(appState)
  }
}
