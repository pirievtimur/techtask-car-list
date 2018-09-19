import XCTest
import Foundation
import ObjectMapper
@testable import car_list

class CarModelTests: XCTestCase {

    func test_carModel_mapping() {
        if let models = Mapper<CarModel>().mapArray(JSONObject: jsonData()) {
            XCTAssert(models.count == 1)
            
            XCTAssert(models.first?.id == 1)
            XCTAssert(models.first?.type == "sedan")
            XCTAssert(models.first?.model == "Suzuki Swift")
            XCTAssert(models.first?.color == "white")
            
            XCTAssert(models.first?.owners?.count == 1)
            XCTAssert(models.first?.owners?.first?.id == 1)
            XCTAssert(models.first?.owners?.first?.name == "Ivan")
            XCTAssert(models.first?.owners?.first?.phone == "+38012345678")
        } else {
            XCTFail()
        }
    }
    
    private func jsonData() -> Array<AnyObject>? {
        let jsonString =
            """
                [
                    {
                        "car_id" : 1,
                        "car_type" : "sedan",
                        "car_model" : "Suzuki Swift",
                        "car_color" : "white",
                        "owners": [
                        {
                            "owner_id" : 1,
                            "owner_name" : "Ivan",
                            "owner_phone" : "+38012345678"
                        }
                        ]
                    }
                ]
            """
        
        let data = jsonString.data(using: .utf8)!
        
        return try! JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Array<AnyObject>
    }
}
