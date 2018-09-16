import RxSwift
import RxCocoa

class ViewModel {
    
    struct Input {
        var refreshAction: Driver<Void>
        var clearAction: Driver<Void>
    }
    
    struct Output {
        var cars: Driver<[CarModel]>
    }
    
    private let disposeBag = DisposeBag()
    private let executingStatus = PublishSubject<Void>()
    
    private let carsListAPI: CarsListAPI
    private let carsStorage: CarsStorageProtocol
    
    init(carsListAPI: CarsListAPI, carsStorage: CarsStorageProtocol) {
        self.carsListAPI = carsListAPI
        self.carsStorage = carsStorage
    }
    
    func bind(input: Input) {
        input.refreshAction
            .asObservable()
            .flatMap { [weak self] _ in self?.carsListAPI.carsList() ?? .empty() }
            .flatMap { [weak self] in self?.carsStorage.createCars($0) ?? .empty() }
            .publish()
            .connect()
            .disposed(by: disposeBag)
        
        input.clearAction
            .asObservable()
            .flatMap { [weak self] _ in self?.carsStorage.deleteAllCars() ?? .empty() }
            .publish()
            .connect()
            .disposed(by: disposeBag)
    }

    func output() -> Output {
        return .init(cars: carsStorage.cars().asDriver(onErrorJustReturn: []))
    }
}
