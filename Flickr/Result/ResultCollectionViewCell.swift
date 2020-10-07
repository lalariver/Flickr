//
//  ResultCollectionViewCell.swift
//  Flickr
//
//  Created by lawliet on 2020/10/2.
//

import UIKit
import Kingfisher

class ResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func updateWithModel(resultJSONModel: ResultJSONModel, index: Int) {
//        https://live.staticflickr.com/{server-id}/{id}_{secret}.jpg
//        https://live.staticflickr.com/7372/12502775644_acfd415fa7_w.jpg
        let server = resultJSONModel.photos.photo[index].server
        let id = resultJSONModel.photos.photo[index].id
        let secret = resultJSONModel.photos.photo[index].secret
        let url = URL(string: Router.getImageUrl(server: server, id: id, secret: secret))

        imageView.kf.setImage(with: url)
        label.text = resultJSONModel.photos.photo[index].title
    }

}
