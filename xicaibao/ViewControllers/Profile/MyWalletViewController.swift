//
//  MyWalletViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/20.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class MyWalletViewController: UIViewController {
    
    
    @IBOutlet weak var webView: UIWebView!
    var backBt: UIButton?
    var buttonRight: UIButton?
    var a = 3
    // 刷新动画
    var loadDataView: LoadDataAnimationView?
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupview()
        self.loadWebView()
        self.createLoadDateView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.loadDataView?.dismiss()
    }
    
    
    private func  setupview() {
        
        backBt = UIButton(frame: CGRect(x: 16, y: 25, width: 36, height: 36))
        backBt?.setImage(UIImage(named: "back_bt"), for: .normal)
        self.view.addSubview(backBt!)
        backBt?.addTarget(self, action:  #selector(MyWalletViewController.popAction), for: UIControlEvents.touchUpInside)
        backBt?.isHidden = true
    }
    
    
    func loadWebView() {
        
        let token = "583c80b59c15416d851015acca948bab"
        let url = URL(string: "http://192.168.0.114:8080/jzgj-wx/app/index?token=\(token)")
        
        let request: URLRequest = NSURLRequest(url: url!) as URLRequest
        self.webView?.loadRequest(request)
    }
    
    // 加载动画
    private func createLoadDateView() {
        var frame = self.view.frame
        
        frame.size.height = self.view.frame.height
        
        let loadDataViewAm = LoadDataAnimationView(frame: frame, title: "正在玩命加载数据")
        loadDataView = loadDataViewAm
    }
    
    func popAction() {
        if (self.webView?.canGoBack)! {
            self.webView?.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension MyWalletViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
//        self.loadDataView?.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.loadDataView?.dismiss()
//        backBt?.isHidden = false
    }
}
