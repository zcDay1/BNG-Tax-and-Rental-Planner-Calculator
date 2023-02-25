//
//  ViewController.swift
//  BNG-FS-APP
//
//  Created by Alex Chen in 2021.
//  Copyright © 2022 Alex Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let smallFsize: CGFloat = 23
    let bngBlue: CGColor = CGColor(srgbRed: 40/255, green: 80/255, blue: 180/255, alpha: 1)
    
    var selectedOption: Int = 0
    var pickerData: [String] = [String]()
    var menuScreenIndex: Int = 0
    
    let startMenuButton = UIButton(type: UIButton.ButtonType.system)
    let backButton1 = UIButton(type: UIButton.ButtonType.system)
    let backButton2 = UIButton(type: UIButton.ButtonType.system)
    
    var logoView = UIImageView()
    var logoImage = UIImage()
    var logoLabel = UILabel()
    
    let scroller = UIPickerView(frame: CGRect(x: 80, y: 200, width: 200, height: 200))
    
    var startLogoOffsetX: CGFloat = 0
    var startLogoOffsetYTop: CGFloat = 0
    var startLogoOffsetYBot: CGFloat = 0
    
    var webpgMessage: UITextView = {
        var msg = UITextView()
        msg.frame = CGRect(x: 0, y: 0, width: 200, height: 5)
        msg.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 0.2))
        msg.isScrollEnabled = false
        //msg.backgroundColor = UIColor.systemIndigo
        
        msg.isEditable = false
        msg.dataDetectorTypes = .link
        
        msg.text = "For more financial advice, visit us: www.bngconsultancy.com"
        return msg
    }()
    
    let indivIncomeTitle = UILabel(frame: CGRect(x: 100, y: 175, width: 30, height: 30))
    let indivIncomeLabel = UILabel(frame: CGRect(x: 100, y: 175, width: 30, height: 30))
    
    var statIndivIncNumDbl: Double = 0.00
    var statRentNumDbl: Double = 0.00

    let indivIncomeTextField: UITextField = {
        var textfield = UITextField()
        textfield.frame = CGRect(x: 0, y: 0, width: 100, height: 10)
        textfield.clearButtonMode = .whileEditing
        // changed on build0403
        textfield.keyboardType = UIKeyboardType.decimalPad
        textfield.backgroundColor = UIColor.systemGray4
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        //UI styling needs to be declared again after adding into the UIStackView as a subview bc it gets messed up in the process by the stackview system!!
        textfield.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(rawValue: 0.4))
        textfield.textColor = UIColor.darkGray
        textfield.placeholder = "Your Gross Income"
        textfield.borderStyle = UITextField.BorderStyle.roundedRect
        textfield.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.4))
        textfield.text = "0.00"
        return textfield
    }()
        
    let indivIncomeTaxCalculatorButton: UIButton = {
        var iITaxCalcButton = UIButton(type: .system)
        iITaxCalcButton.frame = CGRect(x: 100, y: 150, width: 160, height: 20)
        iITaxCalcButton.setTitle("Calculate", for: UIControl.State.normal)
        iITaxCalcButton.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight(0.4))
        return iITaxCalcButton
    }()
    
    // added this function in build0401
    let indivRentIncomeButton: UIButton = {
        var indivRentButton = UIButton(type: .system)
        // Must-Do instructions for uiimage on button
        // go to xcassets catalog, select the image,
        // go to the right hand panel and select "Render as: original image" otherwise the image wont appear on the button!!!
        var button_icon = UIImage(named: "addRentIncome.png")
        indivRentButton.frame = CGRect(x: 50, y: 50, width: 55, height: 55)
        indivRentButton.setImage(button_icon, for: .normal)
        indivRentButton.setBackgroundImage(button_icon, for: .selected)
        indivRentButton.backgroundColor = UIColor.white
        return indivRentButton
    }()
    
    let indivIncomeOverlay: UIView = {
        // added in build0402
        var overlay = UIView()
        overlay.frame = CGRect(x: 0, y: 0, width: UIScreen.main.nativeBounds.width, height: UIScreen.main.nativeBounds.height)
        overlay.backgroundColor = UIColor.black
        overlay.layer.zPosition = 2
        overlay.alpha = 0.8
        return overlay
    }()
    
    var firstTimeIncTax = 0
    
    let indivIncomeOverlayText: UILabel = {
        // added in build0402
        var overlay = UILabel()
        overlay.frame = CGRect(x: 0, y: 0, width: UIScreen.main.nativeBounds.width, height: UIScreen.main.nativeBounds.height)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        // see indivOverlayTextAnchors() for setting up the anchors
        overlay.numberOfLines = 27
        overlay.text = "Welcome to the Individual Income Tax calculator!\n\nThis calculator can assist income tax, medicare levy and medicare levy surcharge calculation in accordance with the tax table provided by the ATO in 2021-2022FY, on the condition that you are an Australian resident for tax purpose. The calculated taxable income is an estimated figure for your reference only. Your final taxable income is subject to ATO’s decision.\n\nThere are two modules in this calculator: (1) Income Tax Calculator, (2) Rental Income Calculator. If you don’t have investment property, but only employment income, using income tax calculator will be sufficient. If you have both employment income and investment rental property income, you can use the Rental Income Calculator to work out the net rental income which will be add on the top of your net taxable income when you press the blue button at the right hand corner of Income Tax Calculator.\n"
            
        overlay.textColor = UIColor.white
        overlay.textAlignment = .left
        overlay.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 0.2))
        overlay.lineBreakMode = .byWordWrapping
        overlay.backgroundColor = UIColor.clear
        overlay.layer.zPosition = 3
        overlay.alpha = 1
        return overlay
    }()
        
    // added in build0205B 18 January 2022
    var indivIncomeStackViewA: UIStackView = {
        var istackView = UIStackView()
        istackView.axis = .vertical
        istackView.alignment = .fill
        istackView.distribution = .fillProportionally
        //istackView.backgroundColor = UIColor.green
        return istackView
    }()
    
    // added this function in build0401
    var indivIncomeStackViewH1: UIStackView = {
        var istackView = UIStackView()
        istackView.axis = .horizontal
        istackView.alignment = .fill
        istackView.distribution = .fillProportionally
        //istackView.backgroundColor = UIColor.blue
        return istackView
    }()
    
    // added in build0207
    var indivIncomeStackViewB: UIStackView = {
        var istackView = UIStackView()
        istackView.axis = .vertical
        istackView.alignment = .fill
        istackView.distribution = .equalCentering
        istackView.spacing = 0
        //istackView.backgroundColor = UIColor.brown
        return istackView
    }()
    
    var indivIncomeStackViewM: UIStackView = {
        var istackView = UIStackView()
        istackView.axis = .vertical
        istackView.alignment = .fill
        // changed in build0207
        istackView.distribution = .fillProportionally
        return istackView
    }()
    
    // added in build0206 and build0207
    var indivIncDisclaimerLabel: UILabel = {
        var iidLabel = UILabel()
        iidLabel.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        iidLabel.text = "Disclaimer: These are estimated values according to 2021-2022 financial year figures provided by the ATO."
        iidLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.1))
        iidLabel.numberOfLines = 3
        iidLabel.lineBreakMode = .byWordWrapping
        return iidLabel
    }()
    
    // [ IMPORTANT!!! ] - ADDED IN BUILD0205C
    //BANDAGE METHOD UILABEL "SIZINGVIEW":
    var sizingView: UILabel = {
        var vieww = UILabel()
        vieww.backgroundColor = UIColor.clear
        vieww.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        vieww.text = "Hellos"
        vieww.textColor = UIColor.clear
        vieww.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 0.4))
        return vieww
    }()
    
    
    var taxResult: Double = 0
    var totalIncome: Double = 0
    var taxLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
    var netLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
    var taxValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
    var netValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 30, height: 10))
    var grossIncomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    
    var medicareLevyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var medicareLevyValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var medicareLevyValue: Double = 0.0
    
    var medicareLevySurchargeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var medicareLevySurchargeValueLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
    var medicareLevySurchargeValue: Double = 0.0
    
    
    var div1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
    var div2 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 10))

    var rentalIncTitleLabel = UILabel()
    var totalRevLabel = UILabel()

    // added build0404
    var rentCalcAddSntl = 0
    
    let rentalRevTextField: UITextField = {
        var rRevTextfield = UITextField()
        rRevTextfield.clearButtonMode = .whileEditing
            //Changed in Build0205C
        rRevTextfield.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        // updated build0403
        rRevTextfield.keyboardType = UIKeyboardType.decimalPad
        rRevTextfield.backgroundColor = UIColor.systemGray4
        rRevTextfield.borderStyle = UITextField.BorderStyle.roundedRect
        rRevTextfield.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight(rawValue: 0.4))
        rRevTextfield.textColor = UIColor.darkGray
        rRevTextfield.placeholder = "Rental Revenue"
        rRevTextfield.text = "0.00"
        return rRevTextfield
    }()
    
    var totalRentalExpenseLabel = UILabel()
    var totalRentalExpenseValueLabel = UILabel()
    var totalRentalExpenseButton = UIButton()
    var netIncomeLabel = UILabel()
    var netIncomeValueLabel = UILabel()
    var calculateRentIncButton = UIButton()
    
    var netRentalIncomeValue: Double = 0.0
    
    var rentalExpenseScrollView = UIScrollView()
    var spacerOffset:CGFloat = 0
    
    var grossRentalIncome: Double = 0.0

    var grossRentalExpenses: Double = 0.0
    var addingRentalExpenses: Double = 0.0

    var advertisingForTenantsD: Double = 0.0
    var bodyCorporateFeesE: Double = 0.0
    var borrowingExpensesF: Double = 0.0
    var cleaningExpenseG: Double = 0.0
    var councilRatesH: Double = 0.0
    var capAllowancesDeprOnPlantI: Double = 0.0
    var gardeningExpensesJ: Double = 0.0
    var insuranceK: Double = 0.0
    var interestLoanExpensesL: Double = 0.0
    var landTaxM: Double = 0.0

    var legalFeesN: Double = 0.0
    var pestControlO: Double = 0.0
    var propertyAgentFeeP: Double = 0.0
    var repairsMaintenanceQ: Double = 0.0
    var capitalWorksR: Double = 0.0
    var landlineCostsS: Double = 0.0
    var travelExpensesT: Double = 0.0
    var waterExpensesU: Double = 0.0
    var electricalExpenses: Double = 0.0
    var gasUtilityExpenses: Double = 0.0
    var sundryRentalExpensesV: Double = 0.0
    
    // help page variables and constants
    var helpLabel = UILabel()
    var logoView2 = UIImageView()
    

    struct tableCell {
        let labelv: UILabel = {
            var labelview = UIKit.UILabel()
            labelview.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(0.5))
            labelview.text = "  expense1"
            return labelview
        }()
        
        let textfieldv: UITextField = {
            var textfield = UITextField()
            textfield = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
            // changed in build0506
            textfield.keyboardType = UIKeyboardType.numberPad
            textfield.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight(0.5))
            textfield.placeholder = " $0.00"
            //textfield.text = "$0"
            textfield.backgroundColor = UIColor.systemGray5
            textfield.textAlignment = NSTextAlignment.right
            textfield.borderStyle = UITextField.BorderStyle.roundedRect
            return textfield
        }()
        
        let cellv: UIView = {
            var cellview = UIView()
            cellview.frame = CGRect(x: 0, y: 0, width: 390, height: 30)
            cellview.backgroundColor = UIColor.white
            cellview.layer.borderWidth = 2
            cellview.layer.borderColor = UIColor.white.cgColor
            cellview.translatesAutoresizingMaskIntoConstraints = false
            return cellview
        }()
    }
    
    
    
    
    
    
    // Start of functions
    
    
    func setUpIndivIncTxtfield(){
        print("setupindivinctextfield()")
        addDoneButtonOnKeyboard()
        
        indivIncomeTaxCalculatorButton.addTarget(self, action: #selector(ViewController.actionIndivIncomeButton(_:)), for: .touchUpInside)
        // added build0401
        indivRentIncomeButton.addTarget(self, action: #selector(ViewController.actionIndivRentButton(_:)), for: .touchUpInside)
    }
    
    func setUprentalRevTextField(){
        print("setuprentalrevtextfield()")
// figure out what to do with this function after cleaning
        addDoneButtonOnKeyboard()
    }
    
    func setUpBackButton1(){
        print("setupBackButton1()")
        //THIS ONLY SETS WHAT THE BACK BUTTON IS, YOU STILL NEED TO ADD IT AS SUBVIEW IN A VIEW'S SETUP FUNC WHEN YOU WANT TO HAVE A BACKBUTTON APPEAR ON A VIEW!!!!
        backButton1.frame = CGRect(x: 20, y: 30, width: 100, height: 40)
        backButton1.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(0.1))
        backButton1.setTitle("< Back", for: UIControl.State.normal)
        
        backButton1.addTarget(self, action: #selector(ViewController.actionBackButton1(_:)), for: .touchUpInside)
    }
    
    func setUpBackButton2(){
        print("setupbackbutton2()")
        //THIS ONLY SETS WHAT THE BACK BUTTON IS, YOU STILL NEED TO ADD IT AS SUBVIEW IN A VIEW'S SETUP FUNC WHEN YOU WANT TO HAVE A BACKBUTTON APPEAR ON A VIEW!!!!
        
        //IS BACKBUTTON2 NOT ALIGNED VIA NSCONSTRAINTS SYSTEM, IS IT ALIGNED ACCORDING TO THE COORDINATE SYSTEM OF THE VIEWS THAT IT IS ATTACHED TO???
        backButton2.frame = CGRect(x: 0, y: 30, width: 100, height: 40)
        backButton2.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(0.1))
        backButton2.setTitle("< Back", for: UIControl.State.normal)
        
        backButton2.addTarget(self, action: #selector(ViewController.actionBackButton2(_:)), for: .touchUpInside)
    }
    
    func indivIncomeStackviewsPt1() {
        print("indivincomestackviewspt1()")
        // created in build0406C

        // changed in build0205B
        indivIncomeStackViewA.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height*0.1)
        
        // build0401: I have not set default size for frame of indivIncomeStackViewH1 horizontal stackview containing the netValue label and the rental income addition button
        
        // changed in build0207 and build0510A
        indivIncomeStackViewB.frame = CGRect(x: 0, y: view.bounds.height*0.10, width: view.bounds.width, height: view.bounds.height*0.16)
        indivIncomeStackViewM.frame = CGRect(x: 0, y: view.bounds.height*0.20, width: view.bounds.width, height: view.bounds.height*0.66)
        indivIncomeStackViewM.backgroundColor = UIColor.white
        
        view.addSubview(indivIncomeStackViewM)
        
        //v below code added in [Build0205B] creates the internal padding for the UIStackView !!!
        indivIncomeStackViewM.spacing = UIStackView.spacingUseSystem
        indivIncomeStackViewM.isLayoutMarginsRelativeArrangement = true
        indivIncomeStackViewM.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        indivIncomeStackViewB.spacing = UIStackView.spacingUseSystem
        indivIncomeStackViewB.isLayoutMarginsRelativeArrangement = true
        indivIncomeStackViewB.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        //added in build0207
        indivIncomeStackViewM.addArrangedSubview(sizingView)
        view.addSubview(indivIncomeStackViewB)
        // added in build0207
        indivIncomeStackViewB.addArrangedSubview(indivIncomeTitle)
        // added in build0510A
        indivIncomeStackViewB.addArrangedSubview(webpgMessage)
        // added in build0207
        indivIncomeStackViewB.addArrangedSubview(indivIncomeLabel)
        

        indivIncomeLabel.backgroundColor = UIColor.clear
        
        indivIncomeStackViewM.addArrangedSubview(indivIncomeTextField)
        
        indivIncomeStackViewM.addArrangedSubview(indivIncomeStackViewA)
        indivIncomeStackViewM.addArrangedSubview(indivIncomeTaxCalculatorButton)
        
        
    }
    
    func indivIncomeStackviewsPt2() {
        // added in build0406C
        print("indivincomestackviewspt2()")
        
        // changed in build0205B
        indivIncomeStackViewA.addArrangedSubview(taxLabel)
        indivIncomeStackViewA.addArrangedSubview(taxValueLabel)
        
        view.addSubview(backButton1)
        
        indivIncomeStackViewA.addArrangedSubview(medicareLevyLabel)
        indivIncomeStackViewA.addArrangedSubview(medicareLevyValueLabel)
        indivIncomeStackViewA.addArrangedSubview(medicareLevySurchargeLabel)
        indivIncomeStackViewA.addArrangedSubview(medicareLevySurchargeValueLabel)
        
        // added build0401
        indivIncomeStackViewA.addArrangedSubview(indivIncomeStackViewH1)
        indivIncomeStackViewH1.addArrangedSubview(netLabel)
        indivIncomeStackViewH1.addArrangedSubview(indivRentIncomeButton)
        
        indivIncomeStackViewA.addArrangedSubview(netValueLabel)

        //build0207
        indivIncomeStackViewA.heightAnchor.constraint(equalToConstant: view.frame.height*0.38)
        
        
    }
    
    func indivIncOverlayConstraints() {
        // created in build0406C
        
        print("indivincoverlayconstraints()")
        indivIncomeOverlayText.translatesAutoresizingMaskIntoConstraints = false
        indivIncomeOverlayText.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        indivIncomeOverlayText.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        
        indivIncomeOverlayText.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        indivIncomeOverlayText.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -50).isActive = true
        
    }
    
    func indivIncTextSetup() {
        // created in build0406C
        
        print("indivinctextsetup()")
        // added in build0405C
        var smallFsizeFont = UIFont.systemFont(ofSize: smallFsize, weight: UIFont.Weight(0.4))
        
        indivIncomeTitle.font = UIFont.systemFont(ofSize: 27, weight: UIFont.Weight(0.4))
        indivIncomeLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight(0.4))
        taxLabel.font = smallFsizeFont
        netLabel.font = smallFsizeFont
        taxValueLabel.font = smallFsizeFont
        netValueLabel.font = smallFsizeFont
        medicareLevyLabel.font = smallFsizeFont
        medicareLevyValueLabel.font = smallFsizeFont
        // added in build0205B
        medicareLevySurchargeLabel.font = smallFsizeFont
        medicareLevySurchargeValueLabel.font = smallFsizeFont
        
        // changed in build0510B
        indivIncomeTitle.textColor = UIColor(cgColor: bngBlue)
        //indivIncomeTitle.backgroundColor = UIColor.red
        indivIncomeTitle.text = "Income Tax Calculator"
        indivIncomeLabel.textColor = UIColor.darkGray
        //indivIncomeLabel.backgroundColor = UIColor.green
        
        indivIncomeLabel.text = "Gross Income"
        taxLabel.textColor = UIColor.darkGray
        taxLabel.text = "Tax"
        netLabel.textColor = UIColor.darkGray
        netLabel.text = "Net Income"
        taxValueLabel.textColor = UIColor.darkGray
        taxValueLabel.text = "$0.00"
        netValueLabel.textColor = UIColor.darkGray
        netValueLabel.text = "$0.00"
        medicareLevyLabel.textColor = UIColor.darkGray
        medicareLevyLabel.text = "Medicare Levy"
        medicareLevyValueLabel.textColor = UIColor.darkGray
        medicareLevyValueLabel.text = "$0.00"
        //added in build0205B
        medicareLevySurchargeLabel.text = "Medicare Levy Surcharge"
        medicareLevySurchargeLabel.textColor = UIColor.darkGray
        
        medicareLevySurchargeValueLabel.text = "$0.00"
        medicareLevySurchargeValueLabel.textColor = UIColor.darkGray
        
    }
    
    func layOutIndivIncomeView() {
    
        print("layoutindivincomeview()")
        backButton1.translatesAutoresizingMaskIntoConstraints = false

        // added build0207
        view.addSubview(indivIncDisclaimerLabel)
        indivIncDisclaimerLabel.frame = CGRect(x: 20, y: view.frame.height-90, width: view.frame.width-30, height: 60)
        
        indivIncomeStackviewsPt1()
        indivIncomeStackviewsPt2()

        indivIncomeTextField.heightAnchor.constraint(equalToConstant: view.bounds.height*0.07).isActive = true
  
        // added in build0401, build0402
        if firstTimeIncTax == 0 {
            view.addSubview(indivIncomeOverlay)
            view.addSubview(indivIncomeOverlayText)
            
            indivIncOverlayConstraints()
        }
        
        indivIncTextSetup()

        /*   if calculatorButtonOffset = view.bounds.maxY * 0.125
         then it is equal to: startMenuButtonOffset = view.bounds.maxY * 0.125
         these are CGFLOAT values   */
        
        let calculatorButtonOffset = view.bounds.maxY * 0.125
        let leadingTrailingAnchorOffset = view.bounds.maxX * 0.05
        //print(leadingTrailingAnchorOffset)
        let spacerOffset = view.bounds.maxY * 0.01
        //print("spacer offset value = \(spacerOffset)")
        
        //backButton1
        backButton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset).isActive = true
        backButton1.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: spacerOffset).isActive = true

        /*IMPORTANT!!!!!!!!: UIVIEW MUST BE FINALISED AND DECLARED BEFORE IT IS ADDED TO ANOTHER VIEW AS A SUBVIEW. OTHERWISE IT WILL MAKE AN ERROR SAYING THE UIVIEW HAS NO COMMON ANCESTOR WITH THE ROOT VIEWCONTROLLER's UIVIEW AND IT IS ILLEGAL TO CREATE NSLAYOUT CONSTRAINTS BETWEEN UNRELATED VIEWs.*/
    // not sure if ^this comment is relevant here anymore.
        
            div1.translatesAutoresizingMaskIntoConstraints = false
            div2.translatesAutoresizingMaskIntoConstraints = false
            div1.backgroundColor = UIColor.systemGray4
            div2.backgroundColor = UIColor.systemGray4
        
        if firstTimeIncTax == 0 {
            // added in build0402
            let indivIncomeOverlayGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            indivIncomeOverlayText.addGestureRecognizer(indivIncomeOverlayGesture)
            indivIncomeOverlayText.isUserInteractionEnabled = true
            //print("layoutIndivIncomeView")
        }
    }
    
    
    

    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("objc handletap for overlay ()")
        // added in build0402
        // needs to come after the uiview overlay is added to the main view as a subview otherwise it wont work
        
        //print("touch registered on overlay")
// IMPORTANT: NEED TO FIGURE OUT A WAY TO REMOVE THE GESTURE RECOGNIZER IN CASE IT ISNT AUTOMATICALLY REMOVED
        indivIncomeOverlay.removeFromSuperview()
        indivIncomeOverlayText.removeFromSuperview()
        // turns off the overlay
        firstTimeIncTax = 1
    }
    
    
    func layOutRentalIncomeView(){
        print("layoutrentalincomeview() ")
        // !!!must specify what type the button is in order for it to show up.!!!
        calculateRentIncButton = UIButton(type: UIButton.ButtonType.system)
        //don't need to specify frame in order for button to show up. layoutAnchors not required either for it to show up.
        calculateRentIncButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        rentalIncTitleLabel.numberOfLines = 2
        totalRentalExpenseButton = UIButton(type: UIButton.ButtonType.system)
        
        rentalIncTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        totalRevLabel.translatesAutoresizingMaskIntoConstraints = false
        rentalRevTextField.translatesAutoresizingMaskIntoConstraints = false
        totalRentalExpenseLabel.translatesAutoresizingMaskIntoConstraints = false
        totalRentalExpenseValueLabel.translatesAutoresizingMaskIntoConstraints = false
        netIncomeLabel.translatesAutoresizingMaskIntoConstraints = false
        netIncomeValueLabel.translatesAutoresizingMaskIntoConstraints = false
        totalRentalExpenseButton.translatesAutoresizingMaskIntoConstraints = false
        calculateRentIncButton.translatesAutoresizingMaskIntoConstraints = false
        div1.translatesAutoresizingMaskIntoConstraints = false
        div2.translatesAutoresizingMaskIntoConstraints = false
        backButton1.translatesAutoresizingMaskIntoConstraints = false
        
        calculateRentIncButton.addTarget(self, action: #selector(ViewController.actionRentalCalculatorButton(_:)), for: .touchUpInside)
        totalRentalExpenseButton.addTarget(self, action: #selector(ViewController.actionRentalExpenseButton(_:)), for: .touchUpInside)
        
        view.addSubview(rentalIncTitleLabel)
        view.addSubview(totalRevLabel)
        view.addSubview(rentalRevTextField)
        view.addSubview(totalRentalExpenseLabel)
        view.addSubview(totalRentalExpenseValueLabel)
        view.addSubview(netIncomeLabel)
        view.addSubview(netIncomeValueLabel)
        view.addSubview(totalRentalExpenseButton)
        view.addSubview(calculateRentIncButton)
        view.addSubview(div1)
        view.addSubview(div2)
        view.addSubview(backButton1)
        
        view.addSubview(webpgMessage)
        webpgMessage.translatesAutoresizingMaskIntoConstraints = false
        //webpgMessage.frame = CGRect(x: view.frame.width/2, y: ( - (view.frame.height*0.22)), width: (view.frame.width*0.90), height: view.frame.height*0.22)
        
        rentalIncTitleLabel.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight(0.3))
        rentalIncTitleLabel.text = "Rental Income Calculator"
        let bngBlue: CGColor = CGColor(srgbRed: 40/255, green: 80/255, blue: 180/255, alpha: 1)
        rentalIncTitleLabel.textColor = UIColor(cgColor: bngBlue)
        
        // added in build0405C
        var smallFsizeFontP3 = UIFont.systemFont(ofSize: smallFsize, weight: UIFont.Weight(0.3))
        
        totalRevLabel.font = smallFsizeFontP3
        totalRevLabel.text = "Total Revenue"
        totalRevLabel.textColor = UIColor.darkGray
        
        totalRentalExpenseLabel.font = smallFsizeFontP3
        totalRentalExpenseLabel.text = "Total Expenses"
        totalRentalExpenseLabel.textColor = UIColor.darkGray
        
        totalRentalExpenseValueLabel.font = smallFsizeFontP3
        totalRentalExpenseValueLabel.text = "$0.00"
        totalRentalExpenseValueLabel.textColor = UIColor.darkGray
        
        netIncomeLabel.font = smallFsizeFontP3
        netIncomeLabel.text = "Net Income"
        netIncomeLabel.textColor = UIColor.darkGray
        
        netIncomeValueLabel.font = smallFsizeFontP3
        netIncomeValueLabel.text = "$0.00"
        netIncomeValueLabel.textColor = UIColor.darkGray
        
        totalRentalExpenseButton.setTitle(" Expenses ", for: UIControl.State.normal)
        totalRentalExpenseButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        totalRentalExpenseButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.4))
        totalRentalExpenseButton.layer.borderColor = UIColor.systemBlue.cgColor
        totalRentalExpenseButton.layer.borderWidth = 1
        
        calculateRentIncButton.setTitle("Calculate", for: UIControl.State.normal)
        calculateRentIncButton.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight(rawValue: 0.4))
      
        let calculatorButtonOffset = view.bounds.maxY * 0.125
        let leadingTrailingAnchorOffset = view.bounds.maxX * 0.05
        let spacerOffset = view.bounds.maxY * 0.01
        
        div1.backgroundColor = UIColor.systemGray4
        div2.backgroundColor = UIColor.systemGray4

        
        NSLayoutConstraint.activate([
        //rentalIncTitleLabel
            rentalIncTitleLabel.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 1*calculatorButtonOffset),
            rentalIncTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset),
            rentalIncTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2*leadingTrailingAnchorOffset),
        //calclulateRentIncButton
            calculateRentIncButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -calculatorButtonOffset),
            //!!!! view.bottom anchor references bottomAnchor of Frame, not bounds nor layOutMarginGuide.
            calculateRentIncButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
        //div1
            div1.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            div1.topAnchor.constraint(equalTo: rentalIncTitleLabel.bottomAnchor, constant: 2*spacerOffset),
            div1.bottomAnchor.constraint(equalTo: rentalIncTitleLabel.bottomAnchor, constant: 2*spacerOffset+3),

            div1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            div1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        //totalRevLabel
            totalRevLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset),
            totalRevLabel.topAnchor.constraint(equalTo: div1.centerYAnchor, constant: 2*spacerOffset),
            totalRevLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingTrailingAnchorOffset),
        //totalRevTextField
            rentalRevTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset),
            rentalRevTextField.topAnchor.constraint(equalTo: totalRevLabel.bottomAnchor, constant: 0.5*spacerOffset),
            rentalRevTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingTrailingAnchorOffset),
         //totalRentalExpenseLabel
            totalRentalExpenseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset),
            totalRentalExpenseLabel.topAnchor.constraint(equalTo: totalRevLabel.bottomAnchor, constant: 7.5*spacerOffset),
            rentalRevTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingTrailingAnchorOffset),
            
        //totalRentalExpenseValueLabel
            totalRentalExpenseValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset),
            totalRentalExpenseValueLabel.topAnchor.constraint(equalTo: totalRentalExpenseLabel.bottomAnchor, constant: 0.5*spacerOffset),
            totalRentalExpenseValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingTrailingAnchorOffset),
            
        //netIncomeLabel
            netIncomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset),
            netIncomeLabel.topAnchor.constraint(equalTo: totalRentalExpenseLabel.bottomAnchor, constant: 7.5*spacerOffset),
            netIncomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -leadingTrailingAnchorOffset),
        //netIncomeValueLabel
            netIncomeValueLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset),
            netIncomeValueLabel.topAnchor.constraint(equalTo: netIncomeLabel.bottomAnchor, constant: 0.5*spacerOffset),
                
        //div2
            div2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            div2.topAnchor.constraint(equalTo: calculateRentIncButton.centerYAnchor, constant: -43),
            div2.bottomAnchor.constraint(equalTo: calculateRentIncButton.centerYAnchor, constant: -40),

            div2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            div2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        // webpgMessage
            // added in build0510B
            webpgMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            webpgMessage.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -22),
            webpgMessage.bottomAnchor.constraint(equalTo: div2.topAnchor, constant: 0),
            webpgMessage.topAnchor.constraint(equalTo: div2.topAnchor, constant: -(view.frame.height * 0.10)),
        
       //totalRentalExpenseButton
            //this is declared in the order behind div2 because it relies on div2 anchor constraints so div2 anchor constraints must be declared first.
            
            totalRentalExpenseButton.trailingAnchor.constraint(equalTo: rentalRevTextField.trailingAnchor, constant: 0),
            totalRentalExpenseButton.centerYAnchor.constraint(equalTo: totalRentalExpenseValueLabel.centerYAnchor, constant: 0),
            
        //back button 1
            backButton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset),
            backButton1.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: spacerOffset)
        ])
    }
    
    
    func layoutHelpView(){
        print("layouthelpview()")
        //offset values
        let spacerOffset = view.bounds.maxY * 0.01
        let startMenuButtonOffset = view.bounds.maxY * 0.125
        startLogoOffsetX = view.bounds.width * 0.25
        startLogoOffsetYTop = view.bounds.height * 0.33
        let vbhOffset = view.bounds.width * 0.5 * 0.30
        startLogoOffsetYBot = startLogoOffsetYTop + vbhOffset
        let leadingTrailingAnchorOffset = view.bounds.maxX * 0.05
        
        helpLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        
        // in combination with appropriate NSLayout constraints, will allow UILabel to begin new lines automatically and within the screen.
        helpLabel.lineBreakMode = .byWordWrapping
        helpLabel.numberOfLines = 0
        
        helpLabel.text = "The BNG Consultancy app contains modules which assist your financial wellbeing. \n\nCurrently, these include an income tax calculator and a rental income/expense calculator. \n\nThe rates and figures displayed in this app are determined based on information acquired from the Australian Tax Office in the 2021-2022 financial year and may not be accurate for financial use outside of Australia and the Australian 2021-2022 financial year.\n\nThe calculated taxable income is an estimated figure for your reference only. Your final taxable income is subject to ATO’s decision.\n\nMore features will be added in future updates."
        helpLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 0.2))
        
        backButton1.translatesAutoresizingMaskIntoConstraints = false
        helpLabel.translatesAutoresizingMaskIntoConstraints = false
        logoView2.translatesAutoresizingMaskIntoConstraints = false
        
        logoImage = UIImage(named: "bng.png")!
        logoView2.frame = CGRect(x: 0, y: 0, width: logoImage.size.width, height: logoImage.size.height)
        logoView2.image = logoImage

        view.addSubview(logoView2)
        view.addSubview(helpLabel)
        view.addSubview(backButton1)
        //bng logo file dimensions ratio is currently 92x380
        
        //prevents dark mode from changing the interface colours across the whole app
        view.overrideUserInterfaceStyle = .light
        
        NSLayoutConstraint.deactivate([
        // I DON'T THINK THIS CODE WORKS PROPERLY TO DEACTIVATE THE CONSTRAINTS DEFINED IN VIEWDIDLOAD() FOR THE START MENU CONTENT!!!!!
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startLogoOffsetX),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -startLogoOffsetX),
            
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: startLogoOffsetYTop),
            logoView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: startLogoOffsetYBot),
            
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            logoLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: vbhOffset*0.5)
        ])
        
        NSLayoutConstraint.activate([
            //backButton1
            backButton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingTrailingAnchorOffset),
            backButton1.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: spacerOffset),
           
            //logoview
            logoView2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            //logoView2.centerYAnchor.constraint(equalTo: view.topAnchor, constant: startLogoOffsetYTop+46),
            //THIS CODE HERE DETERMINES THE DIMENSIONS OF THE BNG LOGO ON THE HELP PAGE, I.E. 380x92
            logoView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startLogoOffsetX),
            logoView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -startLogoOffsetX),
            
            logoView2.topAnchor.constraint(equalTo: view.topAnchor, constant: startLogoOffsetYTop),
            logoView2.bottomAnchor.constraint(equalTo: view.topAnchor, constant: startLogoOffsetYTop+46),
            
            //help label
            //no need for center X and Y constraints; will conflict with top anchor, leading,trailing,bottom constraints
            helpLabel.topAnchor.constraint(equalTo: logoView2.bottomAnchor, constant: 20),
            helpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            helpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            //helpLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
        ])
    }
    
    
    
    
    @objc func actionStartButton(_ sender:UIButton!){
        print("objc actionstartbutton ()")
        
        if menuScreenIndex == 0 {
            
            print("income tax calculator")
            setUpIndivIncTxtfield()
            setUpBackButton1()
            layOutIndivIncomeView()
            
            self.scroller.removeFromSuperview()
            self.startMenuButton.removeFromSuperview()
            logoLabel.removeFromSuperview()
            logoView.removeFromSuperview()
            
        }   else if menuScreenIndex == 1 {
            print("start button clicked for rental income calculator")
            self.scroller.removeFromSuperview()
            self.startMenuButton.removeFromSuperview()
            logoLabel.removeFromSuperview()
            logoView.removeFromSuperview()
            
            setUprentalRevTextField()
            layOutRentalIncomeView()
            setUpBackButton1()
            
        }   else if menuScreenIndex == 2 {
            print("start button clicked but other option")
            layoutHelpView()
            
            self.scroller.removeFromSuperview()
            self.startMenuButton.removeFromSuperview()
            logoLabel.removeFromSuperview()
            logoView.removeFromSuperview()
            setUpBackButton1()
        }
    }
    
    
    @objc func actionBackButton1(_ sender:UIButton){
        print("objc actionbackbutton1 ()")
        
        viewDidLoad()
        if menuScreenIndex == 0 {
            
            //for indiv inc calculator page
            indivIncomeTitle.removeFromSuperview()
            indivIncomeTextField.removeFromSuperview()
            indivIncomeTaxCalculatorButton.removeFromSuperview()
            taxLabel.removeFromSuperview()
            indivIncomeLabel.removeFromSuperview()
            taxValueLabel.removeFromSuperview()
            netLabel.removeFromSuperview()
            netValueLabel.removeFromSuperview()
            medicareLevyLabel.removeFromSuperview()
            medicareLevyValueLabel.removeFromSuperview()
            medicareLevySurchargeLabel.removeFromSuperview()
            medicareLevySurchargeValueLabel.removeFromSuperview()
            
            // added in build0401
            indivIncDisclaimerLabel.text = "Disclaimer: These are estimated values according to 2021-2022 financial year figures provided by the ATO."
            indivIncDisclaimerLabel.textColor = UIColor.black
            indivIncDisclaimerLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.1))

            // added in build0510A
            webpgMessage.removeFromSuperview()
            
            // added in build0408DC
            // this is necessary to avoid warnings and Autolayout freaking out over the removal of the indivRentIncomeButton which ... isn't in this hierachy but still is affecting the layout?!?
            // also in previous versions I forgot to remove these stackviews lol.
                // what else did I forget to write code for? have a think.
            indivIncomeStackViewA.removeFromSuperview()
            indivIncomeStackViewB.removeFromSuperview()
            indivIncomeStackViewM.removeFromSuperview()
            indivIncomeStackViewH1.removeFromSuperview()
            
            indivIncDisclaimerLabel.removeFromSuperview()
            backButton1.removeFromSuperview()
            indivRentIncomeButton.removeFromSuperview()
            
        } else if menuScreenIndex == 1 {
            
            //div1 div2 removed here
            div1.removeFromSuperview()
            div2.removeFromSuperview()
            
            //removed stackviews
            indivIncomeStackViewM.removeFromSuperview()
            indivIncomeStackViewA.removeFromSuperview()
            //this removes the bandage method UILabel from the indiv income tax calculator view
            sizingView.removeFromSuperview()
            
            // added in build0510B
            webpgMessage.removeFromSuperview()
            
            //back button itself removed here
            backButton1.removeFromSuperview()
            
            //for rental income calc page
            rentalIncTitleLabel.removeFromSuperview()
            totalRevLabel.removeFromSuperview()
            rentalRevTextField.removeFromSuperview()
            //div1 div2 already removed from above method call.
            //div1.removeFromSuperview()
            //div2.removeFromSuperview()
            totalRentalExpenseLabel.removeFromSuperview()
            totalRentalExpenseValueLabel.removeFromSuperview()
            totalRentalExpenseButton.removeFromSuperview()
            calculateRentIncButton.removeFromSuperview()
            netIncomeLabel.removeFromSuperview()
            netIncomeValueLabel.removeFromSuperview()
            
            //rental expenses page is handled by backbutton2
        } else if menuScreenIndex == 2 {
            //for help page
            logoView2.removeFromSuperview()
            helpLabel.removeFromSuperview()
            
            backButton1.removeFromSuperview()
        }
        
        // the rental revenue expenses page makes the background color of "view" to systemGray
        // changed in Build0205C
        view.backgroundColor = UIColor.white
    }
    
    
    
    
    
    
    
    let tableCell1 = tableCell()
    let tableCell2 = tableCell()
    let tableCell3 = tableCell()
    let tableCell4 = tableCell()
    let tableCell5 = tableCell()
    let tableCell6 = tableCell()
    let tableCell7 = tableCell()
    let tableCell8 = tableCell()
    let tableCell9 = tableCell()
    let tableCell10 = tableCell()
    let tableCell11 = tableCell()
    let tableCell12 = tableCell()
    let tableCell13 = tableCell()
    let tableCell14 = tableCell()
    let tableCell15 = tableCell()
    let tableCell16 = tableCell()
    let tableCell17 = tableCell()
    let tableCell18 = tableCell()
    let tableCell19 = tableCell()
    let tableCell20 = tableCell()
    
    
    @objc func actionBackButton2(_ sender:UIButton) {
        print("objc actionbackbutton2 ()")
        
        // created in build0406C
        removeRentalExpPage()
        // changed in build0406C
        setUprentalRevTextField()
        layOutRentalIncomeView()
        backButton2.removeFromSuperview()
        rentalExpenseScrollView.removeFromSuperview()
        rentalTotalExpense()

        // the rental revenue expenses page makes the background color of "view" to systemGray
        // changed in Build0205C
        view.backgroundColor = UIColor.white
    }
    
    
    
    func rentalTotalExpense() {
        // created in build0406C
        
        print("rentaltotalexpense()")
        
        grossRentalExpenses = 0.0
        var tableCellSentinel = 0
        var tableCellTxtFArray = [tableCell1.textfieldv, tableCell2.textfieldv, tableCell3.textfieldv, tableCell4.textfieldv, tableCell5.textfieldv, tableCell6.textfieldv, tableCell7.textfieldv, tableCell8.textfieldv, tableCell9.textfieldv, tableCell10.textfieldv, tableCell11.textfieldv, tableCell12.textfieldv, tableCell13.textfieldv, tableCell14.textfieldv, tableCell15.textfieldv, tableCell16.textfieldv, tableCell17.textfieldv, tableCell18.textfieldv, tableCell19.textfieldv]
        while (tableCellSentinel < 19) {
            getRentalExpensesTableCell(tableCellTxtFArray[tableCellSentinel], tableCellNumber: tableCellSentinel)
            //print("\(grossRentalExpenses)")
            tableCellSentinel = tableCellSentinel + 1
        }
        
        //print("grossRentalExpenses \(grossRentalExpenses)")
        //print("addingRentalExpenses \(addingRentalExpenses)")
        totalRentalExpenseValueLabel.text = "$\(grossRentalExpenses.formattedWithSeparator)"
            // changed in build0509
    }
    
    
    func removeRentalExpPage() {
        // created in build0406C
        print("removerentalexppage()")
        
        //remove cellv loop
        var tableCellSentinel1 = 0
        var tableCellTxtFArray1 = [tableCell1.textfieldv, tableCell2.textfieldv, tableCell3.textfieldv, tableCell4.textfieldv, tableCell5.textfieldv, tableCell6.textfieldv, tableCell7.textfieldv, tableCell8.textfieldv, tableCell9.textfieldv, tableCell10.textfieldv, tableCell11.textfieldv, tableCell12.textfieldv, tableCell13.textfieldv, tableCell14.textfieldv, tableCell15.textfieldv, tableCell16.textfieldv, tableCell17.textfieldv, tableCell18.textfieldv, tableCell19.textfieldv]
        
        while (tableCellSentinel1 < 19) {
            tableCellTxtFArray1[tableCellSentinel1].removeFromSuperview()
            tableCellSentinel1 = tableCellSentinel1 + 1
        }
        //print("removed all rentalExp textfields")
        
        //remove labelv loop
        var tableCellSentinel2 = 0
        var tableCellTxtFArray2 = [tableCell1.labelv, tableCell2.labelv, tableCell3.labelv, tableCell4.labelv, tableCell5.labelv, tableCell6.labelv, tableCell7.labelv, tableCell8.labelv, tableCell9.labelv, tableCell10.labelv, tableCell11.labelv, tableCell12.labelv, tableCell13.labelv, tableCell14.labelv, tableCell15.labelv, tableCell16.labelv, tableCell17.labelv, tableCell18.labelv, tableCell19.labelv]
        
        while (tableCellSentinel2 < 19) {
            tableCellTxtFArray2[tableCellSentinel2].removeFromSuperview()
            tableCellSentinel2 = tableCellSentinel2 + 1
        }
        //print("removed all rentalExp Labels")
        
        //remove cellv loop
        var tableCellSentinel3 = 0
        var tableCellTxtFArray3 = [tableCell1.cellv, tableCell2.cellv, tableCell3.cellv, tableCell4.cellv, tableCell5.cellv, tableCell6.cellv, tableCell7.cellv, tableCell8.cellv, tableCell9.cellv, tableCell10.cellv, tableCell11.cellv, tableCell12.cellv, tableCell13.cellv, tableCell14.cellv, tableCell15.cellv, tableCell16.cellv, tableCell17.cellv, tableCell18.cellv, tableCell19.cellv]
        
        while (tableCellSentinel3 < 19) {
            tableCellTxtFArray3[tableCellSentinel3].removeFromSuperview()
            tableCellSentinel3 = tableCellSentinel3 + 1
        }
        //print("removed all rentalExp cells")
    }
    
    
    
    @objc func actionRentalExpenseButton(_ Sender:UIButton){
        print("objc actionrentalexpensebutton ()")
    
        //for rental income calc page
        rentalIncTitleLabel.removeFromSuperview()
        totalRevLabel.removeFromSuperview()
        rentalRevTextField.removeFromSuperview()
        div1.removeFromSuperview()
        div2.removeFromSuperview()
        totalRentalExpenseLabel.removeFromSuperview()
        totalRentalExpenseValueLabel.removeFromSuperview()
        totalRentalExpenseButton.removeFromSuperview()
        calculateRentIncButton.removeFromSuperview()
        netIncomeLabel.removeFromSuperview()
        netIncomeValueLabel.removeFromSuperview()
        setUpBackButton2()
        backButton1.removeFromSuperview()
        // added in buil0510B
        webpgMessage.removeFromSuperview()
        
        //scrollViewView.frame = CGRect(x: 0, y: -100, width: view.bounds.width, height: 1700)
        //scrollViewView height doesn't need to be bigger or equal to rentalExpenseScrollView contentSize for it to work !!!!
        rentalExpenseScrollView.overrideUserInterfaceStyle = .light
        rentalExpenseScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.frame.height))
        
        view.addSubview(rentalExpenseScrollView)
        
        rentalExpenseScrollView.overrideUserInterfaceStyle = .light
        view.addSubview(backButton2)
        
        // CONTENTSIZE HEIGHT MUST BE BIGGER THAN SCROLLVIEW FRAME HEIGHT IN ORDER FOR IT TO BE SCROLLABLE !!!!!
        rentalExpenseScrollView.contentSize = CGSize(width: rentalExpenseScrollView.frame.width-view.layoutMargins.left-view.layoutMargins.right, height: 1600)
            // build0200: if I don't subtract the layoutmargins left and right values from the frame contentsize then itll leave a big margin and allow horizontal scrolling which is not desirable. This affects rentalExpStackViewA's frame size setting on line 1116.
       
        rentalExpenseScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        rentalExpenseScrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        rentalExpenseScrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        rentalExpenseScrollView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        rentalExpenseScrollView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        
        view.backgroundColor = UIColor.systemGray5
        rentalExpenseScrollView.backgroundColor = UIColor.clear
        rentalExpenseScrollView.showsHorizontalScrollIndicator = false
        
        //tableCell1.setupTableCell()
        tableCell1.labelv.text = " Advertising For Tenants"
        
        //tableCell2.setupTableCell()
        tableCell2.labelv.text = " Body Corporate Fees"
        tableCell3.labelv.text = " Borrowing Expenses"
        tableCell4.labelv.text = " Cleaning Expense"
        tableCell5.labelv.text = " Council Rates"
        tableCell6.labelv.text = " Capital Allowances Depreciation "
        tableCell7.labelv.text = " Gardening Expenses"
        tableCell8.labelv.text = " Insurance"
        tableCell9.labelv.text = " Interest Loan Expenses"
        tableCell10.labelv.text = " Land Tax"
        tableCell11.labelv.text = " Legal Fees"
        tableCell12.labelv.text = " Pest Control"
        tableCell13.labelv.text = " Property Agent Fee"
        tableCell14.labelv.text = " Repairs and Maintenance"
        tableCell15.labelv.text = " Capital Works"
        tableCell16.labelv.text = " Landline Expenses"
        tableCell17.labelv.text = " Travel Expenses"
        tableCell18.labelv.text = " Water Expenses"
        tableCell19.labelv.text = " Sundry Rental Expenses"
        
        
        tableCell20.labelv.text = " Total expenses: \(grossRentalExpenses)   "
        tableCell20.labelv.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight(0.3))
        
        let bngBlue: CGColor = CGColor(srgbRed: 40/255, green: 80/255, blue: 180/255, alpha: 1)
        tableCell20.labelv.textColor = UIColor(cgColor: bngBlue)
        tableCell20.labelv.textAlignment = NSTextAlignment.center
        
        self.addDoneButtonOnKeyboard()
        
        // adding tablecells and their subviews
        // add cellv loop
        var tableCellSentinel5 = 0
        //var tableCellSentinel6 = 0
        //var tableCellSentinel7 = 0
        
        var tableCellTxtFArray7 = [tableCell1.cellv, tableCell2.cellv, tableCell3.cellv, tableCell4.cellv, tableCell5.cellv, tableCell6.cellv, tableCell7.cellv, tableCell8.cellv, tableCell9.cellv, tableCell10.cellv, tableCell11.cellv, tableCell12.cellv, tableCell13.cellv, tableCell14.cellv, tableCell15.cellv, tableCell16.cellv, tableCell17.cellv, tableCell18.cellv, tableCell19.cellv]
        
        var tableCellTxtFArray6 = [tableCell1.labelv, tableCell2.labelv, tableCell3.labelv, tableCell4.labelv, tableCell5.labelv, tableCell6.labelv, tableCell7.labelv, tableCell8.labelv, tableCell9.labelv, tableCell10.labelv, tableCell11.labelv, tableCell12.labelv, tableCell13.labelv, tableCell14.labelv, tableCell15.labelv, tableCell16.labelv, tableCell17.labelv, tableCell18.labelv, tableCell19.labelv]
        
        var tableCellTxtFArray5 = [tableCell1.textfieldv, tableCell2.textfieldv, tableCell3.textfieldv, tableCell4.textfieldv, tableCell5.textfieldv, tableCell6.textfieldv, tableCell7.textfieldv, tableCell8.textfieldv, tableCell9.textfieldv, tableCell10.textfieldv, tableCell11.textfieldv, tableCell12.textfieldv, tableCell13.textfieldv, tableCell14.textfieldv, tableCell15.textfieldv, tableCell16.textfieldv, tableCell17.textfieldv, tableCell18.textfieldv, tableCell19.textfieldv]
        
        
        // added in build0187
        var rentalExpStackViewA: UIStackView = {
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .fillEqually
            return rstackView
        }()
        
        // added in buil0189
        var rentalExpStackView1: UIStackView = {
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView2: UIStackView = {
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView3: UIStackView = {
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView4: UIStackView = {
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView5: UIStackView = {
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView6: UIStackView = {
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView7: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView

        }()
        
        var rentalExpStackView8: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView

        }()
        
        var rentalExpStackView9: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView

        }()
        
        var rentalExpStackView10: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView

        }()
        
        var rentalExpStackView11: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView12: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView13: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView14: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView15: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView16: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView17: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView18: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView19: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        var rentalExpStackView20: UIStackView = {
            
            var rstackView = UIStackView()
            rstackView.axis = .vertical
            rstackView.alignment = .fill
            rstackView.distribution = .equalSpacing
            rstackView.isLayoutMarginsRelativeArrangement = true
            rstackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            return rstackView
        }()
        
        // added in build0187
        rentalExpenseScrollView.addSubview(rentalExpStackViewA)
        
        // added in buil0189
        var tableCellSVArray = [rentalExpStackView1, rentalExpStackView2, rentalExpStackView3, rentalExpStackView4, rentalExpStackView5, rentalExpStackView6, rentalExpStackView7, rentalExpStackView8, rentalExpStackView9, rentalExpStackView10, rentalExpStackView11, rentalExpStackView12, rentalExpStackView13, rentalExpStackView14, rentalExpStackView15, rentalExpStackView16, rentalExpStackView17, rentalExpStackView18, rentalExpStackView19]
        
        var stackviewSentinel = 0
        
        while (stackviewSentinel < 19) {
            /* important notes: build0190 and build0200
             view -> uiscrollview -> rentalExpStackViewA -> many stackviews
             rentalExpStackViewA needs a defined frame, directly defined, e.g. via CGRect, NOT a layout-defined frame otherwise it won't appear when the app runs, nor will its child views appear.
             
             UIStackViews need to have defined frames. In this case I set it to the content size of the parent view.
             
             */
            rentalExpStackViewA.frame = CGRect(x: 0, y: 0, width: rentalExpenseScrollView.contentSize.width, height: rentalExpenseScrollView.contentSize.height)
            rentalExpStackViewA.backgroundColor = UIColor.white
            
            rentalExpStackViewA.addArrangedSubview(tableCellSVArray[stackviewSentinel])
            
            tableCellSVArray[stackviewSentinel].addArrangedSubview(tableCellTxtFArray6[stackviewSentinel])
            
            tableCellSVArray[stackviewSentinel].addArrangedSubview(tableCellTxtFArray5[stackviewSentinel])
            print(stackviewSentinel)
            stackviewSentinel = stackviewSentinel + 1
        }
    }
    
    
    
    
    
    
    
    //funcs dealing with updating the total at the bottom of the expense list 21st May 2021
    func updateRentalExpenseTotal(){
        print("updaterentalexpensetotal()")
        tableCell20.labelv.text = "Total expenses: \(grossRentalExpenses)   "
        tableCell20.labelv.textAlignment = NSTextAlignment.center
    }
    
    
    
    func setupExpenseListTotal(){
        print("setupexpenselisttotal()")
        grossRentalExpenses = 0
        var tableCellSentinel = 0
        var tableCellTxtFArray = [tableCell1.textfieldv, tableCell2.textfieldv, tableCell3.textfieldv, tableCell4.textfieldv, tableCell5.textfieldv, tableCell6.textfieldv, tableCell7.textfieldv, tableCell8.textfieldv, tableCell9.textfieldv, tableCell10.textfieldv, tableCell11.textfieldv, tableCell12.textfieldv, tableCell13.textfieldv, tableCell14.textfieldv, tableCell15.textfieldv, tableCell16.textfieldv, tableCell17.textfieldv, tableCell18.textfieldv, tableCell19.textfieldv]
        
        while (tableCellSentinel < 19) {
            getRentalExpensesTableCell(tableCellTxtFArray[tableCellSentinel], tableCellNumber: tableCellSentinel)
            //print("\(grossRentalExpenses)")
            tableCellSentinel = tableCellSentinel + 1
        }
        updateRentalExpenseTotal()
    }
    
    
    
    // changed in build0301
    func getTextIndivTaxField(_ sender:UITextField!){
        print("gettextindivtaxfield()")
        //info is called in actionIndivIncomeButton(_ sender: UIButton!) func
        
        // the .filter() is what allows the textfield to get input that is numerical-only, no commas, only numbers and decimal points!!!!!!!!
        var prefixa = String((indivIncomeTextField.text?.filter("0123456789.".contains).prefix(7))!)
        
        
        //print("\(indivIncomeTextField.text)")
        //var totalIncomeInt = Int(prefixa)
        //print(totalIncomeInt)
        //totalIncome = Double(totalIncomeInt ?? 0)
        totalIncome = Double(prefixa) ?? 0.00
        //print("hello \(totalIncome)")
    }
    
    
    
    func getTextRentalRevTextField(_ sender:UITextField!){
        print("gettextrentalrevtextfield()")
        //info is called in actionRentalCalculatorButton(_ sender: UIButton!) func
        
        // changed in build0503
        // the .filter() is what allows the textfield to get input that is numerical-only, no commas, only numbers and decimal points!!!!!!!!
        var prefixaRental = String((rentalRevTextField.text?.filter("0123456789.".contains).prefix(7))!)
        //print("\(rentalRevTextField.text)")
        netRentalIncomeValue = Double(prefixaRental) ?? 0
        //print("hello \(netRentalIncomeValue)")
        // this line below is necessary for calculation to function correctly. do not change.
        //grossRentalIncome = netRentalIncomeValue
    }
    
    
    @objc func actionRentalCalculatorButton(_ sender: UIButton){
        rentCalcAddSntl = 0
        print("objc actionrentalcalculatorbutton ()")
        
        getTextRentalRevTextField(rentalRevTextField)
        //total rental rev is grossRentalIncome.
        //total rental expenses is grossRentalExpenses.
        netRentalIncomeValue = netRentalIncomeValue - grossRentalExpenses
        var nIVLFormatted = netRentalIncomeValue.formattedWithSeparator
        netIncomeValueLabel.text = "$\(nIVLFormatted)"
    }
    
    
    
    @objc func actionIndivIncomeButton(_ sender:UIButton!){
        print("objc actionindivincomebutton ()")
        //getTextIndivTaxField(indivIncomeTextField)
            // moved to "Done button"
    
        // moved here in build0404 from the "done button"
        //
        getTextIndivTaxField(indivIncomeTextField)
        calculateIndivIncomeTax(grossIncomeOne: totalIncome)
        //print("hi\(totalIncome)")
        
        //changed in build0205
        let netValue = totalIncome - Double(taxResult) - Double(medicareLevyValue+medicareLevySurchargeValue)
        //taxLabel.text = "Tax = $\(taxResult), net = $\(netValue)"
        taxLabel.text = "Tax"
        netLabel.text = "Net income"
        
        // added build0501
        // this is how they need to be formatted, idk why it didnt work when I directly tried to .formattedWithSeparator the first time.
        var taxResFormatted = taxResult.formattedWithSeparator
        var netValFormatted = netValue.formattedWithSeparator
        
        taxValueLabel.text = "$\(taxResFormatted)"
        netValueLabel.text = "$\(netValFormatted)"
        //when txtfield resigns first responder status the keyboard will go away
        //https://www.cometchat.com/tutorials/how-to-dismiss-ios-keyboard-swift
        //DONT LEAVE THIS LINK IN THE FINAL VERSON !!!!!!!!
        indivIncomeTextField.resignFirstResponder()
        
        // changed in build0401
        indivIncDisclaimerLabel.text = "Disclaimer: These are estimated values according to 2021-2022 financial year figures provided by the ATO."
        indivIncDisclaimerLabel.textColor = UIColor.black
        indivIncDisclaimerLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 0.1))
    }
    

    
    @objc func actionIndivRentButton(_ sender:UIButton!){
        print("objc actionindivrentbutton ()")
        // function added in build0401
        // copied then modified from actionIndivIncomeButton(_ sender:UIButton!)
        //print("indivRent button pressed")
        // added in build0404
        
        // major changes in build0409RO
        if rentCalcAddSntl == 0 {
            if netRentalIncomeValue + totalIncome > 0 {
                rentCalcAddSntl = 1
                // additional if statement added in build0507
                print("netRentalIncomeValue + totalIncome > 0")
                
                statIndivIncNumDbl = statIndivIncNumDbl + netRentalIncomeValue
                
                //print("added rent to income calculator")
                
                indivIncomeTextField.text = String("\(statIndivIncNumDbl)")
                
                // added in build0506G
                // what a simple fix compared to trying to store the number and add it back in before the final indiv tax calculation...
                totalIncome = statIndivIncNumDbl
                
                indivIncDisclaimerLabel.text = "Added Rental Income to tax calculation."
                indivIncDisclaimerLabel.textColor = UIColor.systemGreen
                indivIncDisclaimerLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.2))
            } else if netRentalIncomeValue + totalIncome < 0 {
                indivIncDisclaimerLabel.text = "Rental income + gross personal income < $0."
                // added in build0510B
                indivIncDisclaimerLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.2))
                
                print("netRentalIncomeValue + totalIncome > 0")
                indivIncDisclaimerLabel.textColor = UIColor.red
            }
        } else {
            indivIncDisclaimerLabel.text = "Subtracted rental income from gross income."
            // added in build0510B
            indivIncDisclaimerLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 0.2))
            
            indivIncDisclaimerLabel.textColor = UIColor.red
            statIndivIncNumDbl = statIndivIncNumDbl - netRentalIncomeValue
            indivIncomeTextField.text = String("\(statIndivIncNumDbl)")
            rentCalcAddSntl = rentCalcAddSntl - 1
        }
        
        formatIndivIncGrossInc()

    }

    
    
    func calculateIndivIncomeTax(grossIncomeOne: Double){
        print("calculateindivincometax()")
        //added 9th december, 2nd module after adding UIpickerview yesterday 8th december 2020.
        let bracketOne = 18200.0
        let bracketTwo = 45000.0
        let bracketThree = 120000.0
        let bracketFour = 180000.0
        let bracketFive = 350000.0
        
        func calculateTax(grossIncome: Double){
            var tax = 0.0
            if grossIncome <= bracketOne {
                tax = 0
            }   else if grossIncome <= bracketTwo {
                tax = (grossIncome - bracketOne)*0.19
            }   else if grossIncome <= bracketThree {
                tax = (grossIncome - bracketTwo)*0.325 + 5092
            }   else if grossIncome <= bracketFour {
                tax = (grossIncome - bracketThree)*0.37 + 29467
            }   else if grossIncome <= 350000 {
                tax = (grossIncome - bracketFour)*0.45 + 51667
            } else if grossIncome > 350000 {
                // changed in build0507
                indivIncomeTextField.text = "Max amt exceeded!"
                tax = 0
                // medicare levy and surcharge values are taken care of below
                totalIncome = 0
            }
            taxResult = tax
        }
        
        // changed in build0204 and build0205A and build0205C
        func calculateMedicareLevy(grossIncome: Double){
            medicareLevyValue = 0.0
            if grossIncome >= 22801 && grossIncome <= 28501 {
                // what percentage?
            } else if grossIncome <= 90000 && grossIncome > 28501 {
                medicareLevyValue = grossIncome*0.02
                medicareLevySurchargeValue = grossIncome*0.0
                //print("holler")
            } else if grossIncome <= 105000 && grossIncome > 90000 {
                medicareLevyValue = grossIncome*0.02
                medicareLevySurchargeValue = grossIncome*0.01
                //print("holler")
            } else if grossIncome <= 140000 && grossIncome > 105000{
                medicareLevyValue = grossIncome*0.02
                medicareLevySurchargeValue = grossIncome*0.0125
                //print("holler")
            } else if grossIncome > 140000 && grossIncome < 350001 {
                // changed to 350001 in build0507
                medicareLevyValue = grossIncome*0.02
                medicareLevySurchargeValue = grossIncome*0.015
                //print("holler")
            } else {
                //print("yoot")
                // changed in build0507
                medicareLevyValue = 0
                medicareLevySurchargeValue = 0
                // changed in build0501
                var mLVFormatted = medicareLevyValue.formattedWithSeparator
                var mLSVFormatted = medicareLevySurchargeValue.formattedWithSeparator
                
                //changed in Build0205C
                medicareLevyValueLabel.text = "$\(mLVFormatted)"
                medicareLevySurchargeValueLabel.text = "$\(mLSVFormatted)"
            }
            
            // changed in build0501
            var mLVFormatted = medicareLevyValue.formattedWithSeparator
            var mLSVFormatted = medicareLevySurchargeValue.formattedWithSeparator

            medicareLevyValueLabel.text = "$\(mLVFormatted)"
            medicareLevySurchargeValueLabel.text = "$\(mLSVFormatted)"
        }
        calculateMedicareLevy(grossIncome: grossIncomeOne)
        calculateTax(grossIncome: grossIncomeOne)
    }
    
    
    
    func addDoneButtonOnKeyboard(){
        print("adddonebuttononkeyboard()")
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        rentalRevTextField.inputAccessoryView = doneToolbar
        indivIncomeTextField.inputAccessoryView = doneToolbar
    
        tableCell1.textfieldv.inputAccessoryView = doneToolbar
        tableCell2.textfieldv.inputAccessoryView = doneToolbar
        tableCell3.textfieldv.inputAccessoryView = doneToolbar
        tableCell4.textfieldv.inputAccessoryView = doneToolbar
        tableCell5.textfieldv.inputAccessoryView = doneToolbar
        tableCell6.textfieldv.inputAccessoryView = doneToolbar
        tableCell7.textfieldv.inputAccessoryView = doneToolbar
        tableCell8.textfieldv.inputAccessoryView = doneToolbar
        tableCell9.textfieldv.inputAccessoryView = doneToolbar
        tableCell10.textfieldv.inputAccessoryView = doneToolbar
        tableCell11.textfieldv.inputAccessoryView = doneToolbar
        tableCell12.textfieldv.inputAccessoryView = doneToolbar
        tableCell13.textfieldv.inputAccessoryView = doneToolbar
        tableCell14.textfieldv.inputAccessoryView = doneToolbar
        tableCell15.textfieldv.inputAccessoryView = doneToolbar
        tableCell16.textfieldv.inputAccessoryView = doneToolbar
        tableCell17.textfieldv.inputAccessoryView = doneToolbar
        tableCell18.textfieldv.inputAccessoryView = doneToolbar
        tableCell19.textfieldv.inputAccessoryView = doneToolbar
        tableCell20.textfieldv.inputAccessoryView = doneToolbar
        
        tableCell1.textfieldv.delegate = self
        tableCell2.textfieldv.delegate = self
        tableCell3.textfieldv.delegate = self
        tableCell4.textfieldv.delegate = self
        tableCell5.textfieldv.delegate = self
        tableCell6.textfieldv.delegate = self
        tableCell7.textfieldv.delegate = self
        tableCell8.textfieldv.delegate = self
        tableCell9.textfieldv.delegate = self
        tableCell10.textfieldv.delegate = self
        tableCell11.textfieldv.delegate = self
        tableCell12.textfieldv.delegate = self
        tableCell13.textfieldv.delegate = self
        tableCell14.textfieldv.delegate = self
        tableCell15.textfieldv.delegate = self
        tableCell16.textfieldv.delegate = self
        tableCell17.textfieldv.delegate = self
        tableCell18.textfieldv.delegate = self
        tableCell19.textfieldv.delegate = self
        //tableCell20.textfieldv.delegate = self
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var tableCellTxtFArray = [tableCell1.textfieldv, tableCell2.textfieldv, tableCell3.textfieldv, tableCell4.textfieldv, tableCell5.textfieldv, tableCell6.textfieldv, tableCell7.textfieldv, tableCell8.textfieldv, tableCell9.textfieldv, tableCell10.textfieldv, tableCell11.textfieldv, tableCell12.textfieldv, tableCell13.textfieldv, tableCell14.textfieldv, tableCell15.textfieldv, tableCell16.textfieldv, tableCell17.textfieldv, tableCell18.textfieldv, tableCell19.textfieldv]
        var sent = 0
        while sent < 19 {
            
            var num: Double = 0
            if let value = tableCellTxtFArray[sent].text {
                if let val = Double(value) {
                    tableCellTxtFArray[sent].text = "\(val.formattedWithSeparator)"
                    print("heyhaw \(val.formattedWithSeparator)")
                } else {
                    //tableCellTxtFArray[sent].text = "0"
                }
            } else {
                //tableCellTxtFArray[sent].text = "0"
            }
            
            
            sent = sent + 1
        }
        
    }
    
    
        func formatIndivIncGrossInc() {
            print("formatindivincgrossinc()")
            // func created in build0404
            
            // added in build0209
            //let statIndivInc = indivIncomeTextField.text
            
            var statIndivIncNum = indivIncomeTextField.text?.filter("0123456789.".contains)
            //statIndivIncNumDbl = Double(statIndivIncNum ?? "0.00")
            
            if let unwrpSIncNum = statIndivIncNum {
                print("statIndivIncNum was successfully unwrapped and is = \(unwrpSIncNum)")
                // [PLS CHECK LATER] this is expected to never be nil bc I already unwrapped the optional, guaranteeing it will never be nil?
                statIndivIncNumDbl = Double(unwrpSIncNum) ?? 0.00
            
            }
            
            indivIncomeTextField.resignFirstResponder()
            //print("iindivincometextfield text\(indivIncomeTextField.text)")
            indivIncomeTextField.text = statIndivIncNumDbl.formattedWithSeparator
            //print("HEY HI HEY  \(statIndivIncNumDbl.formattedWithSeparator)")
        }
    
    func formatIndivRentInc() {
        print("formatindivincgrossinc()")
        // func created in build0503
        // copied from formatIndivIncGrossInc()
        var statRentNum = rentalRevTextField.text?.filter("0123456789.".contains)
        //statIndivIncNumDbl = Double(statIndivIncNum ?? "0.00")
        
        if let unwrpRIncNum = statRentNum {
            print("statIndivIncNum was successfully unwrapped and is = \(unwrpRIncNum)")
            // [PLS CHECK LATER] this is expected to never be nil bc I already unwrapped the optional, guaranteeing it will never be nil?
            statRentNumDbl = Double(unwrpRIncNum) ?? 0.00
        
        }
        
        rentalRevTextField.resignFirstResponder()
        //print("iindivincometextfield text\(indivIncomeTextField.text)")
        rentalRevTextField.text = statRentNumDbl.formattedWithSeparator
        //print("HEY HI HEY  \(statIndivIncNumDbl.formattedWithSeparator)")
    }

    
    
        @objc func doneButtonAction(){
            print("objc donebuttonaction ()")
            rentalRevTextField.resignFirstResponder()
            
            if menuScreenIndex == 0 {
                // changed in build0504
                var prefixaInc = String((indivIncomeTextField.text?.filter("0123456789.".contains).prefix(8))!)
                if prefixaInc.count > 7 {
                    indivIncomeTextField.text = "Max digits exceeded!"
                    
                    medicareLevyValueLabel.text = "$0.00"
                    medicareLevySurchargeValueLabel.text = "$0.00"
                    netIncomeValueLabel.text = "$0.00"
                } else {
                    // added in build0503
                    formatIndivIncGrossInc()
                }
            } else if menuScreenIndex == 1 {
                
                // changed in build0504
                var prefixaRInc = String((rentalRevTextField.text?.filter("0123456789.".contains).prefix(8))!)
                if prefixaRInc.count > 7 {
                    rentalRevTextField.text = "Max digits exceeded!"
                } else {
                    
                    formatIndivRentInc()
                }
            }
            
            
            tableCell1.textfieldv.resignFirstResponder()
            tableCell2.textfieldv.resignFirstResponder()
            tableCell3.textfieldv.resignFirstResponder()
            tableCell4.textfieldv.resignFirstResponder()
            tableCell5.textfieldv.resignFirstResponder()
            tableCell6.textfieldv.resignFirstResponder()
            tableCell7.textfieldv.resignFirstResponder()
            tableCell8.textfieldv.resignFirstResponder()
            tableCell9.textfieldv.resignFirstResponder()
            tableCell10.textfieldv.resignFirstResponder()
            tableCell11.textfieldv.resignFirstResponder()
            tableCell12.textfieldv.resignFirstResponder()
            tableCell13.textfieldv.resignFirstResponder()
            tableCell14.textfieldv.resignFirstResponder()
            tableCell15.textfieldv.resignFirstResponder()
            tableCell16.textfieldv.resignFirstResponder()
            tableCell17.textfieldv.resignFirstResponder()
            tableCell18.textfieldv.resignFirstResponder()
            tableCell19.textfieldv.resignFirstResponder()
            tableCell20.textfieldv.resignFirstResponder()
            
            setupExpenseListTotal()
        }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        startMenuButton.translatesAutoresizingMaskIntoConstraints = false
        scroller.translatesAutoresizingMaskIntoConstraints = false
        
        startMenuButton.frame = CGRect(x: 0, y: 0, width: 160, height: 30)
        startMenuButton.setTitle("Start", for: UIControl.State.normal)
        startMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: 35, weight: UIFont.Weight(0.3))

        startMenuButton.addTarget(self, action: #selector(ViewController.actionStartButton(_:)), for: .touchUpInside)

        view.addSubview(startMenuButton)
        
        scroller.delegate = self
        scroller.dataSource = self
        
        pickerData = ["individual income return","company tax return","other"]
        numberOfComponents(in: scroller)
        pickerView(scroller, numberOfRowsInComponent: 3)
        view.addSubview(scroller)
        selectedOption = scroller.selectedRow(inComponent: 0)
        let startMenuButtonOffset = view.bounds.maxY * 0.125
        
        // SETTING UP GRAPHICS AND LOGO
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        
        logoImage = UIImage(named: "bng.png")!
        logoView.frame = CGRect(x: 0, y: 0, width: logoImage.size.width, height: logoImage.size.height)
        logoView.image = logoImage
        
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.font = UIFont.systemFont(ofSize: smallFsize, weight: UIFont.Weight(rawValue: 0.3))
        logoLabel.text = "Financial Services App"
        
        view.addSubview(logoLabel)
        view.addSubview(logoView)
        
        //GRAPHICAL INFO FOR START MENU:
        startLogoOffsetX = view.bounds.width * 0.25
        startLogoOffsetYTop = view.bounds.height * 0.33
        //bng logo file dimensions ratio is currently 92x380
        let vbhOffset = view.bounds.width * 0.5 * 0.30
        //print("\(view.bounds.height * 0.33) and \(vbhOffset)")
        startLogoOffsetYBot = startLogoOffsetYTop + vbhOffset
        //prevents dark mode from changing the interface colours across the whole app
        view.overrideUserInterfaceStyle = .light
        
        NSLayoutConstraint.activate([
            startMenuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startMenuButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -startMenuButtonOffset),
            
            scroller.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scroller.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor, constant: startMenuButtonOffset),
            
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            logoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startLogoOffsetX),
            logoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -startLogoOffsetX),
            
            logoView.topAnchor.constraint(equalTo: view.topAnchor, constant: startLogoOffsetYTop),
            logoView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: startLogoOffsetYBot),
            
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            logoLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: vbhOffset*0.5)
        ])
    }
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print("\(pickerData.count)")
        return pickerData.count
        // REVISE: WHAT IS 'VAR PICKERDATA' USED FOR?
    }
    
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Individual Income Tax"
        } else if row == 1 {
            return "Rental Income"
        } else if row == 2 {
            return "Help"
        }
        //this final return shouldn't affect anything (proven by preliminary experimentation.)
        return "bb"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("\(row)")
        if row == 0 {
            print("selected individual income tax return")
            menuScreenIndex = 0
        } else if row == 1 {
            print("selected company tax return")
            menuScreenIndex = 1
        } else if row == 2 {
            print("selected other option")
            menuScreenIndex = 2
        }
    }
    
    
    func getRentalExpensesTableCell(_ sender:UITextField, tableCellNumber:Int){
        print("getrentalexpensestablecell()")
        
        
        // changed in build0509
        var tableCellTxtFArray = [tableCell1.textfieldv, tableCell2.textfieldv, tableCell3.textfieldv, tableCell4.textfieldv, tableCell5.textfieldv, tableCell6.textfieldv, tableCell7.textfieldv, tableCell8.textfieldv, tableCell9.textfieldv, tableCell10.textfieldv, tableCell11.textfieldv, tableCell12.textfieldv, tableCell13.textfieldv, tableCell14.textfieldv, tableCell15.textfieldv, tableCell16.textfieldv, tableCell17.textfieldv, tableCell18.textfieldv, tableCell19.textfieldv]
        
        var prefixaRentalExpense = "0"
        if tableCellTxtFArray[tableCellNumber].text?.prefix(8) != nil && tableCellTxtFArray[tableCellNumber].text?.prefix(8) != "" {
            prefixaRentalExpense = String((tableCellTxtFArray[tableCellNumber].text?.prefix(8))!)
        } else {
            prefixaRentalExpense = "0"
        }
        /*
        if let rExp = tableCellTxtFArray[tableCellNumber].text?.prefix(8) {
            print("string(rExp) is 1 --\(rExp)-- \n")
            prefixaRentalExpense = String(rExp)
            print("string(rExp) is 2 --\(prefixaRentalExpense)-- \n")
        } else {
            prefixaRentalExpense = "0.00"
            print("prefixRentalExpense is \(prefixaRentalExpense)\n")
        }
        */
        //print("\(prefixaRentalExpense) PREFIXA")
        
        
        // THIS STRING TO DOUBLE CONVERSION WITH THOUSANDS COMMA TURNS THE RESULT TO 'NIL'
        // need to filter the thousands comma out after putting it in with .formattedseparator for this to work smoothly!!!
            // added in build0509
        var prefixaDoubleString = prefixaRentalExpense.filter("0123456789.".contains)
        let prefixaDouble = Double(prefixaDoubleString)
                                   
            
        print("prefixDouble is \(prefixaDouble) \n")
        //print("\(prefixaDouble) MOE")
        addingRentalExpenses = grossRentalExpenses + Double(prefixaDouble!)
        
        grossRentalExpenses = addingRentalExpenses
    }
}



extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}

