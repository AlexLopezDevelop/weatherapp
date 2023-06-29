
import Foundation

struct Daily: Codable {

  var dt        : Int?       = nil
  var sunrise   : Int?       = nil
  var sunset    : Int?       = nil
  var moonrise  : Int?       = nil
  var moonset   : Int?       = nil
  var moonPhase : Double?    = nil
  var summary   : String?    = nil
  var temp      : Temp?      = Temp()
  var feelsLike : FeelsLike? = FeelsLike()
  var pressure  : Int?       = nil
  var humidity  : Int?       = nil
  var dewPoint  : Double?    = nil
  var windSpeed : Double?    = nil
  var windDeg   : Int?       = nil
  var windGust  : Double?    = nil
  var weather   : [Weather]? = []
  var clouds    : Int?       = nil
  var pop       : Double?    = nil
  var uvi       : Double?    = nil

  enum CodingKeys: String, CodingKey {

    case dt        = "dt"
    case sunrise   = "sunrise"
    case sunset    = "sunset"
    case moonrise  = "moonrise"
    case moonset   = "moonset"
    case moonPhase = "moon_phase"
    case summary   = "summary"
    case temp      = "temp"
    case feelsLike = "feels_like"
    case pressure  = "pressure"
    case humidity  = "humidity"
    case dewPoint  = "dew_point"
    case windSpeed = "wind_speed"
    case windDeg   = "wind_deg"
    case windGust  = "wind_gust"
    case weather   = "weather"
    case clouds    = "clouds"
    case pop       = "pop"
    case uvi       = "uvi"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    dt        = try values.decodeIfPresent(Int.self       , forKey: .dt        )
    sunrise   = try values.decodeIfPresent(Int.self       , forKey: .sunrise   )
    sunset    = try values.decodeIfPresent(Int.self       , forKey: .sunset    )
    moonrise  = try values.decodeIfPresent(Int.self       , forKey: .moonrise  )
    moonset   = try values.decodeIfPresent(Int.self       , forKey: .moonset   )
    moonPhase = try values.decodeIfPresent(Double.self    , forKey: .moonPhase )
    summary   = try values.decodeIfPresent(String.self    , forKey: .summary   )
    temp      = try values.decodeIfPresent(Temp.self      , forKey: .temp      )
    feelsLike = try values.decodeIfPresent(FeelsLike.self , forKey: .feelsLike )
    pressure  = try values.decodeIfPresent(Int.self       , forKey: .pressure  )
    humidity  = try values.decodeIfPresent(Int.self       , forKey: .humidity  )
    dewPoint  = try values.decodeIfPresent(Double.self    , forKey: .dewPoint  )
    windSpeed = try values.decodeIfPresent(Double.self    , forKey: .windSpeed )
    windDeg   = try values.decodeIfPresent(Int.self       , forKey: .windDeg   )
    windGust  = try values.decodeIfPresent(Double.self    , forKey: .windGust  )
    weather   = try values.decodeIfPresent([Weather].self , forKey: .weather   )
    clouds    = try values.decodeIfPresent(Int.self       , forKey: .clouds    )
    pop       = try values.decodeIfPresent(Double.self    , forKey: .pop       )
    uvi       = try values.decodeIfPresent(Double.self    , forKey: .uvi       )
 
  }

  init() {

  }

}
