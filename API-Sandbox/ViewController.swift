//
//  ViewController.swift
//  API-Sandbox
//
//  Created by Dion Larson on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import AlamofireImage
import AlamofireNetworkActivityIndicator





class ViewController: UIViewController {

    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var rightsOwnerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var mov:Movie!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        exerciseOne()
//        exerciseTwo()
//        exerciseThree()
        
        guard let jsonURL = Bundle.main.url(forResource: "iTunes-Movies", withExtension: "json") else {
            print("Could not find iTunes-Movies.json!")
            return
        }
        
        let jsonData = try! Data(contentsOf: jsonURL)
        
        let moviesData = JSON(data: jsonData)
        
        let allMoviesData = moviesData["feed"]["entry"].arrayValue
        
        let randomMovieIndex: Int = Int(arc4random_uniform(24))
        
        let randomMovieData = allMoviesData[randomMovieIndex]
        let randomMovie = Movie(json: randomMovieData)
        self.mov = randomMovie

        
        
        let apiToContact = "https://itunes.apple.com/us/rss/topmovies/limit=25/json"
        // This code will call the iTunes top 25 movies endpoint listed above
        Alamofire.request(apiToContact).validate().responseJSON() { response in
            
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let _ = JSON(value)

                    
                    self.movieTitleLabel.text = randomMovie.name
                    self.rightsOwnerLabel.text = randomMovie.rightsOwner
                    self.releaseDateLabel.text = randomMovie.releaseDate
                    self.priceLabel.text = String("$\(randomMovie.price)")
                    self.loadPoster(urlString: randomMovie.posterURL)
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Updates the image view when passed a url string
    func loadPoster(urlString: String) {
        posterImageView.af_setImage(withURL: URL(string: urlString)!)
    }
    
    @IBAction func viewOniTunesPressed(_ sender: AnyObject) {
        
        UIApplication.shared.openURL(URL(string: self.mov.itunesURL)!)
        print(self.mov.itunesURL)

    }
    
}

