//
//  MyInfoViewController.swift
//  PuDingProj
//
//  Created by cho on 4/13/24.
//

import UIKit
import RxCocoa
import RxSwift

class MyInfoViewController: BaseViewController {

    let mainView = MyInfoView()
    let viewModel = MyInfoViewModel()
    var trigger = PublishRelay<Void>()
    var postList = PublishRelay<[RegisterPostModel]>()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainView.mypostTableView.register(MyInfoTableViewCell.self, forCellReuseIdentifier: "MyInfoTableViewCell")
        mainView.mypostTableView.rowHeight = 100
        postList
            .bind(to: mainView.mypostTableView.rx.items(cellIdentifier: "MyInfoTableViewCell", cellType: MyInfoTableViewCell.self)) { (index, item, cell) in
                cell.updateUI(item: item)
            }
            .disposed(by: disposeBag)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trigger.accept(())
    }
    override func bind() {
        
        let input = MyInfoViewModel.Input(inputTrigger: trigger.asObservable(),
                                          withdrawButtonTapped: mainView.withdrawButton.rx.tap.asObservable(),
                                          settingButtonTapped: mainView.settingButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.profileInfo
            .subscribe(with: self) { owner, model in
                owner.mainView.updateUI(item: model)
                
            }
            .disposed(by: disposeBag)
        
        output.moveToEditInfo
            .subscribe(with: self) { owner, model in
                let vc = EditMyInfoViewController()
                vc.item = model
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.resultList
            .drive(with: self) { owner, postList in
                owner.postList.accept(postList)
                owner.mainView.mypostTableView.reloadData()
            }
            .disposed(by: disposeBag)
    }
}
