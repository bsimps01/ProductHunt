//
//  NetworkManager.swift
//  Product_Hunt
//
//  Created by Benjamin Simpson on 4/21/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import Foundation

class NetworkManager {
    // shared singleton session object used to run tasks. Will be useful later
    let urlSession = URLSession.shared

    var baseURL = "https://api.producthunt.com/v1/"
    var token = "wcAeHIi0TG9CLWqyvItEPJy5wUnfRqT99fBwQZf52e4"
    
    func getPosts(completion: @escaping ([Post]) -> Void) {
        // our API query
        let query = "posts/all?sort_by=votes_count&order=desc&search[featured]=true&per_page=20"
        // Add the baseURL to it
        let fullURL = URL(string: baseURL + query)!
        // Create the request
        var request = URLRequest(url: fullURL)
        // We're sending a GET request, so we need to specify that
        request.httpMethod = "GET"
        // Add in all the header fields just like we did in Postman
        request.allHTTPHeaderFields = [
           "Accept": "application/json",
           "Content-Type": "application/json",
           "Authorization": "Bearer \(token)",
           "Host": "api.producthunt.com"
        ]
        let task = urlSession.dataTask(with: request) { data, response, error in
            // error check/handling
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // make sure we get back data
            guard let data = data else {
                return
            }
            guard let result = try? JSONDecoder().decode(PostList.self, from: data) else {
                return
            }
            let posts = result.posts
            
            // Return the result with the completion handler
            DispatchQueue.main.async {
                completion(posts)
            }
        }
        task.resume()
    }
}
