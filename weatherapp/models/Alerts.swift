
import Foundation

struct Alerts: Codable {

  var senderName  : String?   = nil
  var event       : String?   = nil
  var start       : Int?      = nil
  var end         : Int?      = nil
  var description : String?   = nil
  var tags        : [String]? = []

  enum CodingKeys: String, CodingKey {

    case senderName  = "sender_name"
    case event       = "event"
    case start       = "start"
    case end         = "end"
    case description = "description"
    case tags        = "tags"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    senderName  = try values.decodeIfPresent(String.self   , forKey: .senderName  )
    event       = try values.decodeIfPresent(String.self   , forKey: .event       )
    start       = try values.decodeIfPresent(Int.self      , forKey: .start       )
    end         = try values.decodeIfPresent(Int.self      , forKey: .end         )
    description = try values.decodeIfPresent(String.self   , forKey: .description )
    tags        = try values.decodeIfPresent([String].self , forKey: .tags        )
 
  }

  init() {

  }

}