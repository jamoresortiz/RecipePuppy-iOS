//
//  ViewController.swift
//  RecipePuppy
//
//  Created by Jorge Amores Ortiz on 27/09/2019.
//  Copyright © 2019 Jorge Amores Ortiz. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import AlamofireImage

class ListRecipeVC: UIViewController {

    // IBOutlets
    @IBOutlet weak var tableRecipes: UITableView!
    @IBOutlet weak var searchViewRecipes: UISearchBar! {
        didSet {
            // SearchBar text
            let textFieldInsideUISearchBar = searchViewRecipes.value(forKey: "searchField") as? UITextField
            textFieldInsideUISearchBar?.textColor = UIColor.black
            textFieldInsideUISearchBar?.font = UIFont(name: "Noteworthy", size: 17)

            // SearchBar placeholder
            let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
            textFieldInsideUISearchBarLabel?.textColor = UIColor.black
            textFieldInsideUISearchBarLabel?.font = UIFont(name: "Noteworthy", size: 17)
        }
    }
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet weak var viewLoading: UIView! {
        didSet {
            viewLoading.isHidden = true
        }
    }
    @IBOutlet weak var viewContainerFilter: UIView! {
        didSet {
            viewContainerFilter.alpha = 0.0
            viewContainerFilter.isHidden = true
        }
    }
    
    
    // Variables
    var presenter: ListRecipePresenter = ListRecipePresenter()
    var recipes: [Recipe] = [Recipe]()
    let cellReuseIdentifier = "Cell"
    var urlDetail: String = ""
    var arrIngredients: [String] = [String]()
    var ingredients: String = ""
    var query: String = ""
    var fetchingMore: Bool = false
    var nextPage: Int = 1
    var isLastPage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(view: self)
        
        searchViewRecipes.delegate = self
        tableRecipes.delegate = self
        tableRecipes.dataSource = self
        tableRecipes.emptyDataSetSource = self
        tableRecipes.tableFooterView = UIView()
        
        presenter.getAllRecipes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter.getAllRecipes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailRecipeVC
        vc.url = self.urlDetail
    }
    
    
    @IBAction func tapAccept(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.viewContainerFilter.alpha = 0.0
        }) { (isCompleted) in
            self.viewContainerFilter.isHidden = true
        }
        
        isLastPage = false
        nextPage = 1
        ingredients = presenter.returnStringIngredients(arrIngredients: arrIngredients)
        presenter.getRecipesByData(ingredients: ingredients, query: query, page: nextPage)
        
        
    }
    
    @IBAction func tapFilter(_ sender: Any) {
        self.viewContainerFilter.alpha = 0.0
        self.viewContainerFilter.isHidden = false

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.viewContainerFilter.alpha = 1.0
        }) { (isCompleted) in
        }
    }
    
    @IBAction func tapIngredients(_ sender: UIButton) {
        let propertyToCheck = sender.currentTitle!
                
        if !sender.isSelected {
            arrIngredients.append(propertyToCheck)
        } else {
            if let index = arrIngredients.firstIndex(of: propertyToCheck) {
                arrIngredients.remove(at: index)
            }
        }
        sender.isSelected = !sender.isSelected
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {
            if !fetchingMore && !isLastPage{
                beginBatchFetch()
            }
        }
    }

    func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nextPage += 1
            self.presenter.getRecipesByData(ingredients: self.ingredients, query: self.query, page: self.nextPage)
        }
    }
}


//     MARK: Presenter Protocol functions

extension ListRecipeVC: ListRecipeView {
    
    func showFailed(message: String) {
        let alertController = UIAlertController(title: "Internet failure",
                                                message: "It seems you have not internet connection. Please, check it.",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayLoading(message: String, nextPage: Bool) {
        if !nextPage {
            tableRecipes.isHidden = true
        }
        viewLoading.isHidden = false
        indicatorView.startAnimating()
    }
    
    func dismissLoading() {
        viewLoading.isHidden = true
        indicatorView.stopAnimating()
        tableRecipes.isHidden = false
    }
    
    func showListRecipe(listRecipe: [Recipe], nextPage: Bool) {
        if nextPage {
            recipes += listRecipe
            self.fetchingMore = false
        } else {
            recipes = listRecipe
        }
        
        if listRecipe.count < 10 {
            self.isLastPage = true
        }
        self.tableRecipes.reloadData()
    }
}


//    MARK: TableView functions

extension ListRecipeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! RecipeCell
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = 8
        
        let data = self.recipes[indexPath.row]
        cell.titleRecipe.text = data.title.html2String
        
        if let urlImage = URL(string: data.thumbnail) {
            cell.imageRecipe.af_setImage(withURL: urlImage)
        } else {
            cell.imageRecipe.image = UIImage(named: "recipe_no_image")
        }
        
        cell.ingredientsRecipe.text = "Ingredients: \(data.ingredients)."
        cell.imageRecipe.clipsToBounds = true
        cell.imageRecipe.layer.cornerRadius = 8
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let additionalSeparatorThickness = CGFloat(3)
        let additionalSeparator = UIView(frame: CGRect(x: 0,
                                                       y: cell.frame.size.height - additionalSeparatorThickness,
                                                       width: cell.frame.size.width,
                                                       height: additionalSeparatorThickness))
        additionalSeparator.backgroundColor = UIColor(red: 248/255, green: 159/255, blue: 107/255, alpha: 1)
        cell.addSubview(additionalSeparator)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145.0
    }
    
}

extension ListRecipeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(style: .normal, title: "Detail") {  (contextualAction, view, boolValue) in
            guard let url = URL(string: self.recipes[indexPath.row].href) else { return }
            self.urlDetail = url.absoluteString
            self.performSegue(withIdentifier: "showDetailSegue", sender: self)
            self.tableRecipes.setEditing(false, animated: true)
        }
        contextItem.backgroundColor = .darkGray
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])

        return swipeActions
    }
    
}


//    MARK: EmptyData functions

extension ListRecipeVC: EmptyDataSetSource {
    
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let image = UIImage(named: "empty_search")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }
}


//    MARK: SearchBar functions

extension ListRecipeVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isLastPage = false
        nextPage = 1
        self.query = searchText
        presenter.getRecipesByData(ingredients: self.ingredients, query: self.query, page: nextPage)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
}


//    MARK: HTML Methods

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
