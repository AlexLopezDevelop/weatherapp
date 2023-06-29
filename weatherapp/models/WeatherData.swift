
import Foundation

struct WeatherData: Codable {

  var lat            : Double?     = nil
  var lon            : Double?     = nil
  var timezone       : String?     = nil
  var timezoneOffset : Int?        = nil
  var current        : Current?    = Current()
  var minutely       : [Minutely]? = []
  var hourly         : [Hourly]?   = []
  var daily          : [Daily]?    = []
  var alerts         : [Alerts]?   = []

  enum CodingKeys: String, CodingKey {

    case lat            = "lat"
    case lon            = "lon"
    case timezone       = "timezone"
    case timezoneOffset = "timezone_offset"
    case current        = "current"
    case minutely       = "minutely"
    case hourly         = "hourly"
    case daily          = "daily"
    case alerts         = "alerts"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    lat            = try values.decodeIfPresent(Double.self     , forKey: .lat            )
    lon            = try values.decodeIfPresent(Double.self     , forKey: .lon            )
    timezone       = try values.decodeIfPresent(String.self     , forKey: .timezone       )
    timezoneOffset = try values.decodeIfPresent(Int.self        , forKey: .timezoneOffset )
    current        = try values.decodeIfPresent(Current.self    , forKey: .current        )
    minutely       = try values.decodeIfPresent([Minutely].self , forKey: .minutely       )
    hourly         = try values.decodeIfPresent([Hourly].self   , forKey: .hourly         )
    daily          = try values.decodeIfPresent([Daily].self    , forKey: .daily          )
    alerts         = try values.decodeIfPresent([Alerts].self   , forKey: .alerts         )
 
  }

  init() {

  }

}
