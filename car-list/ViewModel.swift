import RxSwift
import RxCocoa

class ViewModel {
    
    struct Input {
        var refreshAction: Driver<Void>
    }
    
    struct Output {
        var cars: Driver<[CarModel]>
        var executingStatus: Driver<Bool>
    }
    
    private let disposeBag = DisposeBag()
    private let executingStatus = BehaviorSubject<Bool>(value: false)
    
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
            .asDriver(onErrorJustReturn: [])
            .do(onNext: { [weak self] _ in self?.setExecutionStatus(flag: true) },
                onCompleted: { [weak self] in self?.setExecutionStatus(flag: false) })
            .drive()
            .disposed(by: disposeBag)
    }
    
    private func setExecutionStatus(flag: Bool) {
        executingStatus.onNext(flag)
    }
    
    func output() -> Output {
        return .init(cars: carsStorage.cars().asDriver(onErrorJustReturn: []),
                     executingStatus: executingStatus.asDriver(onErrorJustReturn: false))
    }
}
