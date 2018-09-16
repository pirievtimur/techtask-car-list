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
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
    
    private let disposeBag = DisposeBag()
    
    private lazy var viewModel: ViewModel = {
        let managedObjectModel = NSManagedObjectModel(with: "car_list", bundle: Bundle.main)!
        let coreDataStackProvider = CoreDataStackProvider(storeName: "CarsStore", objectModel: managedObjectModel)
        let contextExecutor = ContextExecutor(context: coreDataStackProvider.mainQueueContext)
        let repository = Repository<CarCoreData>(executor: contextExecutor)
        
        let storage = CarsStorage(repository: repository)
        let api = APIService()
        
        return ViewModel(carsListAPI: api, carsStorage: storage)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        bindInput()
        bindOutput()
    }
    
    func setupSubviews() {
        navigationItem.rightBarButtonItem = refreshButton
        
        tableView.register(UINib(nibName: "CarCell", bundle: nil), forCellReuseIdentifier: CarCell.identifier)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let cell = self?.tableView.cellForRow(at: indexPath) as? CarCell else { return }
            cell.expand()
        })
        .disposed(by: disposeBag)
    }
    
    func bindInput() {
        let refresh = refreshButton.rx.tap.asDriver()
        
        let input = ViewModel.Input(refreshAction: refresh)
        
        viewModel.bind(input: input)
    }
    
    func bindOutput() {
        let output = viewModel.output()
        
        output
            .cars
            .drive(tableView.rx.items(cellIdentifier: CarCell.identifier)) { (_, carModel, cell) in
                if let carCell = cell as? CarCell {
                    carCell.updateWithModel(model: carModel)
                    carCell.delegate = self
                }
            }.disposed(by: disposeBag)
        
        output
            .cars
            .map { String($0.count) }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        output
            .executingStatus
            .drive(onNext: { [weak self] executing in
                self?.navigationItem.rightBarButtonItem = executing ? nil : self?.refreshButton
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController: ExpandableCellDelegate {
    func updateCell(_ cell: UITableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

