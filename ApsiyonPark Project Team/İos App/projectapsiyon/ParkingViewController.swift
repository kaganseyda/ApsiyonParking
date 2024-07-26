import UIKit

class ParkingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        return label
    }()

    private var parkingData = [Bool](repeating: false, count: 100)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(statusLabel)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ParkingCell.self, forCellWithReuseIdentifier: "ParkingCell")
        
        setupLayout()
        startUpdatingParkingData()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusLabel.heightAnchor.constraint(equalToConstant: 40),

            collectionView.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func startUpdatingParkingData() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            self.updateParkingData()
            self.collectionView.reloadData()
            self.updateParkingStatus()
        }
    }

    private func updateParkingData() {
        for i in 0..<parkingData.count {
            parkingData[i] = Bool.random()
        }
    }

    private func updateParkingStatus() {
        let occupiedCount = parkingData.filter { $0 }.count
        let percentage = (Float(occupiedCount) / Float(parkingData.count)) * 100
        statusLabel.text = String(format: "Otopark Boş Alan: %.1f%%", 100 - percentage)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parkingData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParkingCell", for: indexPath) as! ParkingCell
        cell.updateAppearance(isOccupied: parkingData[indexPath.item], at: indexPath.item)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 5
        let height = width * 0.6
        return CGSize(width: width, height: height)
    }
}

class ParkingCell: UICollectionViewCell {

    private let roadView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(roadView)
        setupLayout()
        contentView.layer.cornerRadius = 5
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            roadView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            roadView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            roadView.topAnchor.constraint(equalTo: contentView.topAnchor),
            roadView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func updateAppearance(isOccupied: Bool, at index: Int) {
        if index % 5 == 2 {
            roadView.backgroundColor = UIColor.darkGray //asfalt yolu temsilen
        } else {
            roadView.backgroundColor = isOccupied ? UIColor.red : UIColor.green // Dolu: kırmızı, boş: yeşil
        }
    }
}
