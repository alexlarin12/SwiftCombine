//
//  ViewController.swift
//  lesson4
//
//  Created by Alex Larin on 25.11.2020.
//

import UIKit
import Combine
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var episodeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel2: UILabel!
    
    
    var subscriptions: Set<AnyCancellable> = []
    private var viewModel1: ViewModel?
    private var viewModel2: ViewModel?
    private var viewModel3: ViewModel?
    var char:[Character] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alertAboutNumber = UIAlertController(title: "Номер не существует", message: "Попробуй другой", preferredStyle: .alert)
        let alertAboutNetwork = UIAlertController(title: "Ошибка сетевого адреса", message: "Попробуй снова", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            self.inputTextField.text = ""
            self.locationTextField.text = ""
            self.episodeTextField.text = ""
        }
        
        
        let inputNumberCharacter = inputTextField.publisher(for: \.text)
            .compactMap { $0.flatMap(Int.init) }
            .eraseToAnyPublisher()
        let inputNumberLocation = locationTextField.publisher(for: \.text)
            .compactMap { $0.flatMap(Int.init) }
            .eraseToAnyPublisher()
        let inputNumberEpisode = episodeTextField.publisher(for: \.text)
            .compactMap { $0.flatMap(Int.init) }
            .eraseToAnyPublisher()
        
        viewModel1 = ViewModel(
            apiClient: APIClient(),
            inputIdentifiersPublisher: inputNumberCharacter)
        
        viewModel1?.character
            .map { $0 }
            // .catch { _ in Empty<Character, Never>() }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Done")
                case .failure(.unreachableAddress(url:)):
                    alertAboutNetwork.addAction(action)
                    self.present(alertAboutNetwork, animated: true)
                case .failure(.invalidResponse):
                    alertAboutNumber.addAction(action)
                    self.present(alertAboutNumber, animated: true)
                    
                }
            },
            receiveValue: { [weak self] results in
                self?.textLabel.text = results.name
                self?.textLabel2.text = results.gender
                self?.imageView.kf.setImage(with: URL(string: results.image))
                self?.locationTextField.text = ""
                self?.episodeTextField.text = ""
                
            })
            .store(in: &subscriptions)
        
        viewModel2 = ViewModel(
            apiClient: APIClient(),
            inputIdentifiersPublisher: inputNumberLocation)
        
        viewModel2?.location
            .map { $0 }
            //  .catch { _ in Empty<Location, Never>() }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    print("Done")
                case .failure(.unreachableAddress(url:)):
                    alertAboutNetwork.addAction(action)
                    self.present(alertAboutNetwork, animated: true)
                case .failure(.invalidResponse):
                    alertAboutNumber.addAction(action)
                    self.present(alertAboutNumber, animated: true)
                    
                }
                
            },
            receiveValue: { [weak self] results in
                self?.textLabel.text = results.name
                self?.textLabel2.text = results.type
                self?.imageView.kf.setImage(with: URL(string: ""))
                self?.inputTextField.text = ""
                self?.episodeTextField.text = ""
            })
            .store(in: &subscriptions)
        viewModel3 = ViewModel(
            apiClient: APIClient(),
            inputIdentifiersPublisher: inputNumberEpisode)
        
        viewModel3?.episode
            .map { $0.description }
            //  .catch { _ in Empty<String, Never>() }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {completion in
                switch completion {
                case .finished:
                    print("Done")
                case .failure(.unreachableAddress(url:)):
                    alertAboutNetwork.addAction(action)
                    self.present(alertAboutNetwork, animated: true)
                case .failure(.invalidResponse):
                    alertAboutNumber.addAction(action)
                    self.present(alertAboutNumber, animated: true)
                    
                }
                
            },
            receiveValue: { [weak self] text in
                self?.textLabel.text = "Episode: \(text)"
                self?.inputTextField.text = ""
                self?.locationTextField.text = ""
            })
            .store(in: &subscriptions)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resign))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func resign() {
        view.endEditing(true)
        resignFirstResponder()
    }
}
