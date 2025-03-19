//
//  MatchDetailsEntity.swift
//  Shaadi.com

import SwiftData

@Model
class MatchDetailsEntity {
    var uuid: String
    var firstName: String
    var lastName: String
    var title: String
    var largeImage: String
    var state: String
    var streetName: String
    var streetNumber: Int
    var isAccepted: Bool? // Nullable (pending state)

    init(firstName: String, lastName: String, title: String, largeImage: String, state: String, streetName: String, streetNumber: Int, uuid: String, isAccepted: Bool? = nil) {
        self.firstName = firstName
        self.lastName = lastName
        self.title = title
        self.largeImage = largeImage
        self.state = state
        self.streetName = streetName
        self.streetNumber = streetNumber
        self.uuid = uuid
        self.isAccepted = isAccepted
    }
}

