//
//  RecipeCell.swift
//  RecipePuppy
//
//  Created by Jorge Amores Ortiz on 28/09/2019.
//  Copyright © 2019 Jorge Amores Ortiz. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var imageRecipe: UIImageView!
    @IBOutlet weak var titleRecipe: UILabel!
    @IBOutlet weak var ingredientsRecipe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
