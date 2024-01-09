//
//  SwipeVC.swift
//  ZJFund
//
//  Created by Jercan on 2024/1/8.
//

import UIKit

class SwipeVC: BaseVC {
    
    private lazy var tableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.registerCell(SwipeCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
}

private extension SwipeVC {
    
    func setupViews() {
        
        tableView.add(to: view).snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
}

extension SwipeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SwipeCell = tableView.dequeueReuseableCell(forIndexPath: indexPath)
        cell.update(text: "这是条目：\(indexPath.row)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        // 创建“更多”事件按钮
        let more = UITableViewRowAction(style: .normal, title: "更多") { action, index in
            print("你点击了更多按钮")
        }
        more.backgroundColor = UIColor.lightGray
        
        // 创建“旗标”事件按钮
        let favorite = UITableViewRowAction(style: .normal, title: "旗标") { action, index in
            print("你点击了旗标按钮")
        }
        favorite.backgroundColor = UIColor.orange
        
        // 创建“删除”事件按钮
        let delete = UITableViewRowAction(style: .normal, title: "删除") { action, index in
            print("你点击了删除按钮")
        }
        delete.backgroundColor = .red
        
        // 返回所有的事件按钮
        return [delete, favorite, more]
        
    }
    
}

fileprivate class SwipeCell: UITableViewCell {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.bold15
    }
    
    private lazy var lineView = UIView().then {
        $0.backgroundColor = UIColor.lightGray
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        self.selectionStyle = .none
        
        titleLabel.add(to: contentView).snp.makeConstraints {
            $0.left.equalToSuperview().inset(15.auto)
            $0.centerY.equalToSuperview()
        }
        
        lineView.add(to: contentView).snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(0.5.auto)
        }
        
    }
    
    func update(text title: String) {
        titleLabel.text = title
    }
    
}
