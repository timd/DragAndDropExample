//
//  ViewController.swift
//  DragAndDrop
//
//  Created by Tim Ducket on 10.06.17.
//  Copyright © 2017 Tim Ducket. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var firstDraggableView: UIImageView!
    @IBOutlet var secondDraggableView: UIImageView!
    @IBOutlet var droppableView: UIView!
    @IBOutlet var imageDropView: UIImageView!
    @IBOutlet var mainView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the drag interactions and attach them to the views
        let firstDragInteraction = UIDragInteraction(delegate: self)
        firstDraggableView.addInteraction(firstDragInteraction)
        
        let secondDragInteraction = UIDragInteraction(delegate: self)
        secondDraggableView.addInteraction(secondDragInteraction)
        
        // Create the drop interaction and attach to the drop target
        let dropInteraction = UIDropInteraction(delegate: self)
        droppableView.addInteraction(dropInteraction)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        
        var imageItemProvider: NSItemProvider
        
        // Figure out which view is being dragged, and load the appropriate image into the item provider
        if interaction.view == firstDraggableView {
            imageItemProvider = NSItemProvider(object: UIImage(named: "panda_200x200")!)
        } else {
            imageItemProvider = NSItemProvider(object: UIImage(named: "kath_square")!)
        }
        
        // Create and return a drag item containing the item provider
        let dragItem = UIDragItem(itemProvider: imageItemProvider)
        return [dragItem]
        
    }
    
    // Dim the dragged view when the session starts
    func dragInteraction(_ interaction: UIDragInteraction, sessionWillBegin session: UIDragSession) {
        interaction.view?.alpha = 0.1
    }
    
    // Fade the dragged image back in once the drag session has finished
    func dragInteraction(_ interaction: UIDragInteraction, session: UIDragSession, didEndWith operation: UIDropOperation) {
        UIView.animate(withDuration: 1.0) {
            interaction.view?.alpha = 1.0
        }
    }
    
}

extension ViewController: UIDropInteractionDelegate {
    
    // Declare that the target view can handle UIImages
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    // Items will be pasted
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    // Get the UIImage out of the session, and set it as the image in the target view
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let droppedImages = imageItems as! [UIImage]
            self.imageDropView.image = droppedImages.first
        }
    }
    
}
