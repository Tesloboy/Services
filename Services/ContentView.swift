//
//  ContentView.swift
//  Services
//
//  Created by Viktor Teslenko on 27.03.2024.
//

import SwiftUI
import Combine
import WebKit

struct Service: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let description: String
    let iconURL: URL
    let link: URL
    
    private enum CodingKeys: String, CodingKey {
        case name, description, link, iconURL = "icon_url"
    }
}

class ServicesViewModel: ObservableObject {
    @Published var services: [Service] = []
    private var cancellable: AnyCancellable?
    
    init() {
        fetchServices()
    }
    
    func fetchServices() {
        guard let url = URL(string: "https://publicstorage.hb.bizmrg.com/sirius/result.json") else {
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ResponseData.self, decoder: JSONDecoder())
            .map { $0.body.services }
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .assign(to: \.services, on: self)
    }
}

struct ServiceRow: View {
    let service: Service
    
    var body: some View {
        HStack {
            AsyncImage(url: service.iconURL) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text(service.name)
                    .font(.headline)
                Text(service.description)
                    .font(.subheadline)
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ServicesViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.services) { service in
                NavigationLink(destination: WebView(url: service.link)) {
                    ServiceRow(service: service)
                }
            }
            .navigationTitle("Сервисы")
        }
    }
}

struct WebView: View {
    let url: URL
    
    var body: some View {
        WebViewWrapper(url: url)
            .edgesIgnoringSafeArea(.all)
    }
}

struct WebViewWrapper: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct ResponseData: Decodable {
    let body: Body
}

struct Body: Decodable {
    let services: [Service]
}
