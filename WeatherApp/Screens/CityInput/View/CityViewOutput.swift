import Foundation

protocol CityViewOutput {
    func viewDidLoad()
    
    func confirmButtonPressed(with prompt: String)
    
    func cityTextFieldEdited(with prompt: String)
}
