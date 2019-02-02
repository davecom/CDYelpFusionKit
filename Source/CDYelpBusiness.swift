//
//  CDYelpBusiness.swift
//  CDYelpFusionKit
//
//  Created by Christopher de Haan on 11/29/16.
//
//  Copyright © 2016-2018 Christopher de Haan <contact@christopherdehaan.me>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import ObjectMapper

@objc @objcMembers public class CDYelpBusiness: NSObject, Mappable {
    public var id: String?
    public var name: String?
    public var imageUrl: URL?
    public var isClosed: Bool?
    public var url: URL?
    public var price: String?
    public var phone: String?
    public var displayPhone: String?
    public var photos: [String]?
    public var hours: [CDYelpHour]?
    public var rating: Double = 0
    public var reviewCount: Int = 0
    public var categories: [CDYelpCategory]?
    public var distance: Double = 0.0
    public var coordinates: CDYelpCoordinates?
    public var location: CDYelpLocation?
    public var transactions: [String]?
    public var transactionsString: NSString {
        if let strings = transactions {
            let words: [String] = strings.map {
                if $0 == "restaurant_reservation" {
                    return "📆"
                } else if $0 == "delivery" {
                    return "📦"
                } else if $0 == "pickup" {
                    return "🥡"
                }
                return ""
            }
            let list = NSString(string: words.joined(separator: ""))
            return list
        }
        return NSString()
    }
    public var categoriesString: NSString {
        if let categories = categories {
            let words: [String] = categories.flatMap{ return $0.title }
            let list = NSString(string: words.joined(separator: ", "))
            return list
        }
        return NSString()
    }
    public var hoursString: NSAttributedString? {
        if let hours = hours {
            var total: String = ""
            let df: DateFormatter = DateFormatter()
            for hour in hours {
                if let specifics = hour.open {
                    for specific in specifics {
                        if let day = specific.day, let start = specific.start, let end = specific.end {
                            switch day {
                            case 0:
                                total += "Mon "
                            case 1:
                                total += "Tue "
                            case 2:
                                total += "Wed "
                            case 3:
                                total += "Thu "
                            case 4:
                                total += "Fri "
                            case 5:
                                total += "Sat "
                            case 6:
                                total += "Sun "
                            default:
                                break
                            }
                            df.dateFormat = "HHmm"
                            if let sdate = df.date(from: start), let edate = df.date(from: end) {
                                df.dateFormat = "h:mma"
                                let s = df.string(from: sdate)
                                let e = df.string(from: edate)
                                total += "\t\(s)-\(e)\n"
                            }
                        }
                    }
                }
            }
            return NSAttributedString(string: total,
                                      attributes: [NSAttributedStringKey.font: NSFont.systemFont(ofSize: 10)])
        }
        return nil
    }
    
    public var multiplePhotos: Bool {
        if let photos = photos {
            return photos.count > 1
        }
        return false
    }
    
    public required init?(map: Map) {
    }

    public func mapping(map: Map) {
        id              <- map["id"]
        name            <- map["name"]
        imageUrl        <- (map["image_url"], URLTransform())
        isClosed        <- map["is_closed"]
        url             <- (map["url"], URLTransform())
        price           <- map["price"]
        phone           <- map["phone"]
        displayPhone    <- map["display_phone"]
        photos          <- map["photos"]
        hours           <- map["hours"]
        rating          <- map["rating"]
        reviewCount     <- map["review_count"]
        categories      <- map["categories"]
        distance        <- map["distance"]
        coordinates     <- map["coordinates"]
        location        <- map["location"]
        transactions    <- map["transactions"]
    }
}
