//
//  CommentViewController.swift
//  News Feed
//
//  Created by Shahzaib Mumtaz on 23/06/2022.
//

import UIKit

class CommentViewController: UIViewController {
    
    //************************************************//
    // MARK:- Creating Outlets.
    //************************************************//
    
    @IBOutlet weak var CommentView: UITableView!
    @IBOutlet weak var textComment: UITextField!
    
    //************************************************//
    // MARK: Creating properties.
    //************************************************//
    
    let modelComment = CommentDataModel.sharedInstance
    var modelSocialFeed = SocialFeedModel()
    
    var arrComment = [CommentModel]()
    
    //************************************************//
    // MARK:- View life Cycle
    //************************************************//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //************************************************//
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arrComment = modelComment.arrComments.filter { $0.socialfeedID == modelSocialFeed.id }
    }
    
    //************************************************//
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textComment.becomeFirstResponder()
    }
    
    //************************************************//
    // MARK:- IBActions Methods.
    //************************************************//
    
    @IBAction func BtnSendTapped(_ sender: UIButton) {
        
        let modelData = CommentModel(socialfeedID: modelSocialFeed.id,
                                     commentID: "\(modelComment.arrComments.count + 1)",
                                     title: textComment.text ?? "Nice")
        modelComment.arrComments.append(modelData)
        arrComment.append(modelData)
        textComment.resignFirstResponder()
        CommentView.reloadData()
    }
    
    //************************************************//
}
extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    //************************************************//
    // MARK:- UITableview delegate and datesource
    //************************************************//
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrComment.count
    }
    
    //************************************************//
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = arrComment[indexPath.row].title
        return cell
    }
    
    //************************************************//
}

extension CommentViewController {
    static func sharedInstance() -> CommentViewController {
        CommentViewController.instantiateFromStoryboard()
    }
}
