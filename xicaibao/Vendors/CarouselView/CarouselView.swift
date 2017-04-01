
//
//  CarouselView.swift
//  Youli
//
//  Created by JERRY LIU on 9/11/2015.
//  Copyright © 2015 ONTHETALL. All rights reserved.
//
import UIKit
import Foundation

protocol CarouselViewDelegate: NSObjectProtocol {
    
    func didTapCarouselImageViewAtIndex(index: Int)
}

class CarouselView: UIView {
    
    weak var delegate: CarouselViewDelegate?
    
    // load nib/xib
    var view: UIView!
    var nibName: String = "CarouselView"
    
    // Remote fetch image urls into rotating scrollView with pageControls
    var imageUrls: [String] = [] {
        didSet{
            self.configSubviews()
            self.setupPhotos()
            
        }
    }
    
    var imageViews = [UIImageView]()
    
    // XIB subviews
    @IBOutlet weak var pageControl: UIPageControl?   //提示当前滚动的图片，指示器
    @IBOutlet weak var scrollView: UIScrollView?  // 实现图片轮播的滚动
    
    // other properites 定时器
    var timer: Timer = Timer()
    var placeholderImage: UIImage = UIImage(named: "BannerPlaceHolder")!
    
    // MARK: Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
        self.startTimer() //启动定时器
    }
    
    deinit {
        // 停止定时器
        self.stopTimer()
    }
    
    //MARK: convenience init
    convenience init(frame: CGRect, imageUrls: [String], placeholderImage: UIImage?) {
        self.init(frame: frame)
        self.placeholderImage = placeholderImage ?? self.placeholderImage
        self.imageUrls = imageUrls
        self.configSubviews()
        self.setupPhotos()
    }
    
    convenience init(frame: CGRect, imageUrls: [String]) {
        self.init(frame: frame, imageUrls: imageUrls, placeholderImage: nil)
    }
    
    // 代理传值：点击图片跳转到链接：url
    @IBAction func tapScrollViewAction(sender: UITapGestureRecognizer) {
        
        if delegate?.responds(to: Selector("clickImageView:")) != nil {
            delegate?.didTapCarouselImageViewAtIndex(index: (pageControl?.currentPage)!)
        }
    }
    
    //MARK: setup subviews
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    private func setup() {
        self.view = loadViewFromNib()
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        view.addConstraints(self.constraints)
        
        self.addSubview(self.view)
        
        self.configSubviews()
        self.scrollView?.delegate = self
    }
    
    // scrollView设置
    private func configSubviews() {
        // ScrollView setup
        self.scrollView!.isPagingEnabled = true  // 是否分页
        self.scrollView!.showsHorizontalScrollIndicator = false  // 显示水平滚动指标
        
        
        resizeScrollView()
        
        // Pagecontrol setup  页码指示器
        self.pageControl!.numberOfPages = self.imageUrls.count
        
    }
    
    // 调整srcollView尺寸
    private func resizeScrollView() {
        let screenWidth = self.view.frame.width
        let contentWidth = Int(screenWidth) * (self.imageUrls.count + 1)  //scrollView 宽度
        self.scrollView!.contentSize = CGSize(width: contentWidth, height: 0)
        self.scrollView!.contentOffset = CGPoint(x: screenWidth, y: 0) // 偏移量
        
    }
    
   
    
    // 实现图片滚动播放
    private func setupPhotos() {
        
        let n = self.imageUrls.count
        let screenWidth = self.frame.width
        let screenHeight = self.frame.height
        
        // reset
        self.imageViews = [UIImageView]()
        
        for i in 0..<n {
            let imageView = UIImageView(frame: CGRect(x: screenWidth * CGFloat(i + 1), y: 0, width: screenWidth, height: screenHeight))
            let imageUrl = self.imageUrls[i]
            addToCarousel(imageView: imageView, imageUrl: imageUrl)
        }
        
        if n > 1 {
            // add 1st pic to end for circular scroll
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: self.frame.height))
            let imageUrl = self.imageUrls.last!
            addToCarousel(imageView: imageView, imageUrl: imageUrl)
        }
    }
    
    // 添加图片ImageView, 定义如何载入imageUrl
    private func addToCarousel(imageView: UIImageView, imageUrl: String) {
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        if let url = NSURL(string: imageUrl) {
            imageView.af_setImage(withURL: url as URL)
        } else {
            imageView.image = UIImage()
        }
        
        
        imageView.clipsToBounds = true
        self.imageViews.append(imageView)
        self.scrollView!.addSubview(imageView)
    }

    
    // MARK: Timer  定时器
    func startTimer() {
        
        self.timer =  Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(CarouselView.Nowtimer(timer:)), userInfo: "Hello Time", repeats: true)
    }
    
    // 关闭定时器
    func stopTimer() {
        self.timer.invalidate()
    }
    
    public func Nowtimer(timer: Timer) {
        
        let offset = self.scrollView!.contentOffset
        // 判断是否滑动到最后一页
        if offset.x + self.frame.width >= self.scrollView!.contentSize.width {
            // 最后一页
            self.scrollView!.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.scrollView!.setContentOffset(CGPoint(x: self.frame.width, y: 0), animated: false)
            
        } else {
            // 还没到最后一页
            self.scrollView!.setContentOffset(CGPoint(x: offset.x + self.frame.width, y: 0), animated: true)
        }
        
    }
}

// MARK: Scrolling
extension CarouselView : UIScrollViewDelegate {
    
    // 更新pageController
    private func UpdatePageControl() {
        let offset = self.scrollView!.contentOffset
        let page: NSInteger = NSInteger(offset.x / self.frame.width)
        let maxPages = self.imageUrls.count
        self.pageControl!.currentPage = page - 1 < 0 ? maxPages - 1 : page - 1
        
    }
    
    private func scrollCircle() {
        let offset = self.scrollView!.contentOffset
        let width = self.frame.width
        let maxPages = self.imageUrls.count
        
         // 最后一页
        if (offset.x + width > self.scrollView!.contentSize.width) {
            self.scrollView!.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
          
        } else if (offset.x < 0) {
            self.scrollView!.setContentOffset(CGPoint(x: maxPages * Int(width), y: 0), animated: false)
        }
        
    }
    
    // 代理方法: 获取滚动视图的变化
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollCircle()
        self.UpdatePageControl()
    }
    
}
