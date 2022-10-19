//
//  CreatePostViewController.swift
//  News Feed
//
//  Created by Shahzaib Mumtaz on 21/06/2022.
//

import UIKit
import YPImagePicker
import AVKit

protocol SocialFeedData: AnyObject {
    func RefreshSocialFeeds()
}

class CreatePostViewController: UIViewController {
    
    //************************************************//
    // MARK:- Creating Outlets.
    //************************************************//
    
    @IBOutlet weak var txtCreatePostView:UITextView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var btnPhotoVideo:UIButton!
    
    //************************************************//
    // MARK: Creating properties.
    //************************************************//
    
    var selectedItems = [YPMediaItem]()
    var modelSocialFeed = SocialFeedModel()
    
    var socialFeedInstance = SocialFeedDataModel.sharedInstance
    
    weak var delegate: SocialFeedData?
    
    //************************************************//
    // MARK:- View life Cycle
    //************************************************//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.isHidden = true
        collectionView.register(UINib(nibName: "SocialFeedImageCell", bundle: nil),
                                forCellWithReuseIdentifier: "SocialFeedImageCell")
        
        txtCreatePostView.delegate = self
    }
    
    //************************************************//
    // MARK:- IBActions methods.
    //************************************************//
    
    @IBAction func btnPhotoVideoTapped(sender: UIButton) {
        showPicker()
    }
    
    //************************************************//
    
    @IBAction func btnDoneTapped(sender: UIBarButtonItem) {
        
        guard let txt = txtCreatePostView.text else { return }
        modelSocialFeed.title = txt
        modelSocialFeed.id = "\(socialFeedInstance.arrSocialFeed.count + 1)"
        socialFeedInstance.arrSocialFeed.append(modelSocialFeed)
        delegate?.RefreshSocialFeeds()
        self.navigationController?.popViewController(animated: true)
    }
    
    //************************************************//
}

// YPImagePicker Configuration

extension CreatePostViewController {
    
    //************************************************//
    // MARK:- Custom methods.
    //************************************************//
    
    @objc func showPicker() {
        
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.library.itemOverlayType = .grid
        config.shouldSaveNewPicturesToAlbum = false
        config.video.compression = AVAssetExportPresetPassthrough
        config.startOnScreen = .library
        config.screens = [.library, .photo, .video]
        config.library.minWidthForItem = UIScreen.main.bounds.width * 0.8
        config.video.libraryTimeLimit = 500.0
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.maxCameraZoomFactor = 2.0
        config.library.maxNumberOfItems = 5
        config.gallery.hidesRemoveButton = false
        config.library.preselectedItems = selectedItems
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [weak picker] items, cancelled in
            
            if cancelled {
                print("Picker was canceled")
                picker?.dismiss(animated: true, completion: nil)
                return
            }
            _ = items.map { print("🧀 \($0)") }
            
            self.selectedItems = items
            
            for item in items {
                switch item {
                case .photo(let photo):
                    self.modelSocialFeed.media.append(MedialModel(mediatype: .photo,
                                                                  thumbnail: photo.image,
                                                                  url: ""))
                case .video(let video):
                    self.modelSocialFeed.media.append(MedialModel(mediatype: .video,
                                                                  thumbnail: video.thumbnail,
                                                                  url: "\(video.url)"))
                }
            }
            picker?.dismiss(animated: true) {
                self.collectionView.isHidden = false
                self.collectionView.reloadData()
            }
        }
        present(picker, animated: true, completion: nil)
    }
    
    //************************************************//
}

extension CreatePostViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    //************************************************//
    // MARK:- UICollectionView Delegate & DateSource.
    //************************************************//
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        modelSocialFeed.media.count
    }
    
    //************************************************//
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialFeedImageCell", for: indexPath) as? SocialFeedImageCell else { return UICollectionViewCell() }
        cell.FeedImage.image = modelSocialFeed.media[indexPath.row].thumbnail
        return cell
    }
    
    //************************************************//
}

extension CreatePostViewController: UICollectionViewDelegateFlowLayout {
    
    //************************************************//
    // MARK:- UICollectionView DelegateFlowLayout
    //************************************************//
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height)
    }
    
    //************************************************//
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        1
    }
    
    //************************************************//
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    //************************************************//
}

extension CreatePostViewController {
    
    static func shareInstance() -> CreatePostViewController {
        CreatePostViewController.instantiateFromStoryboard()
    }
}

extension CreatePostViewController: UITextViewDelegate {
    
    //************************************************//
    // MARK:- TextView Delegate
    //************************************************//
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        txtCreatePostView.text = ""
    }
    
    //************************************************//
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtCreatePostView.text == "" {
            txtCreatePostView.text = "What's on your mind?"
        }
    }
    
    //************************************************//
}
