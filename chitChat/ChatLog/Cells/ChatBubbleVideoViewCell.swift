//
//  ChatBubbleImageViewCell.swift
//  chitChat
//
//  Created by Rowan Rhodes on 19/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit
import AVFoundation

var chatBubbleVideoCellID = "chatBubbleVideoCellID"

class chatBubbleVideoCell: ChatBubbleBaseCell {
    
    // MARK:- Properties
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    weak var delegate: ChatBubbleMediaProtocol?
    var chatMessage: VideoMessage! {
        didSet {
            textBubbleView.backgroundColor = chatMessage.isIncoming ? .white : .darkGray
            if chatMessage.isIncoming == true {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            } else {
                trailingConstraint.isActive = true
                leadingConstraint.isActive = false
            }
            self.setupMessageImage(photoURL: chatMessage.thumbnailURL, aspectRatio: CGFloat(chatMessage.thumbnailAspect), videoURL: chatMessage.videoURL)
        }
    }
    
    lazy var videoView: VideoView = {
       var videoView = VideoView()
       videoView.translatesAutoresizingMaskIntoConstraints = false
       let tap = UITapGestureRecognizer(target: self, action: #selector(videoWasTapped))
       tap.numberOfTapsRequired = 1
       videoView.addGestureRecognizer(tap)
       return videoView
    }()
    
    // MARK:- Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(videoView)
        
        // add message image constraints
        videoView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        videoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32).isActive = true
        videoView.widthAnchor.constraint(equalToConstant: 150).isActive = true
    
        
        
        // set alignment for message
        self.leadingConstraint = videoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        self.trailingConstraint = videoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        // add bubble view constraints
        self.textBubbleView.topAnchor.constraint(equalTo: self.videoView.topAnchor, constant: -8).isActive = true
        self.textBubbleView.bottomAnchor.constraint(equalTo: self.videoView.bottomAnchor, constant: 8).isActive = true
        self.textBubbleView.leadingAnchor.constraint(equalTo: self.videoView.leadingAnchor, constant: -8).isActive = true
        self.textBubbleView.trailingAnchor.constraint(equalTo: self.videoView.trailingAnchor, constant: 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:- Public
    func setupMessageImage(photoURL: String, aspectRatio: CGFloat, videoURL: String) {
        self.videoView.configure(url: videoURL, imageURL: photoURL)
        self.videoView.heightAnchor.constraint(equalTo: self.videoView.widthAnchor, multiplier: aspectRatio).isActive = true
    }

    @objc func videoWasTapped() {
        delegate?.videoViewWasTapped(videoURL: URL(string: chatMessage!.videoURL)!, aspectRatio: chatMessage!.thumbnailAspect, videoView: self.videoView, thumbnailURL: URL(string: chatMessage!.thumbnailURL)!)
    }
    

}
