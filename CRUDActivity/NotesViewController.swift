
//
//  NotesViewController.swift
//  CRUDActivity

protocol noteDelegate: AnyObject{
    func saveAdd(_ title: String, _ description: String)
    func saveEdit(_  indexPath: NSIndexPath?,_ title: String, _ description: String)

}

import UIKit
import CoreData
import PencilKit

class NotesViewController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate , PKCanvasViewDelegate, PKToolPickerObserver{

    //All IBOutlet
    @IBOutlet weak var noteTitle: UITextField!
    @IBOutlet weak var descriptionTitle: UITextView!
    @IBOutlet weak var addPhoto: UIButton!
    @IBOutlet weak var write: UIButton!
    @IBOutlet weak var alignmentText: UIButton!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var drawingView: PKCanvasView!
    @IBOutlet weak var images: UIImageView!
    
    var index = IndexPath()
    weak var delg : noteDelegate?
    //CoreData
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var noteArray : [Note] = []
    var imageData = Data()
    var isDrawing = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //descriptionTitle.backgroundColor = UIColor(patternImage: UIImage(named: "text")!)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bb")!)
      
        
    }
    func saveNote(){
        print(";;;;;;;;")
        let title = noteTitle.text!
        let describtion = descriptionTitle.text!
        
        if save.tag == 1{
            print(";;;;;;;;add")
            delg?.saveAdd(title, describtion)
            print("uuii")
        }
        else if save.tag == 0{
            print(";;;;;;;;edit")
            delg?.saveEdit(index as NSIndexPath, title, describtion)
        }
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        drawingView. = view.bounds
//    }
    
    @IBAction func addPhotoAction(_ sender: Any) {
        let addImage = UITapGestureRecognizer(target: self, action: #selector(addImage))
        addPhoto.addGestureRecognizer(addImage)
        addPhoto.isUserInteractionEnabled = true
    }
    
    @objc func addImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let imagePiker = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
                images.image = imagePiker
                images.contentMode = .scaleToFill
                imageData = imagePiker.pngData()!
            }
            dismiss(animated: true, completion: nil)
        }
    
    
    @IBAction func writeAction(_ sender: Any) {
//        if descriptionTitle.isHidden{
//            descriptionTitle.isHidden = false
//            drawingView.isHidden = true
//        }else{
//            descriptionTitle.isHidden = true
//            drawingView.isHidden = false
//            drawingView.delegate = self
////            drawingView.drawing = PKDrawing()
//            drawingView.drawingPolicy = PKCanvasViewDrawingPolicy.anyInput
//            drawingView.becomeFirstResponder()
//            showDrawing(isDrawing)
//        }
//        isDrawing = !isDrawing
    }
    
//    func showDrawing(_ isShowDrawing : Bool){
//        let toolPicker = PKToolPicker()
//         toolPicker.setVisible(isShowDrawing, forFirstResponder: drawingView)
//         toolPicker.addObserver(drawingView)
////         drawingView.becomeFirstResponder()
//    }
    
    @IBAction func alignmentTextAction(_ sender: Any) {
        if descriptionTitle.textAlignment == .center{
            descriptionTitle.textAlignment = .right
            alignmentText.setImage(UIImage(systemName: "text.justifyright"), for: .normal)
        }else if descriptionTitle.textAlignment == .left{
            descriptionTitle.textAlignment = .center
            alignmentText.setImage(UIImage(systemName: "text.justify"), for: .normal)
        }else{
            descriptionTitle.textAlignment = .left
            alignmentText.setImage(UIImage(systemName: "text.justifyleft"), for: .normal)
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        print("Qqqqq!!!!!")
        saveNote()
        navigationController?.popToRootViewController(animated: true)
               // if noteTitle.text != ""{
//            let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: self.managedObjectContext) as! Note
//
//            note.noteTitle = noteTitle.text
//            note.noteText = descriptionTitle.text
//
//            do{
//                try self.managedObjectContext.save()
//            }catch {
//                print("\(error)")
//            }
//            self.noteArray.append(note)
//        }else{
        
//        }
    }
    
}
