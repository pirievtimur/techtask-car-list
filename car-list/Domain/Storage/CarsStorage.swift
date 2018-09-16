import RxSwift

protocol CarsStorageProtocol {
    func cars() -> Observable<Any>
    func createCar() -> Observable<Any>
}


class CarsStorage: CarsStorageProtocol {
    
    private let repository: Repository<CarCoreData>
    
    init(repository: Repository<CarCoreData>) {
        self.repository = repository
    }
    
    func cars() -> Observable<Any> {
        return .empty()
    }
    
    func createCar() -> Observable<Any> {
        return .empty()
    }
}
