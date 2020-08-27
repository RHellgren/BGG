//
//  HotItems.swift
//  BGGAPI
//
//  Created by Robin Hellgren on 27/08/2020.
//  Copyright © 2020 Robin Hellgren. All rights reserved.
//

import Foundation

public struct HotItems {
    public let items: [Item]

    public struct Item {
        public let id: String
        public let rank: Int?
        public let thumbnail: URL?
        public let name: String
        public let yearpublished: String
    }
}

class HotItemsParser: NSObject, XMLParserDelegate {
    private var items: [HotItems.Item] = []
    private var currentElement = ""
    private var currentID = ""
    private var currentRank = ""
    private var currentThumbnail = ""
    private var currentName = ""
    private var currentYearPublished = ""
    private var parserCompletionHandler: ((HotItems) -> Void)?

    func parse(data: Data, completionHandler: ((HotItems) -> Void)?) {
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
            currentID = attributeDict["id"].cleanedXML
            currentRank = attributeDict["rank"].cleanedXML

        case "thumbnail":
            currentThumbnail += attributeDict["value"].cleanedXML

        case "name":
            currentName += attributeDict["value"].cleanedXML

        case "yearpublished":
            currentYearPublished += attributeDict["value"].cleanedXML

        default:
            break
        }
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "item" {
            self.items.append(
                HotItems.Item(
                    id: currentID,
                    rank: Int(currentRank),
                    thumbnail: URL(string: currentThumbnail),
                    name: currentName,
                    yearpublished: currentYearPublished)
            )

            currentID = ""
            currentRank = ""
            currentThumbnail = ""
            currentName = ""
            currentYearPublished = ""
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(HotItems(items: items))
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
