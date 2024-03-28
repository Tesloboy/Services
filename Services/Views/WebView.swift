//
//  WebView.swift
//  Services
//
//  Created by Viktor Teslenko on 28.03.2024.
//

import SwiftUI
import WebKit

// Представление веб-вью
struct WebView: View {
    let url: URL
    
    var body: some View {
        WebViewWrapper(url: url)
            .edgesIgnoringSafeArea(.all) // Игнорируем безопасные области, чтобы веб-вью занимало все пространство
    }
}

// Обертка для UIViewRepresentable, чтобы веб-вью могло быть использовано в SwiftUI
struct WebViewWrapper: UIViewRepresentable {
    let url: URL
    
    // Создание и конфигурация WKWebView
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url)) // Загрузка URL в веб-вью
        return webView
    }
    
    // Обновление веб-вью (здесь не используется, но требуется для UIViewRepresentable)
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
