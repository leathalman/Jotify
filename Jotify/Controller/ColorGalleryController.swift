//
//  ColorGalleryViewController.swift
//  Jotify
//
//  Created by Harrison Leath on 7/8/21.
//

import UIKit

class ColorGalleryController: UITableViewController {
    
    var delegate: ColorGalleryDelegate?
    
    var lastIndexPath: NSIndexPath = NSIndexPath(row: 0, section: 0)
    
    var sections: [String] = ["Caelestibus", "Caeruleum", "Eros", "Kyoopal", "Minoas", "Olympia", "Sunrise", "Sunset"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.bgColor
        tableView.separatorStyle = .none
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "ColorGalleryCell")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ColorGalleryCell", for: indexPath) as! SettingsCell
        cell.textLabel?.textColor = .clear
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            let colors = GradientThemes.caelestibus.colors()
            cell.backgroundColor = colors[indexPath.row]
            cell.textLabel?.text = colors[indexPath.row].getString()
        case 1:
            let colors = GradientThemes.caeruleum.colors()
            cell.backgroundColor = colors[indexPath.row]
            cell.textLabel?.text = colors[indexPath.row].getString()
        case 2:
            let colors = GradientThemes.eros.colors()
            cell.backgroundColor = colors[indexPath.row]
            cell.textLabel?.text = colors[indexPath.row].getString()
        case 3:
            let colors = GradientThemes.kyoopal.colors()
            cell.backgroundColor = colors[indexPath.row]
            cell.textLabel?.text = colors[indexPath.row].getString()
        case 4:
            let colors = GradientThemes.minoas.colors()
            cell.backgroundColor = colors[indexPath.row]
            cell.textLabel?.text = colors[indexPath.row].getString()
        case 5:
            let colors = GradientThemes.olympia.colors()
            cell.backgroundColor = colors[indexPath.row]
            cell.textLabel?.text = colors[indexPath.row].getString()
        case 6:
            let colors = GradientThemes.sunrise.colors()
            cell.backgroundColor = colors[indexPath.row]
            cell.textLabel?.text = colors[indexPath.row].getString()
        case 7:
            let colors = GradientThemes.sunset.colors()
            cell.backgroundColor = colors[indexPath.row]
            cell.textLabel?.text = colors[indexPath.row].getString()
        default:
            cell.backgroundColor = .systemBlue
            cell.textLabel?.text = "systemBlue"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            let selectedCell = tableView.cellForRow(at: indexPath) as! SettingsCell
            delegate.updateColorOverride(color: selectedCell.textLabel?.text ?? "error selecting cell")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return GradientThemes.caelestibus.colors().count
        case 1:
            return GradientThemes.caeruleum.colors().count
        case 2:
            return GradientThemes.eros.colors().count
        case 3:
            return GradientThemes.kyoopal.colors().count
        case 4:
            return GradientThemes.minoas.colors().count
        case 5:
            return GradientThemes.olympia.colors().count
        case 6:
            return GradientThemes.sunrise.colors().count
        case 7:
            return GradientThemes.sunset.colors().count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
