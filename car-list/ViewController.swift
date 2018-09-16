//
//  ViewController.swift
//  car-list
//
//  Created by Timur Piriev on 9/16/18.
//  Copyright © 2018 Timur Piriev. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class ViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let managedObjectModel = NSManagedObjectModel(with: "car_list", bundle: Bundle.main)!
        let coreDataStackProvider = CoreDataStackProvider(storeName: "CarsStore", objectModel: managedObjectModel)
        let contextExecutor = ContextExecutor(context: coreDataStackProvider.mainQueueContext)
        let repository = Repository<CarCoreData>(executor: contextExecutor)
        let _ = CarsStorage(repository: repository)
        
        let api = APIService()
        
        api.carsList().subscribe(onSuccess: {
            print($0)
        }).disposed(by: disposeBag)
    }
}

