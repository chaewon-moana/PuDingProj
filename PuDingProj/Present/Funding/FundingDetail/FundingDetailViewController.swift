//
//  FundingDetailViewController.swift
//  PuDingProj
//
//  Created by cho on 5/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class FundingDetailViewController: BaseViewController {

    let mainView = FundingDetailView()
    let viewModel = FundingDetailViewModel()
    var images: Data?
    var imageData = PublishRelay<[Data?]>()
    var target = "88"
    var dueDate = "22"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.dueDateStepper.rx.value
            .subscribe(with: self) { owner, value in
                let day = Int(value)
                owner.dueDate = "\(value)"
                owner.mainView.dueDateValueLabel.text = "\(day)일"
                owner.viewModel.dueDateValue.accept("\(day)")
            }
            .disposed(by: disposeBag)
        
        mainView.targetStepper.rx.value
            .subscribe(with: self) { owner, value in
                let day = Int(value)
             //   owner.target = "\(value)"
                owner.mainView.targetValueLabel.text = "\(day)개"
                owner.viewModel.targetValue.accept("\(day)")
            }
            .disposed(by: disposeBag)
        
    }
    
    override func bind() {
        let targetValue = BehaviorRelay(value: self.target)
        let dueDateValue = BehaviorRelay(value: self.dueDate)
    
        let input = FundingDetailViewModel.Input(addImageButton: mainView.productImageAddButton.rx.tap.asObservable(),
                                                 saveFundingPost: mainView.saveButton.rx.tap.asObservable(),
                                                 productNameText: mainView.productNameTextField.rx.text.orEmpty.asObservable(),
                                                 productPriceText: mainView.productPriceTextField.rx.text.orEmpty.asObservable(),
                                                 targetText: targetValue.asObservable(),
                                                 dueDateText: dueDateValue.asObservable(),
                                                 shelterText: mainView.shelterTextField.rx.text.orEmpty.asObservable(),
                                                 productImage: imageData.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.addImageButton
            .drive(with: self) { owner, _ in
                owner.setImage()
            }
            .disposed(by: disposeBag)
        
        output.saveButtonTapped
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setImage() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    
    override func loadView() {
        view = mainView
    }

}
extension FundingDetailViewController: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            let itemProvider = results.first?.itemProvider
    
            if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { photo, error in
                    DispatchQueue.main.async { [self] in
                        let image = photo as? UIImage
                        let data = image?.jpegData(compressionQuality: 0.1)
                        self.mainView.productImageView.image = image
                        self.images = data
                        self.imageData.accept([images])
                        let imageList = [self.images]
                        self.viewModel.images.accept(imageList)
                    }
                }
            } else {
                print(#function, "이미지 입력에 문제생김!!!!")
            }
        }
}
