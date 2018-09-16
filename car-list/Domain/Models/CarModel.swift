import ObjectMapper

struct CarModel: Mappable {
    var id: Int
    var type: String
    var model: String
    var color: String
    var owners: [CarOwner]?
    
    init?(map: Map) {
        id = 0
        type = ""
        model = ""
        color = ""
    }
    
    mutating func mapping(map: Map) {
        id <- map["car_id"]
        type <- map["car_type"]
        model <- map["car_model"]
        color <- map["car_color"]
        owners <- map["owners"]
    }
}
