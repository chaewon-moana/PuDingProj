//
//  CategoryDetailViewController.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryDetailViewController: BaseViewController {
    
    let mainView = CategoryView()
    let viewModel = CategoryViewModel()
    
    lazy var categoryList = BehaviorRelay(value: categoryData.allCases)

    var closure: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        mainView.collectionView.register(CategoryDetailCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryDetailCollectionViewCell")
        categoryList
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: "CategoryDetailCollectionViewCell", cellType: CategoryDetailCollectionViewCell.self)) { index, item, cell in
                cell.titleLabel.text = item.rawValue
            }
            .disposed(by: disposeBag)
        
        
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func bind() {
        let input = CategoryViewModel.Input(categorySelected: mainView.collectionView.rx.modelSelected(categoryData.self))
        
        let output = viewModel.transform(input: input)
        
        output.categoryDismiss
            .bind(with: self) { owner, value in
                owner.closure?(value)
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
