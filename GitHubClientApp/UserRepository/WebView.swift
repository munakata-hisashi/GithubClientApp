import Foundation
import SwiftUI
import WebKit

/// WKWebViewをSwiftUIから扱えるようにするためのView
struct WebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        let request = URLRequest(url: url)
        let webView = WKWebView(frame: .zero, configuration: .init())
        webView.uiDelegate = context.coordinator
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(webView: self)
    }
    
}

class Coordinator: NSObject, WKUIDelegate {
    private let webView: WebView
    
    init(webView: WebView) {
        self.webView = webView
        super.init()
    }
}
