//
//  LoadingContainerView.swift
//  chitChat
//
//  Created by Rowan Rhodes on 20/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

class LoadingContainerView: UIView {
    
    // MARK:- Properties
    var fillColor = UIColor.systemBackground.cgColor
    
    // MARK:- Lifecycle
    override func layoutSubviews() {
        let shapeLayer = CAShapeLayer()
        let center = self.center
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = ThemeManager.shared.greenColor.withAlphaComponent(0.3).cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.fillColor = fillColor
        shapeLayer.lineCap = .butt
        //shapeLayer.strokeEnd = 0
        shapeLayer.position = center
        shapeLayer.transform = CATransform3DMakeRotation(-(CGFloat.pi / 2), 0, 0, 1)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circularPath.cgPath
        circleLayer.strokeColor = ThemeManager.shared.greenColor.cgColor
        circleLayer.lineWidth = 4
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .butt
        circleLayer.strokeEnd = 0
        circleLayer.position = center
        circleLayer.transform = CATransform3DMakeRotation(-(CGFloat.pi / 2), 0, 0, 1)
        
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.toValue = 1.5
        pulseAnimation.duration = 0.5
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        circleLayer.add(pulseAnimation, forKey: "pulseanimation")
        shapeLayer.add(pulseAnimation, forKey: "pulseAnimation")
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1.1
        basicAnimation.duration = 1
        basicAnimation.repeatCount = .infinity
        circleLayer.add(basicAnimation, forKey: "loading")
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(circleLayer)
    }
}
