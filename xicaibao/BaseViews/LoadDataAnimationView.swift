//
//  LoadDataAnimationView.swift
//  Youli
//
//  Created by impressly on 16/3/28.
//  Copyright © 2016年 ONTHETALL. All rights reserved.
//

import UIKit
class LoadDataAnimationView: UIView {
    
    @IBOutlet weak var loadingImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    let firstWindow = UIApplication.shared.windows.first
    
    let xibName: String = "LoadDataAnimationView"
    
    var myTitle: String?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loadingImageView.animationImages = [UIImage(named: "Home_loading1")!, UIImage(named: "Home_loading2")!]
        loadingImageView.animationDuration = 0.3
        loadingImageView.animationRepeatCount = -1
        loadingImageView.startAnimating()
    }
    
    convenience init(frame: CGRect, title: String) {
        
        self.init(frame: frame)
        self.myTitle = title
        
        setup()
    }
    
    private func setup() {
        
        let view = loadViewFormXIB() as! LoadDataAnimationView
        view.frame =  CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        //self.titleLabel.text = myTitle
        self.addSubview(view)
    }
    
    private func loadViewFormXIB() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: xibName, bundle: bundle)
        
        let view = nib.instantiate(withOwner: self, options: nil).first as! LoadDataAnimationView
        return view
    }
    
    func show() {
        firstWindow?.addSubview(self)
    }
    
    func dismiss() {
        
        removeSelf()
    }
    
    func removeSelf() {
        
        self.removeFromSuperview()
    }
    
}
