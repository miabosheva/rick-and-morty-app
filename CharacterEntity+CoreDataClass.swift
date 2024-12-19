//
//  CharacterEntity+CoreDataClass.swift
//  RickAndMorty
//
//  Created by Mia on 12/19/24.
//
//

import Foundation
import CoreData

@objc(CharacterEntity)
public class CharacterEntity: NSManagedObject {
    convenience init(context: NSManagedObjectContext, characterResponse: CharacterResponse) {
        self.init(context: context)
        
        self.id = Int64(characterResponse.id)
        self.name = characterResponse.name
        self.species = characterResponse.species
        self.image = characterResponse.image
        self.originName = characterResponse.origin.name
        self.locationName = characterResponse.location.name
        self.episodeUrls = characterResponse.episodeUrls.joined(separator: ",")
        self.status = Int64(characterResponse.status.rawValue)
        self.gender = Int64(characterResponse.gender.rawValue)
    }
}
