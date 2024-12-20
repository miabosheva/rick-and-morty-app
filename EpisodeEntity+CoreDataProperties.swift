//
//  EpisodeEntity+CoreDataProperties.swift
//  RickAndMorty
//
//  Created by Mia on 12/19/24.
//
//

import Foundation
import CoreData


extension EpisodeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeEntity> {
        return NSFetchRequest<EpisodeEntity>(entityName: "EpisodeEntity")
    }

    @NSManaged public var airDate: String
    @NSManaged public var episodeNumber: String
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var url: String

}

extension EpisodeEntity : Identifiable {

}
