//
//  ChatLogViewModel+BubbleMediaProtocol.swift
//  chitChat
//
//  Created by Rowan Rhodes on 06/01/2020.
//  Copyright © 2020 Rowan Rhodes. All rights reserved.
//

import AVFoundation
import UIKit

extension ChatLogViewModel: ChatBubbleMediaProtocol {
    
    // MARK:- ChatBubbleMedia Delegate Methods
    func videoViewWasTapped(videoURL: URL, aspectRatio: Double, videoView: VideoView, thumbnailURL: URL) {
        self.startingFrame = videoView.superview?.convert(videoView.frame, to: nil)
        let zoominPlayerView = VideoView()
        zoominPlayerView.contentMode = .scaleAspectFit
        zoominPlayerView.frame = self.startingFrame!
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(tapGesture:)))
        zoominPlayerView.isUserInteractionEnabled = true
        zoominPlayerView.addGestureRecognizer(tap)
        zoominPlayerView.configure(url: videoURL.absoluteString, imageURL: thumbnailURL.absoluteString)
        
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            backgroundView = UIView(frame: keyWindow.frame)
            backgroundView!.backgroundColor = ThemeManager.shared.bgColor
            backgroundView!.alpha = 0
            keyWindow.addSubview(backgroundView!)
            keyWindow.addSubview(zoominPlayerView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.backgroundView!.alpha = 1
                zoominPlayerView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.width * CGFloat(aspectRatio))
                zoominPlayerView.center = keyWindow.center
            }) { (completed) in
                print("completed")
            }
        }
    }
    
    func imageViewWasTapped(imageView: UIImageView, aspectRatio: Double) {
        self.startingFrame = imageView.superview?.convert(imageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: self.startingFrame!)
        zoomingImageView.image = imageView.image
        zoomingImageView.contentMode = .scaleAspectFit
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleZoomOut(tapGesture:)))
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(tap)
        
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            backgroundView = UIView(frame: keyWindow.frame)
            backgroundView!.backgroundColor = ThemeManager.shared.bgColor
            backgroundView!.alpha = 0
            
            keyWindow.addSubview(backgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.backgroundView!.alpha = 1
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.width * CGFloat(aspectRatio))
                zoomingImageView.center = keyWindow.center
            }) { (completed) in
                print("completed")
            }
        }
    }
    
    // MARK:- Private
    @objc fileprivate func playVideo() {
        playButton!.isHidden = true
        player!.play()
    }
    
    @objc fileprivate func playerDidFinishPlaying(sender: Notification) {
        // video is now finished playing, show the play button so user has the option to play the video again
        self.playButton.isHidden = false
    }
    
    @objc fileprivate func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.backgroundView?.alpha = 0
            }) { (completed) in
                zoomOutImageView.removeFromSuperview()
            }
        }
    }
}
