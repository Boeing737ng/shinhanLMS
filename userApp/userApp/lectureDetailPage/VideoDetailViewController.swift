//
//  VideoDetailViewController.swift
//  userApp
//
//  Created by Kihyun Choi on 20/08/2019.
//  Copyright © 2019 sfo. All rights reserved.
//

//DATABASE READ::-----
//Video Info
//- Everything about selected video

import UIKit
import Firebase
import AVKit

var selectedVideoId:String = ""
var selectedLectureId:String = ""
var videoURL:String = ""

class VideoDetailViewController: UIViewController {

    @IBOutlet weak var videoView: UIView!
    let notificationCenter = NotificationCenter.default
    
    var videoProgress:Float = 0.0
    var playerView:UIView = UIView()
    var player:AVPlayer?
    var isPlaying:Bool = false
    var controllViewIsHidden:Bool = false
    var isFullScreen:Bool = false
    var userLectureList = Array<String>()
    
    let windowView = UIApplication.shared.keyWindow!
    
    let fullScreenView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let fullScreenButton:UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "fullScreen")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("전체화면", for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(setFullScreen), for: .touchUpInside)
        return button
    }()
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        
        return slider
    }()
    let currentTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(startVideoPlayer), name: NSNotification.Name(rawValue: "videoSelected"), object: nil)
        isLectureFirstTime()
        //getVideoInfoFromDB()
        //userDidStartWatching()
    }
    
    @objc private func startVideoPlayer() {
        player = AVPlayer()
        playerView.removeFromSuperview()
        playerView = UIView()
        showVideoPlayer()
        initVideoPlayer()
    }
    
    func showVideoPlayer() {
        if let keyWindow = UIApplication.shared.keyWindow {
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            playerView.frame = videoPlayerFrame
            videoView.insertSubview(playerView, at: 0)
        }
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
        //userDidFinishWatching()
    }
    
    @IBAction func onGoBack(_ sender: UIBarButtonItem) {
        //userDidFinishWatching()
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }

//    private func userDidFinishWatching() {
//        var currentState:String = ""
//        if videoProgress == 1 {
//            currentState = "completed"
//        } else {
//            currentState = "playing"
//        }
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        ref.child("user/" + userNo + "/playList/" + selectedLectureId).updateChildValues([
//            "progress": videoProgress,
//            "state": currentState
//            ]
//        )
//    }
//
    private func userDidStartWatching() {
        if userLectureList.contains(selectedLectureId) {
            
        } else {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            ref.child(userCompanyCode + "/lecture/" + selectedLectureId + "/user/" + userNo).setValue([
                "name": userName
                ])
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                ref.child("user/" + userNo + "/playList/" + selectedLectureId).updateChildValues([
                    "progress": 0.0,
                    "state": "playing"
                    ]
                )
                ref.child("user/" + userNo + "/playList/" + selectedLectureId).observeSingleEvent(of: .value, with: { (snapshot) in
                    let videoInfo = snapshot.value as! Dictionary<String, Any>;()
                    for video in videoInfo {
                        let videoId = video.key
                        ref.child("user/" + userNo + "/playList/" + selectedLectureId + "/videos/" + videoId).updateChildValues([
                            "progress": 0.0,
                            "state": "playing"
                            ]
                        )
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func isLectureFirstTime() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("user/" + userNo + "/playList").observeSingleEvent(of: .value, with: { (snapshot) in
            let videoInfo = snapshot.value as! Dictionary<String, Any>;()
            for video in videoInfo {
                self.userLectureList.append(video.key)
            }
            print(self.userLectureList)
            self.userDidStartWatching()
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    func getVideoInfoFromDB() {
        LoadingView().startLoading(self)
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(userCompanyCode + "/lecture/" + selectedLectureId).observeSingleEvent(of: .value, with: { (snapshot) in
            let videoInfo = snapshot.value as! Dictionary<String, Any>;()
            videoURL = videoInfo["downloadURL"] as! String
            LoadingView().stopLoading()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    @IBAction func seg(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
//            self.segView.addSubview()
        }
        else if sender.selectedSegmentIndex == 1 {
        }
        else if sender.selectedSegmentIndex == 2 {
        }
    }
    func initVideoPlayer() {
        setupPlayerView()
        
        controlsContainerView.frame = playerView.frame
        playerView.addSubview(controlsContainerView)
        playerView.backgroundColor = .black
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: playerView.centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: playerView.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(fullScreenButton)
        fullScreenButton.rightAnchor.constraint(equalTo: playerView.rightAnchor, constant: -8).isActive = true
        fullScreenButton.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -2).isActive = true
        fullScreenButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        fullScreenButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: fullScreenButton.leftAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -5).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: playerView.leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -5).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: 10).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: playerView.bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 35).isActive = true
        videoSlider.thumbTintColor = .red
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showOrHideControllView))
        playerView.addGestureRecognizer(gesture)
    }
    
    @objc private func showOrHideControllView() {
        if controllViewIsHidden == true {
            showControllView()
            hideControllView()
        } else {
            hideControllView()
        }
    }
    
    private func setFullScreenConstraint() {
        fullScreenButton.rightAnchor.constraint(equalTo: playerView.rightAnchor, constant: -25).isActive = true
        fullScreenButton.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -2).isActive = true
        fullScreenButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        fullScreenButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        videoLengthLabel.rightAnchor.constraint(equalTo: fullScreenButton.leftAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -5).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        currentTimeLabel.leftAnchor.constraint(equalTo: playerView.leftAnchor, constant: 25).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: playerView.bottomAnchor, constant: -5).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor, constant: 10).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: playerView.bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 35).isActive = true
        videoSlider.thumbTintColor = .red
    }
    
    @objc private func setFullScreen() {
        if isFullScreen {
            fullScreenView.removeFromSuperview()
            playerView.transform = CGAffineTransform(rotationAngle: 0 ) // 원래대로
            playerView.frame = videoView.bounds
            if let sublayers = playerView.layer.sublayers {
                for layer in sublayers {
                    layer.frame = playerView.bounds
                }
            }
            videoView.insertSubview(playerView, at: 0)
        } else {
            fullScreenView.frame = windowView.frame
            windowView.insertSubview(fullScreenView, aboveSubview: windowView)
            playerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2 )
            playerView.frame = fullScreenView.bounds
            if let sublayers = playerView.layer.sublayers {
                for layer in sublayers {
                    layer.frame = playerView.bounds
                }
            }
            setFullScreenConstraint()
            windowView.insertSubview(playerView, aboveSubview: fullScreenView)
            fullScreenButton.removeTarget(self, action: #selector(setFullScreen), for: .touchUpInside)
            fullScreenButton.addTarget(self, action: #selector(setFullScreen), for: .touchUpInside)
        }
        isFullScreen = !isFullScreen
    }
    
    private func showControllView() {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: {
            self.controlsContainerView.alpha = 1.0
        }, completion:  {
            (value: Bool) in
            self.controlsContainerView.isHidden = false
            self.controllViewIsHidden = false
        })
    }
    
    private func hideControllView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.controlsContainerView.alpha = 0.0
            }, completion:  {
                (value: Bool) in
                self.controlsContainerView.isHidden = true
                self.controllViewIsHidden = true
            })
        }
    }
    
    private func setupPlayerView() {
        let urlString = videoURL
        if let url = NSURL(string: urlString) {
            
            player = AVPlayer(url: url as URL)
            let playerLayer = AVPlayerLayer(player: player)
            playerView.layer.addSublayer(playerLayer)
            playerLayer.frame = playerView.frame
            player?.play()
            showOrHideControllView()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //track player progress
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                
                let seconds = CMTimeGetSeconds(progressTime)
                let secondsString = String(format: "%02d", Int(seconds.truncatingRemainder(dividingBy: 60))) // seconds % 60
                let minutesString = String(format: "%02d", Int(seconds / 60))
                
                self.currentTimeLabel.text = "\(minutesString):\(secondsString)"
                
                //lets move the slider thumb
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    let runningPercentage = Float(seconds / durationSeconds)
                    self.videoSlider.value = runningPercentage
                    self.videoProgress = runningPercentage
                }
            })
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        //gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
            
        }
    }
    
    @objc func handleSliderChange() {
        //print(videoSlider.value)
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                
            })
        }
        showOrHideControllView()
    }
    
    @objc func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
        showOrHideControllView()
    }
}

