
//
//  NotesViewController.swift
//  CRUDActivity

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
    
    //CoreData
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //variables
    var noteArray : [Note] = []
    var imageData = Data()
    var isDrawing = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bb")!)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

            view.addGestureRecognizer(tap)
        fetchAllItem()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

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
        if descriptionTitle.isHidden{
            descriptionTitle.isHidden = false
            drawingView.isHidden = true
        }else{
            descriptionTitle.isHidden = true
            drawingView.isHidden = false
            drawingView.delegate = self
            drawingView.drawing = PKDrawing()
            drawingView.drawingPolicy = .anyInput
            showDrawing(isDrawing)
        }
    }
    
    func showDrawing(_ isShowDrawing : Bool){
        let toolPicker = PKToolPicker()
            toolPicker.setVisible(isShowDrawing, forFirstResponder: drawingView)
            toolPicker.addObserver(drawingView)
    }

    
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
        if noteTitle.text != ""{
            let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: self.managedObjectContext) as! Note
            note.noteTitle = noteTitle.text
            note.noteText = descriptionTitle.text
            note.images = imageData
            do{
                try self.managedObjectContext.save()
            }catch {
                print("\(error)")
            }
            self.noteArray.append(note)
        }else{
            dismiss(animated: true)
        }
    }
    
    func fetchAllItem(){
        let requesr = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            let result = try managedObjectContext.fetch(requesr)
            noteArray = result as! [Note]
        } catch{
            print("\(error)")
        }
    }
    
}
