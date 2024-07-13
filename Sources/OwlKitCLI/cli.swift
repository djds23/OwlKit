//
//  cli.swift
//
//
//  Created by Dean Silfen on 6/23/24.
//

import Foundation

import OwlKit

@main
struct CLI {
    static func main() async {
        guard
            let urlString = CommandLine.arguments.last
        else {
            print("Please pass a URL to fetch")
            exit(1)
        }
        
        guard
            let url = URL(string: urlString)
        else {
            print("Unable to craft URL from \(urlString)")
            exit(1)
        }
        let hoot = Hoot.live()
        let metadata = try! await hoot.load(url)
        guard let summary = metadata.summary() else {
            print("Unable to construct summary for \(urlString)")
            exit(1)
        }

        print("Summary for: \(urlString)")
        print(summary.title)
        print(String(describing: summary.description))
        print(String(describing: summary.author))
        print(String(describing: summary.image))
    }
}
