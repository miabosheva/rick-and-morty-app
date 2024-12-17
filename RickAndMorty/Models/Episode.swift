//
//  Episode.swift
//  RickAndMorty
//
//  Created by Mia on 12/16/24.
//

import Foundation

struct Episode: Identifiable {
    var id = UUID()
    var name: String
    var airDate: String
    var episodeNumber: String
}
