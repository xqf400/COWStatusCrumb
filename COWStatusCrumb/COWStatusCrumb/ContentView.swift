//
//  ContentView.swift
//  COWStatusCrumb
//
//  Created by XQF on 04.03.23.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.openURL) var openURL
    
    @State private var crumbTextEnabled: Bool = StatusManager.sharedInstance().isCrumbOverridden()
    
    @ObservedObject var backgroundController = BackgroundFileUpdaterController.shared

    
    let fm = FileManager.default
    let infoStr = "Model: \(modelIdentifier()), iOS Version: \(UIDevice.current.systemVersion)"
    
    var body: some View {
        NavigationView {
            List {
                if (StatusManager.sharedInstance().isMDCMode()) {
                    Section (footer: Text("Your device will respring.")) {
                        Button("Apply") {
                            if fm.fileExists(atPath: "/var/mobile/Library/SpringBoard/statusBarOverridesEditing") {
                                do {
                                    _ = try fm.replaceItemAt(URL(fileURLWithPath: "/var/mobile/Library/SpringBoard/statusBarOverrides"), withItemAt: URL(fileURLWithPath: "/var/mobile/Library/SpringBoard/statusBarOverridesEditing"))
                                    respringFrontboard()
                                } catch {
                                    print("\(error)")
                                    UIApplication.shared.alert(body: "\(error)")
                                }
                                
                            }
                        }
                    }
                }
                Section{
                    Text(infoStr)
                }
                Section (footer: Text("When set to blank on notched devices, this will display the carrier name.")) {
                    Toggle("Date above clock", isOn: $crumbTextEnabled).onChange(of: crumbTextEnabled, perform: { nv in
                        if nv {
                            setCrumbDate()
                        } else {
                            StatusManager.sharedInstance().unsetCrumb()
                        }
                    })
                }
            }
            .navigationTitle("StatusCrumb")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
