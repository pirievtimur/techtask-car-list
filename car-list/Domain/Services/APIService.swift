import RxSwift
import ObjectMapper

protocol CarsListAPI {
    func carsList() -> Single<[CarModel]>
}

class APIService {}

extension APIService: CarsListAPI {
    func carsList() -> Single<[CarModel]> {
        return Observable.create { observer -> Disposable in
            DispatchQueue.global().async { [weak self] in
                guard let weakSelf = self else { return }
                let results = weakSelf.generateData()
                
                DispatchQueue.main.async {
                    observer.onNext(results)
                    observer.onCompleted()
                }
            }

            return Disposables.create()
        }
        .subscribeOn(MainScheduler.instance)
        .asSingle()
    }
    
    private func generateData() -> [CarModel] {
        let data = jsonString().data(using: .utf8)!
        do {
            var result: [CarModel] = []
            guard let jsonArray = try JSONSerialization
                .jsonObject(with: data, options : .allowFragments) as? Array<AnyObject> else { return result }
            
            if let cars = Mapper<CarModel>().mapArray(JSONObject: jsonArray) {
                result = cars
            }
            
            return result
        } catch {
            fatalError("check json")
        }
    }
    
    private func jsonString() -> String {
        return
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
                },
                {
                    "car_id" : 2,
                    "car_type" : "hydbrid/electric",
                    "car_model" : "Toyota Prius",
                    "car_color" : "blue",
                    "owners": [
                        {
                            "owner_id" : 2,
                            "owner_name" : "Anton",
                            "owner_phone" : "+38012345678"
                        }
                    ]
                },
                {
                    "car_id" : 3,
                    "car_type" : "wagon",
                    "car_model" : "Ford Focus",
                    "car_color" : "black",
                    "owners": [
                        {
                            "owner_id" : 3,
                            "owner_name" : "Stepan",
                            "owner_phone" : "+38012345678"
                        }
                    ]
                }
            ]
            """
    }
}
