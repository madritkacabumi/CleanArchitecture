//
//  DateFormatter.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Foundation

protocol DateFormatingType {
    func date(from string: String) -> Date?
}

extension ISO8601DateFormatter: DateFormatingType {
    // do nothing since it owns this method
}


enum DateFormatterTemplate: String {
    
    case iso8601
    
    var dateFormatter: DateFormatingType {
        switch self {
            case .iso8601:
                return ISO8601DateFormatter()
        }
    }
}

struct CustomDateFormatter {
    
    static func dateFromString(dateFormat: DateFormatterTemplate, dateString: String) -> Date? {
        let dateFormatingType = dateFormat.dateFormatter
        return dateFormatingType.date(from: dateString)
    }
    
    static func dateToString(date: Date, formatOptions: ISO8601DateFormatter.Options = []) -> String {
        return ISO8601DateFormatter.string(from: date, timeZone: TimeZone.current, formatOptions: formatOptions)
    }
}
