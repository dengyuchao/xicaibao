//
//  LiveTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/3/31.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit

class LiveViewController: UIViewController {

    let headerViewReuserIdentifier: String = "CollectionViewHeaderView"
    var carouselView:CarouselView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupView()
    }
    
    private func setupView() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        // 轮播图
        let bannerHeight: CGFloat = 128.0 // 轮播图高度
        self.carouselView = CarouselView(frame: CGRect(x: 0, y: 0, width:  UIScreen.main.bounds.width, height: bannerHeight))
                //self.carouselView?.delegate = self
    }
    
    private func loadBannersImages() {
        
        
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        
//        if kind == UICollectionElementKindSectionHeader {
//            
//            let headerCollectionView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewReuserIdentifier, for: indexPath as IndexPath)
//            
//            headerCollectionView.addSubview(self.carouselView!)
//            
//            return headerCollectionView
//        } else {
//            
//            return UICollectionReusableView()
//        }
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
//    {
//        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 2 / 3)
//    }

}
