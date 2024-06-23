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
        let live = OpenGraphService.live()
        do  {
            let metadata = try await live.metadata(url)
            let title = metadata[.title]?.head.value.string
            print(String(describing: title))
            let description = metadata[.description]?.head.value.string
            print(String(describing: description))
            let image = metadata[.image]?.head.value.url
            print(String(describing: image))
        } catch {
            print("Unable to construct metadata with error: \(error)")
            exit(1)
        }
    }
}
