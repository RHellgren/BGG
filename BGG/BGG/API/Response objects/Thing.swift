//
//  Thing.swift
//  BGGAPI
//
//  Created by Robin Hellgren on 27/08/2020.
//  Copyright © 2020 Robin Hellgren. All rights reserved.
//

import Foundation

public struct Thing {
    public let id: String
    public let type: ItemType
    public let thumbnail: URL?
    public let image: URL?
    public let name: String
    public let gameDescription: String
    public let yearPublished: String
    public let minPlayers: Int?
    public let maxPlayers: Int?
    public let playingTime: Int?
    public let minPlayingTime: Int?
    public let maxPlayingTime: Int?
    public let minAge: Int?
}

class ThingParser: NSObject, XMLParserDelegate {
    private var currentElement = ""
    private var id: String = ""
    private var type: String = ""
    private var thumbnail: String = ""
    private var image: String = ""
    private var name: String = ""
    private var gameDescription: String = ""
    private var yearPublished: String = ""
    private var minPlayers: String = ""
    private var maxPlayers: String = ""
    private var playingTime: String = ""
    private var minPlayingTime: String = ""
    private var maxPlayingTime: String = ""
    private var minAge: String = ""
    private var parserCompletionHandler: ((Thing) -> Void)?


    func parse(data: Data, completionHandler: ((Thing) -> Void)?) {
        self.parserCompletionHandler = completionHandler

        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName

        switch currentElement {
        case "item":
            id = attributeDict["id"].cleanedXML
            type = attributeDict["type"].cleanedXML
        case "name":
            name = attributeDict["value"].cleanedXML
        case "yearpublished":
            yearPublished = attributeDict["value"].cleanedXML
        case "minplayers":
            minPlayers = attributeDict["value"].cleanedXML
        case "maxplayers":
            maxPlayers = attributeDict["value"].cleanedXML
        case "playingtime":
            playingTime = attributeDict["value"].cleanedXML
        case "minplaytime":
            minPlayingTime = attributeDict["value"].cleanedXML
        case "maxplaytime":
            maxPlayingTime = attributeDict["value"].cleanedXML
        case "minage":
            minAge = attributeDict["value"].cleanedXML
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "thumbnail": thumbnail += string.cleanedXML
        case "image": image += string.cleanedXML
        case "description": gameDescription += string.cleanedXML
        default: break
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(
            Thing(
                id: id,
                type: ItemType(rawValue: type) ?? .boardgame,
                thumbnail: URL(string: thumbnail),
                image: URL(string: image),
                name: name,
                gameDescription: gameDescription,
                yearPublished: yearPublished,
                minPlayers: Int(minPlayers),
                maxPlayers: Int(maxPlayers),
                playingTime: Int(playingTime),
                minPlayingTime: Int(minPlayingTime),
                maxPlayingTime: Int(maxPlayingTime),
                minAge: Int(minAge)
            )
        )
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
