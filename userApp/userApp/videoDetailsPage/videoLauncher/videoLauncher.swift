////
////  videoLauncher.swift
////  userApp
////
////  Created by Kihyun Choi on 29/08/2019.
////  Copyright © 2019 sfo. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//
//
//class VideoPlayerView: UIView {
//
//    var player: AVPlayer?
//
//    var isPlaying:Bool = false
//    var controllViewIsHidden:Bool = false
//    var isFullScreen:Bool = false
//
//    let windowView = UIApplication.shared.keyWindow!
//
//    let fullScreenView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        return view
//    }()
//
//    let fullScreenButton:UIButton = {
//        let button = UIButton(type: .system)
//        let image = UIImage(named: "playyy")
//        button.setImage(image, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("전체화면", for: .normal)
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(setFullScreen), for: .touchUpInside)
//        return button
//    }()
//
//    let activityIndicatorView: UIActivityIndicatorView = {
//        let aiv = UIActivityIndicatorView(style: .whiteLarge)
//        aiv.translatesAutoresizingMaskIntoConstraints = false
//        aiv.startAnimating()
//        return aiv
//    }()
//
//    let controlsContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(white: 0, alpha: 1)
//        return view
//    }()
//    lazy var pausePlayButton: UIButton = {
//        let button = UIButton(type: .system)
//        let image = UIImage(named: "pause")
//        button.setImage(image, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.tintColor = .white
//        button.isHidden = true
//        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
//
//        return button
//    }()
//    let videoLengthLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "00:00"
//        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.textAlignment = .right
//        return label
//    }()
//    lazy var videoSlider: UISlider = {
//        let slider = UISlider()
//        slider.translatesAutoresizingMaskIntoConstraints = false
//        slider.minimumTrackTintColor = .red
//        slider.maximumTrackTintColor = .white
//        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
//
//        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
//
//        return slider
//    }()
//    let currentTimeLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = "00:00"
//        label.textColor = .white
//        label.font = UIFont.boldSystemFont(ofSize: 13)
//        return label
//    }()
//
//    @objc func handlePause() {
//        if isPlaying {
//            player?.pause()
//            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
//        } else {
//            player?.play()
//            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
//        }
//        isPlaying = !isPlaying
//        showOrHideControllView()
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupPlayerView()
//
//        controlsContainerView.frame = frame
//        print("controlsContainerView: ",controlsContainerView.frame.width)
//        addSubview(controlsContainerView)
//
//        controlsContainerView.addSubview(activityIndicatorView)
//        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//        controlsContainerView.addSubview(pausePlayButton)
//        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        backgroundColor = .black
//
//        controlsContainerView.addSubview(videoLengthLabel)
//        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
//        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
//
//        controlsContainerView.addSubview(currentTimeLabel)
//        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
//        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
//
//        controlsContainerView.addSubview(videoSlider)
//        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
//        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
//        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        videoSlider.thumbTintColor = .red
//
//        controlsContainerView.addSubview(fullScreenButton)
//        fullScreenButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
//        fullScreenButton.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
//        fullScreenButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        fullScreenButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
//
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(showOrHideControllView))
//        self.addGestureRecognizer(gesture)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    @objc private func showOrHideControllView() {
//        if controllViewIsHidden == true {
//            showControllView()
//            hideControllView()
//        } else {
//            hideControllView()
//        }
//    }
//
//    @objc private func setFullScreen() {
//        if isFullScreen {
//            fullScreenView.removeFromSuperview()
//            self.transform = CGAffineTransform(rotationAngle: 0 ) // 원래대로
//            self.frame = originalView.bounds
//            if let sublayers = self.layer.sublayers {
//                for layer in sublayers {
//                    layer.frame = self.bounds
//                }
//            }
//
//        } else {
//            fullScreenView.frame = windowView.frame
//            windowView.insertSubview(fullScreenView, aboveSubview: windowView)
//            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2 )
//            self.frame = fullScreenView.bounds
//
//            if let sublayers = self.layer.sublayers {
//                for layer in sublayers {
//                    layer.frame = self.bounds
//                }
//            }
//            windowView.insertSubview(self, aboveSubview: fullScreenView)
//        }
//        isFullScreen = !isFullScreen
//    }
//
//    private func showControllView() {
//        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
//            self.controlsContainerView.alpha = 1.0
//        }, completion:  {
//            (value: Bool) in
//            self.controlsContainerView.isHidden = false
//            self.controllViewIsHidden = false
//        })
//    }
//
//    private func hideControllView() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
//                self.controlsContainerView.alpha = 0.0
//            }, completion:  {
//                (value: Bool) in
//                self.controlsContainerView.isHidden = true
//                self.controllViewIsHidden = true
//            })
//        }
//    }
//
//    private func setupPlayerView() {
//        let urlString = videoURL
//        if let url = NSURL(string: urlString) {
//
//            player = AVPlayer(url: url as URL)
//            let playerLayer = AVPlayerLayer(player: player)
//            self.layer.addSublayer(playerLayer)
//            playerLayer.frame = self.frame
//            player?.play()
//            showOrHideControllView()
//            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
//
//            //track player progress
//            let interval = CMTime(value: 1, timescale: 2)
//            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
//
//                let seconds = CMTimeGetSeconds(progressTime)
//                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60))) // seconds % 60
//                let minutesString = String(format: "%02d", Int(seconds / 60))
//
//                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
//
//                //lets move the slider thumb
//                if let duration = self.player?.currentItem?.duration {
//                    let durationSeconds = CMTimeGetSeconds(duration)
//
//                    self.videoSlider.value = Float(seconds / durationSeconds)
//                }
//            })
//        }
//    }
//
//    private func setupGradientLayer() {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = bounds
//        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//        gradientLayer.locations = [0.7, 1.2]
//        controlsContainerView.layer.addSublayer(gradientLayer)
//    }
//
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        //this is when the player is ready and rendering frames
//        if keyPath == "currentItem.loadedTimeRanges" {
//            activityIndicatorView.stopAnimating()
//            controlsContainerView.backgroundColor = .clear
//            pausePlayButton.isHidden = false
//            isPlaying = true
//            if let duration = player?.currentItem?.duration {
//                let seconds = CMTimeGetSeconds(duration)
//
//                let secondsText = Int(seconds) % 60
//                let minutesText = String(format: "%02d", Int(seconds) / 60)
//                videoLengthLabel.text = "\(minutesText):\(secondsText)"
//            }
//
//        }
//    }
//
//    @objc func handleSliderChange() {
//        print(videoSlider.value)
//        if let duration = player?.currentItem?.duration {
//            let totalSeconds = CMTimeGetSeconds(duration)
//            let value = Float64(videoSlider.value) * totalSeconds
//            let seekTime = CMTime(value: Int64(value), timescale: 1)
//            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
//
//            })
//        }
//        showOrHideControllView()
//    }
//}
