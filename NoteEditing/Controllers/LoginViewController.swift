//
//  LoginViewController.swift
//  NoteEditing
//
//  Created by Arkadiy Grigoryanc on 04.08.2019.
//  Copyright © 2019 Arkadiy Grigoryanc. All rights reserved.
//

import WebKit

private let showNotebookIdetifier = "ShowNotebook"

class LoginViewController: UIViewController {
    
    // MARK: Private properties
    private let networkManager = NetworkManager.manager
    
    // MARK: Private methods
    private func showWebView() {
        let viewController = UIViewController()
        let webView = WKWebView(frame: viewController.view.frame)
        webView.navigationDelegate = self
        webView.load(networkManager.authorizationRequest)
        viewController.view.addSubview(webView)
        present(viewController, animated: true)
    }
    
    private func authorization(with url: URL) {
        networkManager.authorization(url: url) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(_):
                    self?.dismiss(animated: true) {
                        self?.performSegue(withIdentifier: showNotebookIdetifier, sender: nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}

// MARK: - Actions & Navigation
extension LoginViewController {
    @IBAction func actionLogin(_ sender: Any) {
        showWebView()
    }
}

// MARK: - Navigation
extension LoginViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showNotebookIdetifier {
            segue.destination.modalPresentationStyle = .fullScreen
        }
    }
}

// MARK: - WKNavigationDelegate
extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url?.absoluteURL else { return }
        authorization(with: url)
    }
}
