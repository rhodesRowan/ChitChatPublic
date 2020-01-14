//
//  VideoView.swift
//  chitChat
//
//  Created by Rowan Rhodes on 07/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoView: UIView {
    
    // MARK:- Properties
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = false
    var circleLayer: CAShapeLayer?
    var shapeLayer: CAShapeLayer?
    lazy var playBtn: UIButton = {
        var playBtn = UIButton()
        playBtn.translatesAutoresizingMaskIntoConstraints = false
        playBtn.setImage(UIImage(named: "play"), for: .normal)
        playBtn.addTarget(self, action: #selector(play), for: .touchUpInside)
        return playBtn
    }()
    var thumbnailImg: UIImageView = {
       var thumbnailImg = UIImageView()
       thumbnailImg.translatesAutoresizingMaskIntoConstraints = false
       return thumbnailImg
    }()
    
    // MARK:- Lifecycle
    override func layoutSubviews() {
        self.playerLayer?.frame = bounds
    }
    
    // MARK:- Public
    public func configure(url: String, imageURL: String) {
        if let videoURL = URL(string: url) {
            self.setupThumbnailImage(imageURL: imageURL)
            self.setupPlayBtn()
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = AVLayerVideoGravity.resize
            if let playerLayer = self.playerLayer {
                self.layer.addSublayer(playerLayer)
                self.bringSubviewToFront(self.playBtn)
            }
            self.setupPlayerObservers()
        }
    }
    
    
    // MARK:- Private
    fileprivate func setupPlayerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(endOfVideoReached(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReadyToPlay(_:)), name: .AVPlayerItemNewAccessLogEntry, object: player?.currentItem)
    }
    
    fileprivate func setupThumbnailImage(imageURL: String) {
        self.addSubview(thumbnailImg)
        thumbnailImg.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        thumbnailImg.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thumbnailImg.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        thumbnailImg.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        thumbnailImg.loadImageUsingCacheWithURLString(urlString: imageURL)
    }
    
    fileprivate func setupPlayBtn() {
        self.addSubview(playBtn)
        playBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        playBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    fileprivate func setupLoadingIndicator() {
        shapeLayer = CAShapeLayer()
        let center = thumbnailImg.center
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 10, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer?.path = circularPath.cgPath
        shapeLayer?.strokeColor = ThemeManager.shared.greenColor.withAlphaComponent(0.3).cgColor
        shapeLayer?.lineWidth = 4
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.lineCap = .butt
        shapeLayer?.position = center
        shapeLayer?.transform = CATransform3DMakeRotation(-(CGFloat.pi / 2), 0, 0, 1)
        
        circleLayer = CAShapeLayer()
        circleLayer?.path = circularPath.cgPath
        circleLayer?.strokeColor = ThemeManager.shared.greenColor.cgColor
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
    
        self.layer.addSublayer(shapeLayer!)
        self.layer.addSublayer(circleLayer!)
    }
    
    @objc fileprivate func play() {
        self.playBtn.alpha = 0.0
        self.setupLoadingIndicator()
        player?.play()
    }
    
    @objc fileprivate func endOfVideoReached(_ notification: Notification) {
        player?.pause()
        player?.seek(to: .zero)
        self.playBtn.alpha = 1.0
        self.bringSubviewToFront(playBtn)
    }
    
    @objc fileprivate func playerItemDidReadyToPlay(_ notification: Notification) {
        if let _ = notification.object as? AVPlayerItem {
            // player is ready to play
            circleLayer?.removeFromSuperlayer()
            shapeLayer?.removeFromSuperlayer()
        }
    }
    
}
