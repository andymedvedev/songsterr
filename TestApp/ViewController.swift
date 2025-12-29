//
//  ViewController.swift
//  TestApp
//
//  Created by Andrey Medvedev on 27.12.2025.
//

import SnapKit
import UIKit

private enum Constants {
    static let notesInTab: CGFloat = 15
    static let rowHeight: CGFloat = 100
}

final class CellConfiguration {
    let selectionRange: ClosedRange<Int>?
    let isInMiddle: Bool = false

    // MARK: - Init

    init(selectionRange: ClosedRange<Int>?, isInMiddle: Bool = false) {
        self.selectionRange = selectionRange
    }
}

final class TabCell: UITableViewCell {

    let label = UILabel()
    let selectionOverlay = UIView()
    let leftSelectionView = UIView()
    let rightSelectionView = UIView()
    var leadingConstraint: Constraint?
    var trailingConstraing: Constraint?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    func setupUI() {
        contentView.addSubview(label)
        contentView.addSubview(selectionOverlay)
        contentView.addSubview(leftSelectionView)
        contentView.addSubview(rightSelectionView)
        leftSelectionView.backgroundColor = .systemGreen
        rightSelectionView.backgroundColor = .systemGreen
        label.textColor = .systemBlue
        selectionOverlay.backgroundColor = .systemGray.withAlphaComponent(0.3)
    }

    func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(Constants.rowHeight)
        }
        selectionOverlay.snp.makeConstraints {
            leadingConstraint = $0.leading.equalToSuperview().constraint
            trailingConstraing = $0.trailing.equalToSuperview().constraint
            $0.height.equalToSuperview()
        }
        leftSelectionView.snp.makeConstraints {
            $0.leading.equalTo(selectionOverlay.snp.leading)
            $0.height.equalToSuperview()
            $0.width.equalTo(16)
        }
        rightSelectionView.snp.makeConstraints {
            $0.trailing.equalTo(selectionOverlay.snp.trailing)
            $0.height.equalToSuperview()
            $0.width.equalTo(16)
        }
        leadingConstraint?.isActive = false
        trailingConstraing?.isActive = false
    }

    func configure(with configuration: CellConfiguration) {
        if let range = configuration.selectionRange {
            selectionOverlay.isHidden = false
            leftSelectionView.isHidden = false
            rightSelectionView.isHidden = false
            leadingConstraint?.isActive = true
            trailingConstraing?.isActive = true

            if configuration.isInMiddle {
                leadingConstraint?.update(inset: CGFloat.zero)
                trailingConstraing?.update(inset: CGFloat.zero)
            } else {
                leadingConstraint?.update(inset: (contentView.bounds.width / Constants.notesInTab) * CGFloat(range.lowerBound))
                trailingConstraing?.update(offset: -(contentView.bounds.width / Constants.notesInTab) * (Constants.notesInTab - CGFloat(range.upperBound)))
            }
        } else {
            selectionOverlay.isHidden = true
            leftSelectionView.isHidden = true
            rightSelectionView.isHidden = true
        }
    }
}

final class ViewController: UIViewController {

    private var configurations = [CellConfiguration]()
    private var activeLeftLocation = 0
    private var activeRightLocation = 15
    private var activeLeftRow = 0
    private var activeRightRow = 0

    let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        for i in 0..<20 {
            let configuration = {
                if i == 0 {
                    CellConfiguration(selectionRange: 0...15, isInMiddle: false)
                } else {
                    CellConfiguration(selectionRange: nil)
                }
            }()
            configurations.append(configuration)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.register(TabCell.self, forCellReuseIdentifier: "TabCell")
        tableView.dataSource = self
        tableView.delegate = self

        tableView.gestureRecognizers?.forEach { gesture in
            tableView.removeGestureRecognizer(gesture)
        }

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func pan(_ gesture: UIGestureRecognizer) {
        let point = gesture.location(in: tableView)

        let row = Int(point.y / Constants.rowHeight)

        if activeLeftRow == row {
            let lowerBound = point.x / Constants.notesInTab
            let configuration = configurations[row]
            configuration.selectionRange =
        }

        let lowerBound = point.x / Constants.notesInTab
        let upperBound = point.x
        let configuration = CellConfiguration(
            selectionRange: <#T##ClosedRange<Int>?#>, isInMiddle: <#T##Bool#>
        )
        print(point)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TabCell", for: indexPath) as? TabCell else { return UITableViewCell() }
        let configuration = configurations[indexPath.row]
        cell.label.text = "\(indexPath.row)"
        cell.configure(with: configuration)
        return cell
    }
}

extension ViewController: UITableViewDelegate {

}
