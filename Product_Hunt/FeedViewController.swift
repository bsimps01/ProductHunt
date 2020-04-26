//
//  FeedViewController.swift
//  Product_Hunt
//
//  Created by Benjamin Simpson on 4/19/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    // Array of Post objects to simulate real data coming in
    // Make sure each property that we're assigning to a UI element has a value for each mock Post.
    var posts: [Post] = [] {
        didSet {
            feedTableView.reloadData()
        }
    }
    
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        feedTableView.dataSource = self
        feedTableView.delegate = self
        updateFeed()
    }
    
    func updateFeed() {
        // call our network manager's getPosts method to update our feed with posts
        networkManager.getPosts() { result in
            self.posts = result
        }
    }


}

extension FeedViewController: UITableViewDataSource {
   // Determines how many cells will be shown on the table view.
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return posts.count
   }

   // Creates and configures each cell.
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     // Grab an available cell
     let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell

     // Grab a post from our "data"
     let post = posts[indexPath.row]
     // Assign a post to that cell
     cell.post = post

     return cell
   }
}

extension FeedViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    // provide a fixed size
    return 250
  }
}

