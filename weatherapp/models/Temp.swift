
import Foundation

struct Temp: Codable {

  var day   : Double? = nil
  var min   : Double? = nil
  var max   : Double? = nil
  var night : Double? = nil
  var eve   : Double? = nil
  var morn  : Double? = nil

  enum CodingKeys: String, CodingKey {

    case day   = "day"
    case min   = "min"
    case max   = "max"
    case night = "night"
    case eve   = "eve"
    case morn  = "morn"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    day   = try values.decodeIfPresent(Double.self , forKey: .day   )
    min   = try values.decodeIfPresent(Double.self , forKey: .min   )
    max   = try values.decodeIfPresent(Double.self , forKey: .max   )
    night = try values.decodeIfPresent(Double.self , forKey: .night )
    eve   = try values.decodeIfPresent(Double.self , forKey: .eve   )
    morn  = try values.decodeIfPresent(Double.self , forKey: .morn  )
 
  }

  init() {

  }

}