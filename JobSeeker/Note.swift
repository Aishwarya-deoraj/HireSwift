import SwiftData
import Foundation

@Model
class Note {
    var title: String
    var desc: String
    var latitude: Double
    var longitude: Double

    init(title: String, desc: String, latitude: Double, longitude: Double) {
        self.title = title
        self.desc = desc
        self.latitude = latitude
        self.longitude = longitude
    }
}

