//
//  FundingDetailView.swift
//  PuDingProj
//
//  Created by cho on 5/5/24.
//

import UIKit
import SnapKit

final class FundingDetailView: BaseView {
    
    let productImageView = UIImageView()
    let productImageAddButton = UIButton()
    let productNameTextField = LoginTextField(placeHolderText: "상품명을 입력해주세요")
    let productPriceTextField = LoginTextField(placeHolderText: "상품가격을 입력해주세요")
    let targetNumberLabel = UILabel()
    let targetValueLabel = UILabel()
    let targetStepper = UIStepper()
    //let targetWheel = UIPickerView()
    let dueDateLabel = UILabel()
    let dueDateValueLabel = UILabel()
    let dueDateStepper = UIStepper()
    let shelterLabel = UILabel()
    let shelterTextField = LoginTextField(placeHolderText: "보호소 이름을 입력해주세요")
    let saveButton = UIButton()
    
    
    override func configureViewLayout() {
        self.addSubviews([productImageView, productImageAddButton, productNameTextField, productPriceTextField, targetNumberLabel, targetValueLabel,targetStepper, dueDateLabel, dueDateValueLabel, dueDateStepper, shelterLabel, shelterTextField, saveButton])
        
        productImageView.snp.makeConstraints { make in
            make.size.equalTo(180)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        productImageAddButton.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        productNameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(productImageAddButton.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        productPriceTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(productNameTextField.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        targetNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(productPriceTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(100)
        }
        targetValueLabel.snp.makeConstraints { make in
            make.top.equalTo(productPriceTextField.snp.bottom).offset(16)
            make.leading.equalTo(targetNumberLabel.snp.trailing).offset(12)
        }
        targetStepper.snp.makeConstraints { make in
            make.leading.equalTo(targetValueLabel.snp.trailing).offset(16)
            make.centerY.equalTo(targetValueLabel)
        }
        dueDateLabel.snp.makeConstraints { make in
            make.top.equalTo(targetNumberLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(100)
        }
        dueDateValueLabel.snp.makeConstraints { make in
            make.top.equalTo(targetNumberLabel.snp.bottom).offset(16)
            make.leading.equalTo(dueDateLabel.snp.trailing).offset(12)
        }
        dueDateStepper.snp.makeConstraints { make in
            make.leading.equalTo(dueDateValueLabel.snp.trailing).offset(16)
            make.centerY.equalTo(dueDateValueLabel)
        }
        shelterTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(dueDateLabel.snp.bottom).offset(16)
            make.height.equalTo(50)
        }
        saveButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(40)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
    
    }
    
    override func configureAttribute() {
        productImageView.image = UIImage(named: "PudingLogo")
        productImageView.clipsToBounds = true
        productImageView.layer.cornerRadius = 20
        productImageAddButton.setTitle("이미지 등록하기", for: .normal)
        productImageAddButton.setTitleColor(.gray, for: .normal)
        productImageAddButton.titleLabel?.font = .systemFont(ofSize: 14)
        productPriceTextField.keyboardType = .numberPad
        targetNumberLabel.text = "목표 갯수"
        dueDateLabel.text = "목표 기한"
        shelterLabel.text = "후원보호소"
        saveButton.backgroundColor = .red
        saveButton.setTitle("저장", for: .normal)
        dueDateStepper.value = 0
        dueDateStepper.stepValue = 1
        dueDateStepper.minimumValue = 5
        dueDateStepper.maximumValue = 30
        
        targetStepper.value = 0
        targetStepper.stepValue = 10
        targetStepper.minimumValue = 10
        targetStepper.maximumValue = 100
    }
}
