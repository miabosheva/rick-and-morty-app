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

    @NSManaged public var episodeUrls: NSObject?
    @NSManaged public var gender: String?
    @NSManaged public var id: Int64
    @NSManaged public var image: String?
    @NSManaged public var locationName: String?
    @NSManaged public var locationUrl: String?
    @NSManaged public var name: String?
    @NSManaged public var originName: String?
    @NSManaged public var originUrl: String?
    @NSManaged public var species: String?
    @NSManaged public var status: String?

}

extension CharacterEntity : Identifiable {

}
