//
//  Networking.swift
//  
//
//  Created by Dean Silfen on 6/23/24.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct Networking {
    public var fetch: (URL) async throws -> (Data, URLResponse)

    // If you are using this library with Vapor, or some other swift-nio based
    // library on Linux, swap this implementation for one using AsyncHTTPClient.
    public static var `default`: Self {
        .init { url in
#if canImport(FoundationNetworking)
            try await URLSession.shared.asyncData(from: url)
#else
            try await URLSession.shared.data(from: url)
#endif
        }
    }

    public init(fetch: @escaping (URL) async throws -> (Data, URLResponse)) {
        self.fetch = fetch
    }
}
// Credit to
// Aron Budinszky for this current solution.
// https://medium.com/hoursofoperation/use-async-urlsession-with-server-side-swift-67821a64fa91

/// Defines the possible errors
public enum URLSessionAsyncErrors: Error {
    case invalidUrlResponse, missingResponseData
}

/// An extension that provides async support for fetching a URL
///
/// Needed because the Linux version of Swift does not support async URLSession yet.
public extension URLSession {

    /// A reimplementation of `URLSession.shared.data(from: url)` required for Linux
    ///
    /// - Parameter url: The URL for which to load data.
    /// - Returns: Data and response.
    ///
    /// - Usage:
    ///
    ///     let (data, response) = try await URLSession.shared.asyncData(from: url)
    func asyncData(from url: URL) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    continuation.resume(throwing: URLSessionAsyncErrors.invalidUrlResponse)
                    return
                }
                guard let data = data else {
                    continuation.resume(throwing: URLSessionAsyncErrors.missingResponseData)
                    return
                }
                continuation.resume(returning: (data, response))
            }
            task.resume()
        }
    }
}
