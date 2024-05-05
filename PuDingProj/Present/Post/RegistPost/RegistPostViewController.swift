//
//  RegistPostViewController.swift
//  PuDingProj
//
//  Created by cho on 4/18/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class RegistPostViewController: BaseViewController {

    let mainView = RegistPostView()
    let viewModel = RegistPostViewModel()
    
    var imageList: [Data?] = []
    var collectionViewImageList: [UIImage?] = []
    lazy var items = BehaviorRelay(value: collectionViewImageList)
    var inputTrigger: () = ()
    private var selections = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    
    lazy var cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: nil)
    lazy var saveButton = UIBarButtonItem(title: "등록", style: .plain, target: self, action: nil)
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTrigger = ()
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        view.backgroundColor = .white
        mainView.imageCollectionView.register(RegistPostImageCollectionViewCell.self, forCellWithReuseIdentifier: "RegistPostImageCollectionViewCell")
        updateImages(items: items)
    }
    
    func updateImages(items: BehaviorRelay<[UIImage?]>) {
        items
            .bind(to: mainView.imageCollectionView.rx.items(cellIdentifier: "RegistPostImageCollectionViewCell", cellType: RegistPostImageCollectionViewCell.self)){ (index, model, cell) in
                cell.updateUI(image: model)
        }.disposed(by: disposeBag)
    }
    private func setImage() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 5
        configuration.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    override func bind() {
        let catogoryLabel = PublishRelay<String>()
        let trigger: BehaviorRelay<Void> = BehaviorRelay(value: ())
        
        let input = RegistPostViewModel.Input(
            postData: catogoryLabel.asObservable(),
            titleText: mainView.titleTextView.rx.text.orEmpty.asObservable(),
            contentText: mainView.contentTextView.rx.text.orEmpty.asObservable(),
            addImageButtonTapped: mainView.addImageButton.rx.tap.asObservable(),
            imageList: BehaviorRelay(value: imageList),
            inputSaveButtonTapped: saveButton.rx.tap.asObservable(),
            categoryButtonTapped: mainView.categoryButton.rx.tap.asObservable(), cancalButtonTapped: cancelButton.rx.tap.asObservable(),
            inputTrigger: trigger.asObservable())
    
        let output = viewModel.transform(input: input)
        
        output.presentImagePickerView
            .drive(with: self, onNext: { owner, _ in
                owner.setImage()
            })
            .disposed(by: disposeBag)
        
        output.categoryHalfModal
            .drive(with: self) { owner, _ in
                let vc = CategoryDetailViewController()
        
                vc.modalPresentationStyle = .pageSheet
        
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.delegate = self
                }
                owner.present(vc, animated: true)
                vc.closure = { value in
                    print(value)
                    owner.mainView.categoryButton.setTitle(value, for: .normal)
                    catogoryLabel.accept(value)
                }
            }
            .disposed(by: disposeBag)
        
        output.cancelButtonTapped
            .drive(with: self) { owner, _ in
                owner.showAlert(title: "글 작성을 취소할까요?", messgae: "작성 중인 글은 삭제됩니다", action: { _ in
                    owner.mainView.setInitView()
                    owner.collectionViewImageList.removeAll()
                    owner.imageList.removeAll()
                    owner.viewModel.updateImageList(value: owner.imageList)
                    owner.items.accept(owner.collectionViewImageList)
                    if let tabBarController = owner.navigationController?.tabBarController {
                        tabBarController.selectedIndex = 0
                        owner.navigationController?.popViewController(animated: true)
                    }
                })
            }
            .disposed(by: disposeBag)
        
        output.savePost
            .drive(with: self) { owner, _ in
                //TODO: Toast로 저장되었습니다! 뜨게 만들기
                owner.mainView.setInitView()
                owner.collectionViewImageList.removeAll()
                owner.imageList.removeAll()
                owner.viewModel.updateImageList(value: owner.imageList)
                owner.items.accept(owner.collectionViewImageList)
                if let tabBarController = owner.navigationController?.tabBarController {
                    tabBarController.selectedIndex = 0
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}



extension RegistPostViewController: PHPickerViewControllerDelegate {
    //TODO: 이미 있는 사진이라면 갤러리들어갔을 때, 체크되어있도록 만들기
    //TODO: 나갔다 들어와도 5개 이상,,,처리,,
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        var newSelections = [String: PHPickerResult]()
        for result in results {
            let identifier = result.assetIdentifier!
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        selections = newSelections
        
        for (_, result) in selections {
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { photo, error in
                    let image = photo as? UIImage
                    self.collectionViewImageList.append(image)
                    self.items.accept(self.collectionViewImageList)
                    let data = image?.jpegData(compressionQuality: 0.5)
                    self.imageList.append(data)
                    self.viewModel.updateImageList(value: self.imageList)
                }
            }
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
    
extension RegistPostViewController: UISheetPresentationControllerDelegate {
    
}
