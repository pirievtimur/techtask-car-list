import RxSwift

protocol CarsStorageProtocol {
    func cars() -> Observable<[CarModel]>
    func createCars(_ cars: [CarModel]) -> Observable<[CarModel]>
}

enum CarsStorageError: Error {
    case notFound
    case fetchRequestFailed
}


class CarsStorage: CarsStorageProtocol {
    private let repository: Repository<CarCoreData>
    
    init(repository: Repository<CarCoreData>) {
        self.repository = repository
    }
    
    func cars() -> Observable<[CarModel]> {
        return repository.observe().map { $0.map { $0.asDomain() } }
    }
    
    func createCars(_ cars: [CarModel]) -> Observable<[CarModel]> {
        return repository.perform(transaction: { context -> [CarCoreData] in
            let carsToStore: [CarCoreData] = cars.map {
                let carEntity: CarCoreData = context.create()
                
                carEntity.id = Int64($0.id)
                carEntity.type = $0.type
                carEntity.model = $0.model
                carEntity.color = $0.color
                
                $0.owners?.forEach {
                    let carOwnerEntity: CarOwnerCoreData = context.create()
                    carOwnerEntity.id = Int64($0.id)
                    carOwnerEntity.name = $0.name
                    carOwnerEntity.phone = $0.phone
                }
                
                return carEntity
            }
            
            try context.save()
            
            return carsToStore
        })
        .asObservable()
        .map { $0.map { $0.asDomain() } }
    }
}
