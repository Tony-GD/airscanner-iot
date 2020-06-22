//
//  DevicesView.swift
//  Air Scanner
//
//  Created by Alexandr Gaidukov on 09.06.2020.
//  Copyright © 2020 Grid dynamics. All rights reserved.
//

import SwiftUI


struct DeviceState {
    var name: String = ""
    var description: String = ""
    var gateway: Gateway? = nil
    var location: Location? = nil
    var dataFormatIndex: Int = 0
    var key: String = ""
    
    var locationDescription: String {
        get { location.map { ["\($0.lat)", "\($0.lon)"].joined(separator: " ") } ?? "" }
        set {  }
    }
    
    var dataFormat: DeviceDataFormat {
        DeviceDataFormat.allCases[dataFormatIndex]
    }
    
    var isValid: Bool {
        !name.isEmpty && !description.isEmpty && location != nil && (gateway != nil || !key.isEmpty)
    }
    
    var request: AddDeviceRequest {
        let key = gateway == nil ? self.key : ""
        return AddDeviceRequest(key: key,
                         gatewayId: gateway?.id ?? "",
                         displayName: name,
                         isPublic: false,
                         locLat: location?.lat ?? 0,
                         locLon: location?.lon ?? 0,
                         dataFormat: dataFormat,
                         locationDescription: description)
    }
    
    mutating func clear() {
        name = ""
        description = ""
        gateway = nil
        location = nil
        dataFormatIndex = 0
        key = ""
     }
}

struct NewDeviceView: View {
    @Binding var state: DeviceState
    @State var readQRCode: Bool = false
    @State var selectGateway: Bool = false
    @State var selectLocation: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Device's name")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                TextField("Type name...", text: $state.name)
                    .textFieldStyle(MainTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Description")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                TextField("Type description...", text: $state.description)
                    .textFieldStyle(MainTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Gateway")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Button(action: { self.selectGateway = true }) {
                    Text(state.gateway != nil ? state.gateway!.name : "Gateway")
                }
                .buttonStyle(DisclosureButtonStyle())
                .foregroundColor(.inputBackground)
                .frame(height: 36.0)
                .frame(maxWidth: .infinity)
                .overlay(
                    NavigationLink(destination: GatewayListView(isDisplayed: $selectGateway, gateway: $state.gateway), isActive: $selectGateway) { EmptyView() }
                )
            }
            
            if state.gateway == nil {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Key")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    Button(action: { self.readQRCode = true }) {
                        Text(state.key.isEmpty ? "Scan the QR code" : state.key)
                    }
                    .buttonStyle(DisclosureButtonStyle())
                    .foregroundColor(.inputBackground)
                    .frame(height: 36.0)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        NavigationLink(destination: QRCodeReaderView(isDisplayed: $readQRCode, token: $state.key), isActive: $readQRCode) { EmptyView() }
                    )
                }
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Location")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Button(action: { self.selectLocation = true }) {
                    HStack(spacing: 0) {
                        TextField("Select your location", text: $state.locationDescription)
                            .textFieldStyle(MainTextFieldStyle())
                            .disabled(true)
                        Image("pin_icon")
                            .foregroundColor(.white)
                    }
                }
                .overlay(
                    NavigationLink(destination: LocationSelectionView(location: $state.location, isDisplayed: $selectLocation), isActive: $selectLocation) { EmptyView() }
                )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Data format")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Picker(selection: $state.dataFormatIndex, label: EmptyView()) {
                    ForEach(0..<DeviceDataFormat.allCases.count) {
                        Text(DeviceDataFormat.allCases[$0].displayName).frame(height: 80)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}

struct GatewayState {
    var name: String = ""
    var key: String = ""
    
    var isValid: Bool {
        !name.isEmpty && !key.isEmpty
    }
    
    var request: AddGatewayRequest {
        AddGatewayRequest(key: key, displayName: name)
    }
    
    mutating func clear() {
        name = ""
        key = ""
    }
}

struct NewGatewayView: View {
    
    @Binding var state: GatewayState
    @State var readQRCode: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Gateway's name")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                TextField("Type name...", text: $state.name)
                    .textFieldStyle(MainTextFieldStyle())
            }
            VStack(alignment: .leading, spacing: 2) {
                Text("Key")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                Button(action: { self.readQRCode = true }) {
                    Text(state.key.isEmpty ? "Scan the QR code" : state.key)
                }
                .buttonStyle(DisclosureButtonStyle())
                .foregroundColor(.inputBackground)
                .frame(height: 36.0)
                .frame(maxWidth: .infinity)
                .overlay(
                    NavigationLink(destination: QRCodeReaderView(isDisplayed: $readQRCode, token: $state.key), isActive: $readQRCode) { EmptyView() }
                )
            }
        }
    }
}

struct DevicesView: View {
    @EnvironmentObject private var localStorage: LocalStorage
    @State private var objectType: Int = 0
    @State private var gatewayState = GatewayState()
    @State private var deviceState = DeviceState()
    @State private var alertState: AlertState = .dismissed
    @ObservedObject var gatewayEndpoint = Endpoint<AddItemResponse>(baseURL: API.baseURL, path: "gateway", method: .post)
    @ObservedObject var deviceEndpoint = Endpoint<AddItemResponse>(baseURL: API.baseURL, path: "device", method: .post)
    
    @State private var isLoading: Bool = false
    
    var objectTypes = ["Device", "Gateway"]
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ZStack(alignment: .topLeading) {
                            Color.background.edgesIgnoringSafeArea(.all)
                            VStack(spacing: 36) {
                                Picker(selection: self.$objectType, label: EmptyView()) {
                                    ForEach(0..<self.objectTypes.count) {
                                        Text(self.objectTypes[$0])
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                                if self.objectType == 0 {
                                    NewDeviceView(state: self.$deviceState)
                                } else {
                                    NewGatewayView(state: self.$gatewayState)
                                }
                                Color.background.frame(width: 40, height: 60)
                            }
                            .padding()
                            VStack {
                                Spacer()
                                Button(action: {
                                    if self.objectType == 0 {
                                        self.createDevice()
                                    } else {
                                        self.createGateway()
                                    }
                                    
                                }) {
                                    ZStack {
                                        if (!self.isLoading) {
                                            Text(self.objectType == 0 ? "Add device" : "Add gateway")
                                        }
                                        LoadingIndicator(isLoading: self.isLoading, color: .white)
                                    }
                                }
                                .buttonStyle(MainButtonStyle())
                                .disabled(self.isLoading || (self.objectType == 0 && !self.deviceState.isValid) || (self.objectType == 1 && !self.gatewayState.isValid))
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .padding(.bottom)
                            }.padding()
                        }
                        .frame(minHeight: proxy.size.height)
                        .disabled(self.isLoading)
                        Color.background.frame(width: proxy.size.width, height: proxy.safeAreaInsets.bottom)
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarTitle("Add new")
        }
        .overlay (
            Group {
                if alertState.isPresented {
                    AlertView(state: alertState)
                        .transition(.opacity)
                }
            }
        )
        .onReceive(gatewayEndpoint.$result) { result in
            self.isLoading = false
            switch result {
            case .success?:
                self.showAlertWithState(.success("The gateway was added. Now you can track it."))
                self.gatewayState.clear()
            case .failure(let error)?:
                self.showAlertWithState(.error(error.localizedDescription))
            case nil:
                self.alertState = .dismissed
            }
        }
        .onReceive(deviceEndpoint.$result) { result in
            self.isLoading = false
            switch result {
            case .success?:
                self.showAlertWithState(.success("The device was added. Now you can track it."))
                self.deviceState.clear()
            case .failure(let error)?:
                self.showAlertWithState(.error(error.localizedDescription))
            case nil:
                self.alertState = .dismissed
            }
        }
        .overlay(
            ZStack {
                if localStorage.user == nil {
                    LoginView()
                        .transition(.opacity)
                        .zIndex(0)
                }
            }
        )
    }
    
    private func showAlertWithState(_ state: AlertState) {
        withAnimation {
            alertState = state
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation{
                self.alertState = .dismissed
            }
        }
    }
    
    private func createGateway() {
        isLoading = true
        gatewayEndpoint.load(params: gatewayState.request)
    }
    
    private func createDevice() {
        isLoading = true
        deviceEndpoint.load(params: deviceState.request)
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
