//
//  MovieCollectionViewCell.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 01/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var movie: Movie? {
      didSet {
        titleLabel.text = movie?.title
        subtitleLabel.text = movie?.releaseDate
        guard let imageUrl = movie?.posterPath else { return }
        thumbnailView.loadImageUsingCacheWithURLString("https://image.tmdb.org/t/p/w500\(imageUrl)", placeHolder: nil)
      }
    }
    
    required init?(coder: NSCoder) {
      super.init(coder: coder)
    }
    
    override func awakeFromNib() {
      super.awakeFromNib()
    }

}
