//
//  ViewController.swift
//  SportsCollection
//
//  Created by Laurentiu Rogean.
//

import UIKit

class ViewController: UIViewController {
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    enum Section: String, CaseIterable {
        case soccer = "Soccer"
        case basketball = "Basketball"
        case tennis = "Tennis"
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, SportItem>! = nil
    var sectionHeader: NSCollectionLayoutBoundarySupplementaryItem?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    func configureCollectionView() {
        // Set the flow layout of the collectionView
        collectionView.collectionViewLayout = generateLayout()
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "RectangularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: RectangularCollectionViewCell.reuseIdentifer)
        collectionView.register(UINib(nibName: "CircularCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CircularCollectionViewCell.reuseIdentifer)
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: ViewController.sectionHeaderElementKind,
            withReuseIdentifier: HeaderView.reuseIdentifier)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <Section, SportItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, sportItem: SportItem) -> UICollectionViewCell? in
            
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType {
            case .soccer:
                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RectangularCollectionViewCell.reuseIdentifer,
                        for: indexPath) as? RectangularCollectionViewCell else { fatalError("Could not create new cell") }
                
                cell.configure(with: sportItem)
                return cell
                
            case .basketball:
                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CircularCollectionViewCell.reuseIdentifer,
                        for: indexPath) as? CircularCollectionViewCell else { fatalError("Could not create new cell") }
                
                cell.configure(with: sportItem)
                return cell
                
            case .tennis:
                guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: RectangularCollectionViewCell.reuseIdentifer,
                        for: indexPath) as? RectangularCollectionViewCell else { fatalError("Could not create new cell") }
                
                cell.configure(with: sportItem)
                return cell
                
            }
        }
        
        dataSource.supplementaryViewProvider = { (
          collectionView: UICollectionView,
          kind: String,
          indexPath: IndexPath) -> UICollectionReusableView? in

          guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }

          supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
          return supplementaryView
        }
        
        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func generateLayout() -> UICollectionViewLayout {
      let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                          layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
        let sectionLayoutKind = Section.allCases[sectionIndex]
        switch (sectionLayoutKind) {
        case .soccer: return self.generateRectangularLayout()
        case .basketball: return self.generateCircularLayout()
        case .tennis: return self.generateRectangularLayoutStatic()
        }
      }
        
        return layout
    }
    
    func generateRectangularLayout() -> NSCollectionLayoutSection {
        // 1
        // The size of a single item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalWidth(2/3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 2
        // The size of a group of items
        // Here we want an item to be big and see just a peek of the next one
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.80),
            heightDimension: .absolute(200))
        
        // 3
        // Creating the group, which will contain a single item
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        // 4
        // Add content insets if needed
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

        // 5
        // Configure header for the section
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(70))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: ViewController.sectionHeaderElementKind, alignment: .top)

        // 6
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    func generateCircularLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupHeight = NSCollectionLayoutDimension.absolute(160)
        let groupSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(90))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: ViewController.sectionHeaderElementKind, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    func generateRectangularLayoutStatic() -> NSCollectionLayoutSection  {
        // The bigger item
        let mainItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(2/3),
            heightDimension: .fractionalHeight(1.0)))

        // The smaller item
        let pairItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)))

        // A group consisting of 2 smaller items
        let trailingGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)),
          subitem: pairItem,
          count: 2)

        // A group conisisting of a big item and a group with 2 small ones
        let group = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(4/9)),
          subitems: [mainItem, trailingGroup])
        
        // A small item for a triplet group
        let tripletItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)))

        // The triplet group
        let tripletGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/9)),
          subitems: [tripletItem, tripletItem, tripletItem])
        
        // The nested group
        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(16/9)),
          subitems: [
            group,
            tripletGroup
          ]
        )
        
        // The header with the title of the section
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(70))
        sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: ViewController.sectionHeaderElementKind, alignment: .top)

        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.boundarySupplementaryItems = [sectionHeader!]
        section.orthogonalScrollingBehavior = .none
        
        return section
    }
    
    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, SportItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SportItem>()
        
        snapshot.appendSections([Section.soccer])
        snapshot.appendItems(generateItems(for: .soccer))
        
        snapshot.appendSections([Section.basketball])
        snapshot.appendItems(generateItems(for: .basketball))
        
        snapshot.appendSections([Section.tennis])
        snapshot.appendItems(generateItems(for: .tennis))
        
        return snapshot
    }
    
    func generateItems(for section: Section) -> [SportItem] {
        var items = [SportItem]()
        
        switch section {
        case .soccer:
            for i in 1...5 {
                let item = SportItem(name: "Soccer \(i)", image: "soccer\(i)", type: "Soccer")
                items.append(item)
            }
        case .basketball:
            for i in 1...8 {
                let item = SportItem(name: "Basketball \(i)", image: "basketball\(i)", type: "Basketball")
                items.append(item)
            }
        case .tennis:
            for i in 1...6 {
                let item = SportItem(name: "Tennis \(i)", image: "tennis\(i)", type: "Tennis")
                items.append(item)
            }
        }
        
        return items
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > collectionView.contentSize.height - scrollView.frame.height {
            
        }
    }
}

