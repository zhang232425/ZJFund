//
//  WikipediaSearchVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/23.
//

import UIKit
import RxSwift
import RxCocoa

class WikipediaSearchVC: BaseVC {
    
    private lazy var searchBar = UISearchBar()
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.registerCell(WikipediaSearchCell.self)
    }
    
    private lazy var emptyView = WikipediaEmptyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindListDataSource()
    }
    
}

private extension WikipediaSearchVC {
    
    func setupViews() {
        
        searchBar.add(to: view).snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
        }
        
        tableView.add(to: view).snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        
        emptyView.add(to: view).snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview().offset(-70)
        }
        
    }
    
    func bindListDataSource() {
        
        let API = DefaultWikipediaAPI.sharedAPI
        
        /**
         let results = searchBar.rx.text.orEmpty
             .asDriver()
             .throttle(.milliseconds(300))
             .distinctUntilChanged()
             .flatMapLatest { query in
                 API.getSearchResults(query)
                     .retry(3)
                     .retryOnBecomesReachable([], reachabilityService: Dependencies.sharedDependencies.reachabilityService)
                     .startWith([]) // clears results on new search term
                     .asDriver(onErrorJustReturn: [])
             }
             .map { results in
                 results.map(SearchResultViewModel.init)
             }
         */
        
        searchBar.rx.text.orEmpty.subscribe(onNext: {
            API.getSearchResults($0)
        }).disposed(by: disposeBag)
        
        
        let results = searchBar.rx.text.orEmpty
            .asDriver()
            .throttle(.milliseconds(400))
            .distinctUntilChanged()
            .flatMapLatest { query in
                API.getSearchResults(query)
                    .retry(3)
                    .startWith([])
                    .asDriver(onErrorJustReturn: [])
            }
            .map { results in
                print(results)
            }
        
    }
    
}
