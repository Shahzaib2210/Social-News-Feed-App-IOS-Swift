//
//  SocialFeedModel.swift
//  News Feed
//
//  Created by Shahzaib Mumtaz on 21/06/2022.
//

import UIKit

struct SocialFeedModel {
    var id = ""
    var title = ""
    var media = [MedialModel]()
}

class SocialFeedDataModel {
    static let sharedInstance = SocialFeedDataModel()
    var arrSocialFeed = [SocialFeedModel]()
}

struct MedialModel {
    var mediatype:MediaType?
    var thumbnail = UIImage()
    var url = ""
}

enum MediaType {
    case photo,video
}

struct CommentModel{
    var socialfeedID = ""
    var commentID = ""
    var title = ""
}

class CommentDataModel {
    static let sharedInstance = CommentDataModel()
    var arrComments = [CommentModel]()
}
