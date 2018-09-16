import ObjectMapper

struct CarModel: Mappable {
    var id: Int
    var type: String
    var model: String
    var color: String
    var owners: [CarOwner]?
    
    init(id: Int, type: String, model: String, color: String, owners: [CarOwner]? = nil) {
        self.id = id
        self.type = type
        self.model = model
        self.color = color
        self.owners = owners
    }
    
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

extension CarModel: CoreDataRepresentable {
    typealias CoreDataType = CarCoreData
    
    var identifier: String {
        return String(id)
    }
    
    init(carCoreData: CarCoreData) {
        let owners = carCoreData.owners?.compactMap { ($0 as? CarOwnerCoreData)?.asDomain() }
        
        self.init(id: Int(carCoreData.id),
                  type: carCoreData.type ?? "",
                  model: carCoreData.model ?? "",
                  color: carCoreData.color ?? "",
                  owners: owners)
    }
}
