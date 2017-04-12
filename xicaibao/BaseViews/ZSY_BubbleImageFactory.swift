//
//  BubbleImage.swift
//  ChatMessageDemo
//
//  Created by dengyuchao on 16/3/21.
//  Copyright © 2016年 dengyuchao. All rights reserved.
//

import UIKit
import CoreGraphics

class ZSY_BubbleImageFactory: UIImage {
    
    var bubbleImage: UIImage!
    var capInset: UIEdgeInsets!
    
    override init() {
        super.init()
        self.bubbleImage = zsy_bubbleImageFromBundleWithName(nil)
        self.capInset = zsy_centerPointEdgeInsetsForImageSize(bubbleImage.size)
    }
    
    convenience init(bubbleImage: UIImage, capInset: UIEdgeInsets) {
        self.init()
        self.bubbleImage = zsy_bubbleImageFromBundleWithName(nil)
        if capInset == UIEdgeInsets.zero {
            self.capInset = zsy_centerPointEdgeInsetsForImageSize(bubbleImage.size)
        } else {
            self.capInset = capInset
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required convenience init(imageLiteral name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }

    required convenience init(imageLiteralResourceName name: String) {
        fatalError("init(imageLiteralResourceName:) has not been implemented")
    }
    
    
    // MARK: - Public
    
    internal func outgoingMessagesBubbleImageWithColor(_ color: UIColor) -> ZSY_MessageBubbleImage {
        return self.zsy_messagesBubbleImageWithColor(color, flippedForIncoming: false)
    }
    
    internal func incomingMessagesBubbleImageWithColor(_ color: UIColor) -> ZSY_MessageBubbleImage {
        return self.zsy_messagesBubbleImageWithColor(color, flippedForIncoming: true)
    }
    
    
    // MARK: - Private
    
    fileprivate func zsy_centerPointEdgeInsetsForImageSize(_ bubbleImageSize: CGSize) -> UIEdgeInsets {
        let center = CGPoint(x: bubbleImageSize.width / 2.0, y: bubbleImageSize.height / 2.0)
        return UIEdgeInsets(top: center.y, left: center.x, bottom: center.y, right: center.x)
    }
    
    fileprivate func zsy_messagesBubbleImageWithColor(_ color: UIColor, flippedForIncoming: Bool) -> ZSY_MessageBubbleImage {
        var normalBubble = self.bubbleImage.zsy_imageMaskedWithColor(color)
        // TODO: 颜色算法
        var highlightedBubble = self.bubbleImage.zsy_imageMaskedWithColor(color.zsy_colorByDarkeningColorWithValue(0.4))
        
        if flippedForIncoming {
            normalBubble = zsy_horizontallyFlippedImageFormImage(normalBubble)
            highlightedBubble = zsy_horizontallyFlippedImageFormImage(highlightedBubble)
        }
        
        normalBubble = zsy_stretchableImageFromImage(normalBubble, capInsets: self.capInset!)
        highlightedBubble = zsy_stretchableImageFromImage(highlightedBubble, capInsets: self.capInset!)
        
        return ZSY_MessageBubbleImage(messageBubbleImage: normalBubble, messageBubbleHighlightedImage: highlightedBubble)
    }
    
    fileprivate func zsy_horizontallyFlippedImageFormImage(_ image: UIImage) -> UIImage {
        return UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: UIImageOrientation.upMirrored)
    }
    
    fileprivate func zsy_stretchableImageFromImage(_ image: UIImage, capInsets: UIEdgeInsets) -> UIImage {
        return image.resizableImage(withCapInsets: capInsets, resizingMode: UIImageResizingMode.stretch)
    }
}

extension UIImage {
    
    func zsy_imageMaskedWithColor(_ maskColor: UIColor) -> UIImage {
        
        var newImage: UIImage = UIImage()
        let imageRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -imageRect.size.height)
        context?.clip(to: imageRect, mask: cgImage!)
        context?.setFillColor(maskColor.cgColor)
        context?.fill(imageRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func zsy_bubbleImageFromBundleWithName(_ name: String?) -> UIImage {
        
        return UIImage(named: "ChatMessages_Bubble")!
    }
}
