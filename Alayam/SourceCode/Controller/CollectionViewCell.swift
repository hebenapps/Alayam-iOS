//
//  CollectionViewCell.swift
//  CollectionInTableView
//
//  Created by jayaraj on 03/03/16.
//  Copyright © 2016 sample. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    //imageZoom
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblNewsTitle1: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    func configuredata(dict : SliderNewsDTO) {

        
        lblNewsTitle1.text = dict.ImageCaption
        imgView.setImageWithUrl(NSURL(string: dict.IMGURL_XL)!, placeHolderImage: UIImage(named: "placeholder"))
//        let request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: dict.IMGURL_XL)!)
//        request.addValue("image/*", forHTTPHeaderField: "Accept")
//        imgView.setImageWithUrlRequest(request, placeHolderImage: UIImage(named: "tumbnailplaceholder"), success: { (request, response, image, fromCache) -> Void in
//            self.imgView.image = image
//            LocalCacheDataHandler().saveImageToLocal(image, directoryName: "HomeNews", imageName: "\(dict.NewsMainID)")
//            
//            }, failure: { (request, response, error) -> Void in
//                
//        })
    }

}
