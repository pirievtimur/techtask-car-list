import XCTest
import RxSwift
import RxTest
import RxBlocking
import CoreData
@testable import car_list

class CarsStorageTests: XCTestCase {
    
    var sut: CarsStorage!
    let testScheduler = TestScheduler(initialClock: 0)

    override func setUp() {
        super.setUp()
        
        let context = NSManagedObjectContext.inMemoryTestContext(Bundle(for: CarsStorage.self))
        let executor = ImmediateContextExecutor(context: context)
        let repository = Repository<CarCoreData>(executor: executor)
        
        sut = CarsStorage(repository: repository)
    }
    
    func test_storage_shouldReturnCars() {
        let cars = generateCars(count: 2)
        
        guard var firstCar = cars.first, var secondCar = cars.last else {
            XCTFail("No test data")
            return
        }
        
        firstCar.id = 1
        secondCar.id = 2
        secondCar.color = "red"
        secondCar.model = "suzuki"
        secondCar.owners = nil
        secondCar.type = "crossover"
        
        _ = sut.createCars([firstCar, secondCar]).toBlocking().materialize()
        
        let carsFromStorage = try! sut.cars().toBlocking().first()!.sorted(by: { $0.id < $1.id })
        
        XCTAssert(!carsFromStorage.isEmpty)
        
        XCTAssertTrue(carsFromStorage[0].id == 1)
        XCTAssertTrue(carsFromStorage[0].type == "sedan")
        XCTAssertTrue(carsFromStorage[0].model == "toyota")
        XCTAssertTrue(carsFromStorage[0].color == "black")
        guard let owner = carsFromStorage[0].owners?.first  else {
            XCTFail("No test data")
            return
        }
        
        XCTAssertTrue(owner.id == 123)
        XCTAssertTrue(owner.name == "Test Owner")
        XCTAssertTrue(owner.phone == "9379992")
        
        XCTAssertTrue(carsFromStorage[1].id == 2)
        XCTAssertTrue(carsFromStorage[1].type == "crossover")
        XCTAssertTrue(carsFromStorage[1].model == "suzuki")
        XCTAssertTrue(carsFromStorage[1].color == "red")
        XCTAssertTrue(carsFromStorage[1].owners!.isEmpty)
    }
    
    func test_storage_shouldDeleteCars() {
        let cars = generateCars(count: 5)
        
        _ = sut.createCars(cars).toBlocking().materialize()
        
        _ = sut.deleteAllCars().toBlocking().materialize()
        
        let carsFromStorage = try! sut.cars().toBlocking().first()!
        
        XCTAssertTrue(carsFromStorage.isEmpty)
    }
    
    private func generateCar() -> CarModel {
        let owner = CarOwner(id: 123, name: "Test Owner", phone: "9379992")
        let car = CarModel(id: 123, type: "sedan", model: "toyota", color: "black", owners: [owner])
        
        return car
    }
    
    private func generateCars(count: UInt) -> [CarModel] {
        var cars: [CarModel] = []
        for _ in 0..<count {
            cars.append(generateCar())
        }
        
        return cars
    }
}
