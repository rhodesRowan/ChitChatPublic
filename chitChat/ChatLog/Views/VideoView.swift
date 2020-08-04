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
    lazy var playButton: UIButton = {
        var playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addTarget(self, action: #selector(play), for: .touchUpInside)
        return playButton
    }()
    var thumbnailImageView: UIImageView = {
       var thumbnailImageView = UIImageView()
       thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
       return thumbnailImageView
    }()
    
    // MARK:- Lifecycle
    override func layoutSubviews() {
        self.playerLayer?.frame = bounds
    }
    
    // MARK:- Public
    public func configure(url: String, imageURL: String) {
        if let videoURL = URL(string: url) {
            self.setupThumbnailImage(imageURL: imageURL)
            self.setupPlayButton()
            player = AVPlayer(url: videoURL)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.videoGravity = AVLayerVideoGravity.resize
            if let playerLayer = self.playerLayer {
                self.layer.addSublayer(playerLayer)
                self.bringSubviewToFront(self.playButton)
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
        self.addSubview(thumbnailImageView)
        thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        thumbnailImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        thumbnailImageView.loadImageUsingCacheWithURLString(urlString: imageURL)
    }
    
    fileprivate func setupPlayButton() {
        self.addSubview(playButton)
        playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    fileprivate func setupLoadingIndicator() {
        shapeLayer = CAShapeLayer()
        let center = thumbnailImageView.center
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
        self.playButton.alpha = 0.0
        self.setupLoadingIndicator()
        player?.play()
    }
    
    @objc fileprivate func endOfVideoReached(_ notification: Notification) {
        player?.pause()
        player?.seek(to: .zero)
        self.playButton.alpha = 1.0
        self.bringSubviewToFront(playButton)
    }
    
    @objc fileprivate func playerItemDidReadyToPlay(_ notification: Notification) {
        if let _ = notification.object as? AVPlayerItem {
            // player is ready to play
            circleLayer?.removeFromSuperlayer()
            shapeLayer?.removeFromSuperlayer()
        }
    }
    
}
