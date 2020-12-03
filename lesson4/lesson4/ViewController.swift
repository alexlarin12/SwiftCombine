//
//  ViewController.swift
//  lesson4
//
//  Created by Alex Larin on 25.11.2020.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var episodeTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    var subscriptions: Set<AnyCancellable> = []
    private var viewModel1: ViewModel?
    private var viewModel2: ViewModel?
    private var viewModel3: ViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputNumberCharacter = inputTextField.publisher(for: \.text).compactMap { $0.flatMap(Int.init) }.eraseToAnyPublisher()
        let inputNumberLocation = locationTextField.publisher(for: \.text).compactMap { $0.flatMap(Int.init) }.eraseToAnyPublisher()
        let inputNumberEpisode = episodeTextField.publisher(for: \.text).compactMap { $0.flatMap(Int.init) }.eraseToAnyPublisher()
        
        viewModel1 = ViewModel(
            apiClient: APIClient(),
            inputIdentifiersPublisher: inputNumberCharacter)
        
        viewModel1?.character
            .map { $0.description }
            .catch { _ in Empty<String, Never>() }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { [weak self] text in
                    self?.textLabel.text = "Character: \(text)"
                    self?.locationTextField.text = ""
                    self?.episodeTextField.text = ""
                  })
            .store(in: &subscriptions)
        
        viewModel2 = ViewModel(
            apiClient: APIClient(),
            inputIdentifiersPublisher: inputNumberLocation)
        
        viewModel2?.location
            .map { $0.description }
            .catch { _ in Empty<String, Never>() }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { [weak self] text in
                    self?.textLabel.text = "Location: \(text)"
                    self?.inputTextField.text = ""
                    self?.episodeTextField.text = ""
                  })
            .store(in: &subscriptions)
        viewModel3 = ViewModel(
            apiClient: APIClient(),
            inputIdentifiersPublisher: inputNumberEpisode)
        
        viewModel3?.episode
            .map { $0.description }
            .catch { _ in Empty<String, Never>() }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { print($0) },
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
