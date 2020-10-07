//
//  ResultViewController.swift
//  Flickr
//
//  Created by lawliet on 2020/10/2.
//

import UIKit
import ESPullToRefresh

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var searchModel: SearchModel
    var resultJSONModel: ResultJSONModel?
    let viewModel = ResultViewModel()
    
    init?(coder: NSCoder, searchModel: SearchModel) {
       self.searchModel = searchModel
       super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
       fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        setCollectionViewUI()
        setLoadMore()
        setRefresh()
        
        let nib = UINib(nibName: "ResultCollectionViewCell", bundle: nil)
        resultCollectionView.register(nib, forCellWithReuseIdentifier: "ResultCollectionViewCell")
        
        ServerApi.searchImage(searchModel: searchModel) { [weak self] (resultJSONModel) in
            self?.resultJSONModel = resultJSONModel
            self?.resultCollectionView.reloadData()
        } failure: { (error) in
            print(error.localizedDescription)
        }
    }
}

// MARK: - ESPullToRefresh
extension ResultViewController {
    private func setLoadMore() {
        resultCollectionView.es.addInfiniteScrolling {
            [unowned self] in
            let searchModel = viewModel.getLoadMoreSearchModel(searchModel: self.searchModel)
            self.searchModel = searchModel
            
            ServerApi.searchImage(searchModel: searchModel) { (newResultJSONModel) in
                self.resultCollectionView.es.stopLoadingMore()
                guard let resultJSONModel = self.resultJSONModel else { return }
                let photo = newResultJSONModel.photos.photo
                self.resultJSONModel?.photos.photo = resultJSONModel.photos.photo + photo
                self.resultCollectionView.reloadData()
            } failure: { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    private func setRefresh() {
        resultCollectionView.es.addPullToRefresh {
            [unowned self] in
            self.searchModel.page = nil
            ServerApi.searchImage(searchModel: self.searchModel) { (resultJSONModel) in
                self.resultJSONModel = resultJSONModel
                self.resultCollectionView.reloadData()
                self.resultCollectionView.es.stopPullToRefresh()
            } failure: { (error) in
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - CollectionViewUI
extension ResultViewController {
    private func setCollectionViewUI() {
        let layout = createLayout()
        resultCollectionView.collectionViewLayout = layout
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .absolute(196))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(196))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,subitems: [item, item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
}

// MARK: - CollectionView
extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultJSONModel?.photos.photo.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCollectionViewCell", for: indexPath) as! ResultCollectionViewCell
        guard let resultJSONModel = resultJSONModel else { return cell }
        cell.updateWithModel(resultJSONModel: resultJSONModel, index: indexPath.item)
        return cell
    }
}
