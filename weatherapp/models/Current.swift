
import Foundation

struct Current: Codable {

  var dt         : Int?       = nil
  var sunrise    : Int?       = nil
  var sunset     : Int?       = nil
  var temp       : Double?    = nil
  var feelsLike  : Double?    = nil
  var pressure   : Int?       = nil
  var humidity   : Int?       = nil
  var dewPoint   : Double?    = nil
  var uvi        : Double?    = nil
  var clouds     : Int?       = nil
  var visibility : Int?       = nil
  var windSpeed  : Double?    = nil
  var windDeg    : Int?       = nil
  var weather    : [Weather]? = []

  enum CodingKeys: String, CodingKey {

    case dt         = "dt"
    case sunrise    = "sunrise"
    case sunset     = "sunset"
    case temp       = "temp"
    case feelsLike  = "feels_like"
    case pressure   = "pressure"
    case humidity   = "humidity"
    case dewPoint   = "dew_point"
    case uvi        = "uvi"
    case clouds     = "clouds"
    case visibility = "visibility"
    case windSpeed  = "wind_speed"
    case windDeg    = "wind_deg"
    case weather    = "weather"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    dt         = try values.decodeIfPresent(Int.self       , forKey: .dt         )
    sunrise    = try values.decodeIfPresent(Int.self       , forKey: .sunrise    )
    sunset     = try values.decodeIfPresent(Int.self       , forKey: .sunset     )
    temp       = try values.decodeIfPresent(Double.self    , forKey: .temp       )
    feelsLike  = try values.decodeIfPresent(Double.self    , forKey: .feelsLike  )
    pressure   = try values.decodeIfPresent(Int.self       , forKey: .pressure   )
    humidity   = try values.decodeIfPresent(Int.self       , forKey: .humidity   )
    dewPoint   = try values.decodeIfPresent(Double.self    , forKey: .dewPoint   )
    uvi        = try values.decodeIfPresent(Double.self    , forKey: .uvi        )
    clouds     = try values.decodeIfPresent(Int.self       , forKey: .clouds     )
    visibility = try values.decodeIfPresent(Int.self       , forKey: .visibility )
    windSpeed  = try values.decodeIfPresent(Double.self    , forKey: .windSpeed  )
    windDeg    = try values.decodeIfPresent(Int.self       , forKey: .windDeg    )
    weather    = try values.decodeIfPresent([Weather].self , forKey: .weather    )
 
  }

  init() {

  }

}