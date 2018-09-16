import ObjectMapper

struct CarOwner: Mappable {
    var id: Int
    var name: String
    var phone: String
    
    init?(map: Map) {
        id = 0
        name = ""
        phone = ""
    }
    
    mutating func mapping(map: Map) {
        id <- map["owner_id"]
        name <- map["owner_name"]
        phone <- map["owner_phone"]
    }
}
