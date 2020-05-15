//
//  ViewController.swift
//  AVAssetDownloadURLSession_UnableToPlay
//
//  Created by Mackode - Bartlomiej Makowski on 15/05/2020.
//  Copyright © 2020 pl.mackode. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import AVFoundation

class ViewController: UIViewController, AVAssetDownloadDelegate {

    var sessionConfiguration: URLSessionConfiguration? = nil
    var downloadSession: AVAssetDownloadURLSession? = nil
    var asset: AVURLAsset? = nil

    @IBOutlet weak var action: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        sessionConfiguration = URLSessionConfiguration.background(withIdentifier: "test1234")
        downloadSession = AVAssetDownloadURLSession(configuration: sessionConfiguration!, assetDownloadDelegate: self, delegateQueue: nil)
    }

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        print("didFinishDownloadingTo", location)
    }

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        print("assetDownloadTask didLoad timeRange", timeRange)
    }

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didResolve resolvedMediaSelection: AVMediaSelection) {
        print("didResolve resolvedMediaSelection", resolvedMediaSelection)
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, willDownloadTo location: URL) {
        print("willDownloadTo", location)
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didCompleteFor mediaSelection: AVMediaSelection) {
        print("didCompleteFor mediaSelection", mediaSelection)
        DispatchQueue.main.async {
            self.action.setTitle("Play", for: .normal)
        }
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange, for mediaSelection: AVMediaSelection) {
        print("aggregateAssetDownloadTask didLoad timeRange", timeRange.end.value, timeRangeExpectedToLoad.end.value)
    }

    @IBAction func actionButton(_ sender: Any) {
        let button = sender as! UIButton

        if button.currentTitle == "Download" {
            asset = AVURLAsset(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!)

            /*
            asset.allMediaSelections.forEach { mediaSelection in
                let audioOption = mediaSelection.selectedMediaOption(in: asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)!)
                let subtitleOption = mediaSelection.selectedMediaOption(in: asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)!)
                print(">>", mediaSelection, "\n", audioOption, "\n", subtitleOption, "\n")
            }
            */

            /*
            let audioOption = asset.preferredMediaSelection.selectedMediaOption(in: asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)!)
            let subtitleOption = asset.preferredMediaSelection.selectedMediaOption(in: asset.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)!)
            print("pref >>", asset.preferredMediaSelection, "\n", audioOption, "\n", subtitleOption, "\n")
            */

            //[self.mediaSelection selectMediaOption:option inMediaSelectionGroup:self.audioTracks];
            //[self.mediaSelection selectMediaOption:option inMediaSelectionGroup:self.subtitleTracks];

            let defaultSelection = asset!.preferredMediaSelection.mutableCopy() as! AVMutableMediaSelection
            defaultSelection.select(nil, in: asset!.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.legible)!)
            defaultSelection.select(nil, in: asset!.mediaSelectionGroup(forMediaCharacteristic: AVMediaCharacteristic.audible)!)

            let downloadTask = downloadSession?.aggregateAssetDownloadTask(with: asset!, mediaSelections: [defaultSelection, asset!.allMediaSelections[5]], assetTitle: "BipBop", assetArtworkData: nil, options: [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: 10_000])

            downloadTask?.resume()
        } else if button.currentTitle == "Play" {
            let playerItem = AVPlayerItem(asset: asset!)
            let player = AVPlayer(playerItem: playerItem)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
}

