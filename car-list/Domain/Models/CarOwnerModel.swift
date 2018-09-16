import ObjectMapper

struct CarOwner: Mappable {
    var id: Int
    var name: String
    var phone: String
    
    init(id: Int, name: String, phone: String) {
        self.id = id
        self.name = name
        self.phone = phone
    }
    
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

extension CarOwner: CoreDataRepresentable {
    typealias CoreDataType = CarOwnerCoreData
    
    var identifier: String {
        return String(id)
    }
    
    init(carOwnerCoreData: CarOwnerCoreData) {
        self.init(id: Int(carOwnerCoreData.id),
                  name: carOwnerCoreData.name ?? "",
                  phone: carOwnerCoreData.phone ?? "")
    }
}

