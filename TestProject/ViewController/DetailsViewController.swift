//
//  DetailsViewController.swift
//  TestProject
//
//  Created by Aswin Koramanghat on 02/09/20.
//  Copyright © 2020 Aswin Koramanghat. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var viewModel: DetailsViewModelling!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getSynopsis()
    }
    
    private func setupBinding() {
        viewModel.title.bind { (value) in
            DispatchQueue.main.async {
                self.titleLabel.text = value
            }
        }
        viewModel.tagline.bind { (value) in
            DispatchQueue.main.async {
                self.taglineLabel.text = value
            }
        }
        viewModel.overview.bind { (value) in
            DispatchQueue.main.async {
                self.overviewLabel.text = value
            }
        }
        viewModel.posterUrl.bind { (value) in
            DispatchQueue.main.async {
                self.posterImageView.loadImageUsingCacheWithURLString(value, placeHolder: nil)
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
