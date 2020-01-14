//
//  ChatBubbleMediaProtocol.swift
//  chitChat
//
//  Created by Rowan Rhodes on 20/12/2019.
//  Copyright © 2019 Rowan Rhodes. All rights reserved.
//

import UIKit

protocol ChatBubbleMediaProtocol: AnyObject {
    // MARK:- Delegate Methods
    func imageViewWasTapped(imageView: UIImageView, aspectRatio: Double)
    func videoViewWasTapped(videoURL: URL, aspectRatio: Double, videoView: VideoView, thumbnailURL: URL)
}
