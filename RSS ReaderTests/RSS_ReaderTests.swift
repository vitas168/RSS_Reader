//
//  RSS_ReaderTests.swift
//  RSS ReaderTests
//
//  Created by Vitaly Shpinyov on 26/09/2017.
//  Copyright © 2017 Vitaly Shpinyov. All rights reserved.
//

import XCTest
@testable import RSS_Reader

class FMTester: XCTestCase, FeedModelDelegate {

    let url = "https://dni.ru/rss.xml"
    var fm: FeedModel!
    var articlesCount = 0
    var urlString = ""
    
    func callFeedModelToGetArticles() {
    
        fm = FeedModel(feedURLString: url)
        fm.delegate = self
        fm.getArticles()
    
    }
    
    func articlesReady(feedUrlString: String) {

        self.urlString = feedUrlString
        self.articlesCount = fm.articles.count
        
    }
    
}


class RSS_ReaderTests: XCTestCase {
    
    // String constants
    // let url = "https://dni.ru/rss.xml"
    let url = "https://www.vz.ru/rss.xml"
    let INITIAL_DATETIME_MASK = "EEE, dd MMM yyyy HH:mm:ss Z"
    let TARGET_DATETIME_MASK = "dd MMM, HH:mm"
    let LOCALE_EN = "en_GB"
    let LOCALE_RU = "ru_RU"

    var fmTester: FMTester!
    var fm: FeedModel!
    
    override func setUp() {
        super.setUp()
        fmTester = FMTester()
        fm = FeedModel()
    }
    
    override func tearDown() {

        fmTester = nil
        fm = nil
        super.tearDown()
    }
    
    func testNumberOfReturnedArticles() {

        // Given
        // "Number of articles greater than zero")
        
        // When
        DispatchQueue.global().sync {
            self.fmTester.callFeedModelToGetArticles()
        }

        // Then
        XCTAssert(fmTester.articlesCount > 0)
        print ( "\(fmTester.articlesCount) articles retrieved")
    }

    func testFormatTimestamp() {
    
        // Given
        let timestamp = "Wed, 27 Sep 2017 11:22:10 +0300"
        var formattedDate = ""
        
        // When
        formattedDate = fm.formatTimestamp(timestamp: timestamp, initialMask: INITIAL_DATETIME_MASK, targetMask: TARGET_DATETIME_MASK, sourceLocale: LOCALE_EN, targetLocale: LOCALE_RU)
    
        // Then
        XCTAssertEqual(formattedDate, "27 сент., 11:22")
    }
    
}
