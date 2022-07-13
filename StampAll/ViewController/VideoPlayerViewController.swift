//
//  VideoPlayerViewController.swift
//  StampAll
//
//  Created by Дмитро  on 06.07.2022.
//

import UIKit
import AVFoundation
import AVKit
import Combine

class VideoPlayerViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet private weak var videoPlayerView: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var videoDurationLabel: UILabel!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var timeSlider: UISlider!
    
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    let timer = Timer.publish(every: 0.5, on: RunLoop.main, in: .common)
    
    var isVideoPlaying = false
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!
        player = AVPlayer(url: url)
        //        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new,.initial], context: nil)
        //        addTimeObserver()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resize
        videoPlayerView.layer.addSublayer(playerLayer)
        
        timeSlider.isContinuous = true
        
        
        timeSlider!
            .publisher(for: \.value)
            .sink { value in
                
                let cmTime = CMTimeMake(value: Int64(self.timeSlider.value * 1000), timescale: 1000)
                self.player.seek(to: cmTime)
            }
            .store(in: &cancellables)
//
//                timeSlider
//                    .publisher(for: .valueChanged)
//                    .sink(receiveValue: { _ in
//                        print(self.timeSlider.value)
//                        self.player.seek(to: CMTimeMake(value: Int64(self.timeSlider.value * 1000), timescale: 1000))
//
//                    })
//                    .store(in: &cancellables)

        player.currentItem?
            .publisher(for: \.duration)
            .map(\.seconds)
            .filter({ $0 > 0 })
            .sink(receiveValue: { value in
                let time = CMTimeMake(value: Int64(value*1000) , timescale: 1000)
                self.videoDurationLabel.text = self.getTimeString(from: time)
            })
            .store(in: &cancellables)
        
        timer
            .autoconnect()
            .sink { _ in
                self.currentTimeLabel.text = self.getTimeString(from: self.player.currentItem!.currentTime())
            }
            .store(in: &cancellables)
        
        //        player.currentItem?.publisher(for: \.currentSeconds)
        //            .map({ $0.seconds })
        //            .sink(receiveValue: { value in
        //                print(value)
        //            })
        //            .store(in: &cancellables)
    }
    
    
    
    @IBAction private func playPressed(_ sender: UIButton) {
        if isVideoPlaying {
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            player.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            print(CMTimeGetSeconds(player.currentTime()))
        }
        isVideoPlaying.toggle()
    }
    
    @IBAction private func sliderValueChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value * 1000), timescale: 1000))
    }
    
    
    @IBAction func forwardPressed(_ sender: Any) {
        guard let duration = player.currentItem?.duration else {return}
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 5.0
        if newTime < (CMTimeGetSeconds(duration) - 5.0) {
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000) , timescale: 1000)
            player.seek(to: time)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.play()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = videoPlayerView.bounds
    }
    
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self]
            time in
            guard let currentItem =  self?.player.currentItem else { return }
            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
        })
    }
    
    //        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //            if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
    //                self.videoDurationLabel.text = getTimeString(from: player.currentItem!.duration)
    //            }
    //        }
    
    func getTimeString(from time: CMTime)  -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int (totalSeconds/3600)
        let minutes = Int (totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes, seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
}

