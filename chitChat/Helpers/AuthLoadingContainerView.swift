//
//  LoadingContainerView.swift
//  chitChat
//
//  Created by Rowan Rhodes on 08/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit

class AuthLoadingContainerView: UIView {

    // MARK:- Properties
    var shapeLayer: CAShapeLayer!
    var circleLayer: CAShapeLayer!
    var loadingLabel: UILabel = {
       var loadingLabel = UILabel()
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.textColor = UIColor.label
        loadingLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return loadingLabel
    }()
    
    // MARK:- Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLoadingIndicator()
        self.backgroundColor = UIColor.secondarySystemBackground
        self.alpha = 0.8
        self.layer.cornerRadius = 10
        self.setupLoadingIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Public
    public func configureLabel(labelText: String) {
        self.setupLabel()
        self.loadingLabel.text = labelText
    }
    
    // MARK:- Private
    fileprivate func setupLabel() {
        self.addSubview(loadingLabel)
        loadingLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        loadingLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
    
    fileprivate func setupLoadingIndicator() {
        shapeLayer = CAShapeLayer()
        let center = self.center
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer?.path = circularPath.cgPath
        shapeLayer?.strokeColor = UIColor.systemGreen.withAlphaComponent(0.3).cgColor
        shapeLayer?.lineWidth = 4
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.lineCap = .butt
        shapeLayer?.position = center
        shapeLayer?.transform = CATransform3DMakeRotation(-(CGFloat.pi / 2), 0, 0, 1)
        
        circleLayer = CAShapeLayer()
        circleLayer?.path = circularPath.cgPath
        circleLayer?.strokeColor = UIColor.systemGreen.cgColor
        circleLayer?.lineWidth = 4
        circleLayer?.fillColor = UIColor.clear.cgColor
        circleLayer?.lineCap = .butt
        circleLayer?.strokeEnd = 0
        circleLayer?.position = center
        circleLayer?.transform = CATransform3DMakeRotation(-(CGFloat.pi / 2), 0, 0, 1)
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.toValue = 1.5
        pulseAnimation.duration = 0.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        circleLayer?.add(pulseAnimation, forKey: "pulseanimation")
        shapeLayer?.add(pulseAnimation, forKey: "pulseAnimation")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1.1
        basicAnimation.duration = 1
        basicAnimation.repeatCount = .infinity
        circleLayer?.add(basicAnimation, forKey: "loading")
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(circleLayer)
    }
    
    
}
