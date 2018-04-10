//
//  EmptyStateView.swift
//  Github users viewer
//
//  Created by Vitaliy Bal on 4/9/18.
//  Copyright © 2018 VitaliySoft. All rights reserved.
//

import UIKit
import Foundation

class EmptyStateView: UIView {
    
    let padding: CGFloat = 16
    var imageView: UIImageView!
    var topLabel: UILabel!
    var button: UIButton!
    
    var changedTopLabel: UILabel {
        get {
            return topLabel
        }
        set {
            topLabel = newValue
        }
    }
    
    var changedButton: UIButton {
        get {
            return button
        }
        set {
            button = newValue
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    init(message: String? = nil) {
        super.init(frame: CGRect.zero)
        setupViews()
        topLabel.text = message
    }
    
    func setupViews() {
        self.backgroundColor = UIColor.gray
        
        imageView = UIImageView(frame: CGRect.zero)
        imageView.image = UIImage(named: "NoDataIcon")
        imageView.tintColor = UIColor.white
        addSubview(imageView)
        
        topLabel = UILabel(frame: CGRect.zero)
        addSubview(topLabel)
        
        button = UIButton(frame: CGRect.zero)
        button.addTarget(self, action: #selector(touchUpInsideHandler), for: UIControlEvents.touchUpInside)
        button.backgroundColor = UIColor.blue
        button.setTitle(NSLocalizedString("General:Nodata:Reload", comment: ""), for: UIControlState.normal)
        //button.contentHorizontalAlignment = .left
        button.layer.cornerRadius = 4
        addSubview(button)
        
        hide()
    }
    
    // Actions for button
    @objc func touchUpInsideHandler() {
        if let handler = self.handler {
            handler()
        }
    }
    
    open var handler: (() -> ())?
    
    // Customization of view
    func startAnimation(inView: UIView, animated: Bool) {
        
        inView.addSubview(self)
        self.frame = inView.bounds
        setNeedsLayout()
        UIView.animate(withDuration: 0.2,
                       delay: 0.3,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        self.show()
        }, completion: { (finished) -> Void in
            // completion
        })
    }
    
    func hideAnimation() {
        UIView.animate(withDuration: 0.2,
                       delay: 0.1,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: { () -> Void in
                        self.hide()
        }, completion: { (finished) -> Void in
            self.removeFromSuperview()
        })
    }
    
    private func hide() {
        imageView?.alpha = 0
        topLabel?.alpha = 0
        button?.alpha = 0
    }
    
    private func show() {
        imageView?.alpha = 1
        topLabel?.alpha = 1
        button?.alpha = 1
    }
    
    override func layoutSubviews() {
        
        imageView.size = CGSize(width: 70, height: 39)
        imageView.left = ceil(self.width / 2 - imageView.width / 2)
        imageView.top = 40
        
        topLabel.sizeToFit()
        topLabel.left = ceil(self.width / 2 - topLabel.width / 2)
        topLabel.top = imageView.bottom + 2 * padding
        
        button.size = CGSize(width: 152, height: 32)
        button.left = ceil(self.width / 2 - button.width / 2)
        button.top = topLabel.bottom + 2 * padding
        
    }
    
}
