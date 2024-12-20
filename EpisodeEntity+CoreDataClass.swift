//
//  EpisodeEntity+CoreDataClass.swift
//  RickAndMorty
//
//  Created by Mia on 12/19/24.
//
//

import Foundation
import CoreData

@objc(EpisodeEntity)
public class EpisodeEntity: NSManagedObject {
    convenience init(context: NSManagedObjectContext, episodeResponse: EpisodeResponse) {
        self.init(context: context)
        
        self.id = Int64(episodeResponse.id)
        self.airDate = episodeResponse.airDate
        self.episodeNumber = episodeResponse.episodeNumber
        self.name = episodeResponse.name
        self.url = episodeResponse.url
    }
}
