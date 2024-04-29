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
    private var selections = [String: PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    
    lazy var cancelButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: nil)
    
    override func loadView() {
        view = mainView
    }
    
//    let title: String
//    let content: String
//    let content1: String //게시글 분류
//    let product_id: String //puding-moana22 -> Test용
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelButton
        view.backgroundColor = .white
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
        let input = RegistPostViewModel.Input(
            titleText: mainView.titleTextView.rx.text.orEmpty.asObservable(),
            contentText: mainView.contentTextView.rx.text.orEmpty.asObservable(),
            addPostButtonTapped: mainView.addPostButton.rx.tap.asObservable(),
            addImageButtonTapped: mainView.addImageButton.rx.tap.asObservable(),
            imageList: BehaviorRelay(value: imageList),
            tmpButtonTapped: mainView.tmpButton.rx.tap.asObservable(),
            categoryButtonTapped: mainView.categoryButton.rx.tap.asObservable(), cancalButtonTapped: cancelButton.rx.tap.asObservable())
    
        
        
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
                }
            }
            .disposed(by: disposeBag)
        
        output.cancelButtonTapped
            .drive(with: self) { owner, _ in
                owner.showAlert(title: "글 작성을 취소할까요?", messgae: "작성 중인 글은 삭제됩니다", action: { _ in
                    if let tabBarController = owner.navigationController?.tabBarController {
                        tabBarController.selectedIndex = 0
                        owner.navigationController?.popViewController(animated: true)
                    }
                })
            }
            .disposed(by: disposeBag)

    }
}



extension RegistPostViewController: PHPickerViewControllerDelegate {
    
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
                   //self.mainView.testImageView.image = image
                    let data = image?.jpegData(compressionQuality: 0.5)
                    self.imageList.append(data)
                    //self.viewModel.imageList.accept(self.imageList)
                    print(self.imageList, "imageList 확인")
                    self.viewModel.updateImageList(value: self.imageList)
                }
            }
        }
        
//        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//            itemProvider.loadObject(ofClass: UIImage.self) { photo, error in
//                DispatchQueue.main.async { [self] in
//                    let image = photo as? UIImage
//                    self.mainView.testImageView.image = image
//                    let data = image?.jpegData(compressionQuality: 0.5)
//                    imageList = [data]
//                    //ImageFileManager.shared.saveImageToDocument(imageName: "임시테스트.jpg", image: image!)
//                }
//            }
//        } else {
//            print(#function, "이미지 입력에 문제생김!!!!")
//        }
    }
    
    
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true)
//        let itemProvider = results.first?.itemProvider
//        
//        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//            itemProvider.loadObject(ofClass: UIImage.self) { photo, error in
//                DispatchQueue.main.async { [self] in
//                    let image = photo as? UIImage
//                    self.mainView.testImageView.image = image
//                    let data = image?.jpegData(compressionQuality: 0.5)
//                    imageList = [data]
//                    //ImageFileManager.shared.saveImageToDocument(imageName: "임시테스트.jpg", image: image!)
//                }
//            }
//        } else {
//            print(#function, "이미지 입력에 문제생김!!!!")
//        }
//    }
}
extension RegistPostViewController: UISheetPresentationControllerDelegate {
    
}
