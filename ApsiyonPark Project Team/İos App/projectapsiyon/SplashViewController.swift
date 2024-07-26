import UIKit

class SplashViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apsiyon"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .systemBlue
        return label
    }()
    
    private let parkingButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Otopark Ne Durumda?", for: .normal)
        button.backgroundColor = UIColor.blue // Lacivert arka plan
        button.setTitleColor(.white, for: .normal) // Beyaz yazı
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(showParkingStatus), for: .touchUpInside)
        return button
    }()

    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("☰", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
        return button
    }()

    private let menuView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0)
        view.isHidden = true
        return view
    }()

    private let menuOptions: [String] = ["Aidatlarım", "Spor Salonu", "Etkinlikler", "Çıkış"]
    private var menuButtons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(parkingButton)
        view.addSubview(menuButton)
        view.addSubview(menuView)

        setupLayout()
        setupMenu()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
     
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),

    
            parkingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parkingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            parkingButton.widthAnchor.constraint(equalToConstant: 250),
            parkingButton.heightAnchor.constraint(equalToConstant: 50),

      
            menuView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuView.widthAnchor.constraint(equalToConstant: 200),
            menuView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupMenu() {
        var lastButton: UIButton?
        for option in menuOptions {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(option, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(menuOptionSelected(_:)), for: .touchUpInside)
            menuView.addSubview(button)
            menuButtons.append(button)

            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: 50)
            ])

            if let lastButton = lastButton {
                button.topAnchor.constraint(equalTo: lastButton.bottomAnchor).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: menuView.topAnchor).isActive = true
            }

            lastButton = button
        }
    }

    @objc private func showParkingStatus() {
        let parkingVC = ParkingViewController()
        navigationController?.pushViewController(parkingVC, animated: true)
    }

    @objc private func showMenu() {
        if menuView.isHidden {
            menuView.isHidden = false
            menuView.frame.size.width = 0
            UIView.animate(withDuration: 0.3) {
                self.menuView.frame.size.width = 200
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.menuView.frame.size.width = 0
            }) { _ in
                self.menuView.isHidden = true
            }
        }
    }

    @objc private func menuOptionSelected(_ sender: UIButton) {
        print("\(sender.title(for: .normal) ?? "") seçildi")
    }
}
