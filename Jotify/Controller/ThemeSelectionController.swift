//
//  ThemeSelectionController.swift
//  Jotify
//
//  Created by Harrison Leath on 6/19/19.
//  Copyright © 2019 Harrison Leath. All rights reserved.
//

import UIKit
import QuickTableViewController

class ThemeSelectionController: QuickTableViewController {
    
    var selectedSunrise = false
    var selectedAmin = false
    var selectedBlueLagoon = false
    var selectedCelestial = false
    var selectedDIMIGO = false
    var selectedGentleCare = false
    var selectedKyoopal = false
    var selectedMaldives = false
    var selectedNeonLife = false
    var selectedSolidStone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        getCurrentGradient()
        
        let themeSelection = RadioSection(title: "Themes", options: [
            OptionRow(text: "Amin", isSelected: selectedAmin, action: didToggleSelection()),
            OptionRow(text: "Blue Lagoon", isSelected: selectedBlueLagoon, action: didToggleSelection()),
            OptionRow(text: "Celestial", isSelected: selectedCelestial, action: didToggleSelection()),
            OptionRow(text: "DIMIGO", isSelected: selectedDIMIGO, action: didToggleSelection()),
            OptionRow(text: "Gentle Care", isSelected: selectedGentleCare, action: didToggleSelection()),
            OptionRow(text: "Kyoopal", isSelected: selectedKyoopal, action: didToggleSelection()),
            OptionRow(text: "Maldives", isSelected: selectedMaldives, action: didToggleSelection()),
            OptionRow(text: "Neon", isSelected: selectedNeonLife, action: didToggleSelection()),
            OptionRow(text: "Solid Stone", isSelected: selectedSolidStone, action: didToggleSelection()),
            OptionRow(text: "Sunrise", isSelected: selectedSunrise, action: didToggleSelection())], footer: "")
        themeSelection.alwaysSelectsOneOption = true
        
        tableContents = [themeSelection]
    }
    
    func setupView() {
        navigationItem.title = "Themes"
        navigationController?.navigationBar.prefersLargeTitles = false
        tableView.isUserInteractionEnabled = true
    }
    
    func getCurrentGradient() {
        let theme = UserDefaults.standard.string(forKey: "gradientTheme")
        
        if theme == "Sunrise" {
            selectedSunrise = true
            
        } else if theme == "Amin" {
            selectedAmin = true

        } else if theme == "BlueLagoon" {
            selectedBlueLagoon = true

        } else if theme == "Celestial" {
            selectedCelestial = true

        } else if theme == "DIMIGO" {
            selectedDIMIGO = true

        } else if theme == "GentleCare" {
            selectedGentleCare = true

        } else if theme == "Kyoopal" {
            selectedKyoopal = true

        } else if theme == "Maldives" {
            selectedMaldives = true

        } else if theme == "NeonLife" {
            selectedNeonLife = true

        } else if theme == "SolidStone" {
            selectedSolidStone = true

        }
    }
 
    private func didToggleSelection() -> (Row) -> Void {
        return { [weak self] in
            if let option = $0 as? OptionRowCompatible {
                
                if option.isSelected == true {
                    if option.text == "Sunrise" {
                        UserDefaults.standard.set("Sunrise", forKey: "gradientTheme")

                    } else if option.text == "Amin" {
                        UserDefaults.standard.set("Amin", forKey: "gradientTheme")

                    } else if option.text == "BlueLagoon" {
                        UserDefaults.standard.set("BlueLagoon", forKey: "gradientTheme")

                    } else if option.text == "Celestial" {
                        UserDefaults.standard.set("Celestial", forKey: "gradientTheme")

                    } else if option.text == "DIMIGO" {
                        UserDefaults.standard.set("DIMIGO", forKey: "gradientTheme")

                    } else if option.text == "GentleCare" {
                        UserDefaults.standard.set("GentleCare", forKey: "gradientTheme")

                    } else if option.text == "Kyoopal" {
                        UserDefaults.standard.set("Kyoopal", forKey: "gradientTheme")

                    } else if option.text == "Maldives" {
                        UserDefaults.standard.set("Maldives", forKey: "gradientTheme")

                    } else if option.text == "NeonLife" {
                        UserDefaults.standard.set("NeonLife", forKey: "gradientTheme")

                    } else if option.text == "SolidStone" {
                        UserDefaults.standard.set("SolidStone", forKey: "gradientTheme")

                    }
                    print(self?.selectedAmin ?? false)
                }
            }
        }
    }
}

