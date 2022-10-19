//
//  FeedsViewController.swift
//  News Feed
//
//  Created by Shahzaib Mumtaz on 22/06/2022.
//

import UIKit

class FeedsViewController: UIViewController {
    
    //************************************************//
    // MARK:- Creating Outlets.
    //************************************************//
    
    @IBOutlet weak var SocialFeedView: UITableView!
    
    //************************************************//
    // MARK: Creating properties.
    //************************************************//
    
    var modelSocialFeed = SocialFeedDataModel.sharedInstance
    
    //************************************************//
    // MARK:- View life Cycle
    //************************************************//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SocialFeedView.register(UINib(nibName: "SocialFeedCell",bundle: nil),
                                forCellReuseIdentifier: "SocialFeedCell")
    }
    
    //************************************************//
    // MARK:- IBActions Methods.
    //************************************************//
    
    @IBAction func btnAddFeedTapped(_ sender: Any) {
        let createVC = CreatePostViewController.shareInstance()
        createVC.delegate = self
        self.navigationController?.pushViewController(createVC, animated: true)
    }
    
    //************************************************//
}

extension FeedsViewController: UITableViewDelegate, UITableViewDataSource {
    
    //************************************************//
    // MARK:- UITableview delegate and datesource
    //************************************************//
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    //************************************************//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modelSocialFeed.arrSocialFeed.count
    }
    
    //************************************************//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SocialFeedCell", for: indexPath) as! SocialFeedCell
        cell.modelSocialFeed = modelSocialFeed.arrSocialFeed[indexPath.row]
        cell.btnlike.tag = indexPath.row
        cell.btnlike.addTarget(self, action: #selector(btnlike(sender:)), for: .touchUpInside)
        cell.btnComment.tag = indexPath.row
        cell.btnComment.addTarget(self, action: #selector(btnComment(sender:)), for: .touchUpInside)
        return cell
    }
    
    //************************************************//
    // MARK:- Custom methods and selectors.
    //************************************************//
    
    @objc func btnlike(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                sender.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                // sender.alpha = 0.0
            }) { finished in
                // sender.alpha = 1.0
                UIView.animate(withDuration: 0.3) {
                    sender.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        }
    }
    
    //************************************************//
    
    @objc func btnComment(sender: UIButton) {
        let commentVC = CommentViewController.sharedInstance()
        commentVC.modelSocialFeed = modelSocialFeed.arrSocialFeed[sender.tag]
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    //************************************************//
}

extension FeedsViewController: SocialFeedData {
    func RefreshSocialFeeds() {
        SocialFeedView.reloadData()
    }
}
