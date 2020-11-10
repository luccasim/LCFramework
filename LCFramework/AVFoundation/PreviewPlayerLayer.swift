//
//  PreviewPlayerLayer.swift
//  LCFramework
//
//  Created by owee on 12/10/2020.
//  Copyright © 2020 Devios. All rights reserved.
//

import AVFoundation
import SwiftUI

struct PlayerView : UIViewRepresentable {
    
    let url : URL
    var previewLengh:Double?
    
    init(Url:URL) {
        self.url = Url
    }

    func makeUIView(context: Context) -> MyPreviewPlayer {
        let view = MyPreviewPlayer(Frame: .zero, Url: self.url, PreviewLengh: nil)
        return view
    }
    
    func updateUIView(_ uiView: MyPreviewPlayer, context: Context) {
        
    }
    
    class MyPreviewPlayer : UIView {
        
        private let playerLayer = AVPlayerLayer()
        private let player = AVPlayer()
        private var timer : Timer?
        var previewLength : Double?
        
        init(Frame: CGRect, Url:URL, PreviewLengh:Double?) {
            
            self.previewLength = PreviewLengh
            super.init(frame: Frame)
            
            self.player.replaceCurrentItem(with: AVPlayerItem(url: Url))
            
            self.playerLayer.player = player
            self.playerLayer.videoGravity = .resizeAspect
            self.playerLayer.backgroundColor = UIColor.black.cgColor
            
            self.player.play()
            
            layer.addSublayer(playerLayer)
        }
        
        required init?(coder: NSCoder) {
            self.previewLength = 15
            super.init(coder: coder)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            playerLayer.frame = bounds
        }
    }
}
