//
//  SocialFeedCell.swift
//  News Feed
//
//  Created by Shahzaib Mumtaz on 22/06/2022.
//

import UIKit
import Lightbox

class SocialFeedCell: UITableViewCell {
    
    //************************************************//
    // MARK:- Creating Outlets.
    //************************************************//
    
    @IBOutlet weak var Labeltitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    
    //************************************************//
    // MARK: Creating properties.
    //************************************************//
    
    var modelSocialFeed: SocialFeedModel? {
        didSet {
            updateData()
        }
    }
    
    //************************************************//
    // MARK:- View life Cycle
    //************************************************//
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.register(UINib(nibName: "SocialFeedImageCell", bundle: nil),
                                forCellWithReuseIdentifier: "SocialFeedImageCell")
    }
    
    //************************************************//
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //************************************************//
    // MARK:- Custom methods.
    //************************************************//
    
    // Mark:- Update Data Method.
    
    func updateData() {
        Labeltitle.text = modelSocialFeed?.title
        if (modelSocialFeed?.media.count)! > 0 {
            collectionView.isHidden = false
            collectionView.delegate = self
            collectionView.dataSource = self
        } else {
            collectionView.isHidden = true
        }
    }
    
    //************************************************//
    
    // Mark:- Get Light Box Image MEthod.
    
    func GetLightBoxImage() -> [LightboxImage] {
        var arrImages = [LightboxImage]()
        for media in modelSocialFeed!.media {
            if media.mediatype == .photo {
                arrImages.append(LightboxImage(image: media.thumbnail))
            } else {
                arrImages.append(LightboxImage(image: media.thumbnail,
                                               text: "",
                                               videoURL: URL(string: media.url)!))
            }
        }
        return arrImages
    }
    
    //************************************************//
}

extension SocialFeedCell :  UICollectionViewDataSource {
    
    //************************************************//
    // MARK:- UICollectionView DateSource.
    //************************************************//
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        modelSocialFeed?.media.count ?? 0
    }
    
    //************************************************//
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SocialFeedImageCell", for: indexPath) as? SocialFeedImageCell else { return UICollectionViewCell() }
        cell.FeedImage.image = modelSocialFeed?.media[indexPath.row].thumbnail
        return cell
    }
    
    //************************************************//
}

extension SocialFeedCell : UICollectionViewDelegateFlowLayout {
    
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

extension SocialFeedCell: UICollectionViewDelegate {
    
    //************************************************//
    // MARK:- UICollectionView Delegate.
    //************************************************//
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = LightboxController(images: GetLightBoxImage(),
                                            startIndex: indexPath.row)
        controller.modalPresentationStyle = .fullScreen
        UIApplication.getTopViewController()?.present(controller,
                                                      animated: true)
    }
}
