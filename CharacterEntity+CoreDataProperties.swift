//
//  CharacterEntity+CoreDataProperties.swift
//  RickAndMorty
//
//  Created by Mia on 12/19/24.
//
//

import Foundation
import CoreData


extension CharacterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }

    @NSManaged public var episodeUrls: [String]?
    @NSManaged public var gender: Int64
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var locationName: String?
    @NSManaged public var name: String?
    @NSManaged public var originName: String?
    @NSManaged public var species: String?
    @NSManaged public var status: Int64
    @NSManaged public var episodes: NSSet?

}

// MARK: Generated accessors for episodes
extension CharacterEntity {

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: EpisodeEntity)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: EpisodeEntity)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)

}

extension CharacterEntity : Identifiable {

}
