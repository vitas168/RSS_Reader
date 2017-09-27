//
//  FeedModel.swift
//  RSS Reader
//
//  Created by Vitaly Shpinyov on 16/05/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

import UIKit

// String constants
let INITIAL_DATETIME_MASK = "EEE, dd MMM yyyy HH:mm:ss Z"
let TARGET_DATETIME_MASK = "dd MMM, HH:mm"
let LOCALE_EN = "en_GB"
let LOCALE_RU = "ru_RU"

// Protocol containing a callback function for the Feed Model
protocol FeedModelDelegate {
    func articlesReady(feedUrlString:String)
}


class FeedModel: NSObject, XMLParserDelegate {

    // MARK: - Properties
    
    // A collection of articles produced by parsing rss feed
    var articles = [Article]()
    
    // Temporary string variable
    private var attrString = ""
    
    // Article attributes
    private var title = ""
    private var timestamp = ""
    private var link = ""
    private var descr = ""
    
    // Delegate and URL properties of the class
    var delegate:FeedModelDelegate?
    private var rssUrl = ""

    
    // MARK: - Init methods
    override init() {
        super.init()
    }
    
    init(feedURLString strURL:String) {
        super.init()
        rssUrl = strURL
    }
    
    
    // MARK: - Initiation of XML parser
    // This function starts parsing a particular RSS feed
    func getArticles() {
    
        // Flush Articles array to avoid duplication at refresh
        articles.removeAll()
        
        // Create a URL object
        let url = URL(string: rssUrl)
        
        // Create a parser object
        if let actualURL = url {
            let parser = XMLParser(contentsOf: actualURL)
            
            // Set a delegate and start parsing
            if let actualParser = parser {
                actualParser.delegate = self
                actualParser.parse()
            }
        }
    }
    
    
    // MARK: - XMLParser methods
    // We only need Item, Title, Link, Image (enclosure) and Description tags
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        return
    }

    
    // Read characters between starting and closing tags
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        attrString += string
    }
    
    
    // Tag is processed, article attributes are set
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if elementName == "title" {
            title = attrString
        }
        if elementName == "description" {
            descr = attrString
        }
        
        if elementName == "link" {
            link = attrString
        }
        if elementName == "pubDate" {
            timestamp = attrString
        }
        
        // When another item is found, new article is added to the array of articles
        if elementName == "item" {
            
            // Create new article
            let article = Article()
            
            // Set up its attributes
            article.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
            article.timestamp = timestamp.trimmingCharacters(in: .whitespacesAndNewlines)
            
            article.timestampAsDate = formatTimestampAsDate(timestamp: timestamp, initialMask: INITIAL_DATETIME_MASK, targetLocale: LOCALE_EN)
            article.timestampShort = formatTimestamp(timestamp: timestamp, initialMask: INITIAL_DATETIME_MASK, targetMask: TARGET_DATETIME_MASK, sourceLocale: LOCALE_EN, targetLocale: LOCALE_RU)
            article.text = descr.trimmingCharacters(in: .whitespacesAndNewlines)
            article.link = link.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Add article to array
            articles.append(article)
            
        }
        attrString = ""
    }
 
    
    // Parsing is finished, inform the delegate
    func parserDidEndDocument(_ parser: XMLParser) {
        
        if let del = self.delegate {
            del.articlesReady(feedUrlString: rssUrl)
        }
        
    }

    
    // MARK: - Date formatter functions
    // Format date string according to a given mask and locale, and return a string
    func formatTimestamp(timestamp: String, initialMask: String, targetMask: String, sourceLocale:String, targetLocale: String) -> String {
 
        var formattedDate = timestamp.trimmingCharacters(in: .whitespacesAndNewlines)
        let formatter = DateFormatter()
        formatter.dateFormat = initialMask
        formatter.locale = Locale(identifier: sourceLocale)
        
        if let actualDate = formatter.date(from: formattedDate) {
            formatter.dateFormat = targetMask
            formatter.locale = Locale(identifier: targetLocale)
            formattedDate = formatter.string(from: actualDate)
        }
        return formattedDate

    }
    
    // Format date string according to a given mask and return a date
    func formatTimestampAsDate(timestamp: String, initialMask: String, targetLocale: String) -> Date? {

        let formattedDate = timestamp.trimmingCharacters(in: .whitespacesAndNewlines)
        let formatter = DateFormatter()
        formatter.dateFormat = initialMask
        formatter.locale = Locale(identifier: targetLocale)
        
        if let actualDate = formatter.date(from: formattedDate) {
            return actualDate
        } else {
            return nil
        }
    }
    
    
}
