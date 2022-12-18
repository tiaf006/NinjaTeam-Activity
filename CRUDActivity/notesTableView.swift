//
//  ViewController.swift
//  CRUDActivity

import UIKit
import CoreData

class notesTableView: UIViewController, noteDelegate{

    @IBOutlet weak var notesTable: UITableView!
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var notes: [Note] = []
    let formatter =  DateFormatter()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: (UIImage(named: "bb")!))
        
        self.notesTable.backgroundColor = .clear
        print(notes.count)
       
        notesTable.dataSource = self
        notesTable.delegate = self
        
       
        fechAllItems()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addNote(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let editOrAddNoteVC = storyBoard.instantiateViewController(withIdentifier: "editOrAddNote") as! NotesViewController
        editOrAddNoteVC.loadView()
        editOrAddNoteVC.delg = self
        editOrAddNoteVC.save.tag = 1
        navigationController?.pushViewController(editOrAddNoteVC, animated: true)
        editOrAddNoteVC.navigationController?.navigationItem.title = " New Note"
        
       /*
        
        
        formatter.dateFormat = "E, d/MM/yyyy"
        let date = Date()
        let DateString = formatter.string(from: date)
        newNote?.createdDate = (formatter.date(from: DateString))
        //notes.append(newNote)
        print(newNote)
        notesTable.reloadData()
           */
    }
    
    func fechAllItems(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            let result = try managedObjectContext.fetch(request)
            notes = result as! [Note]
            print(result)
        }catch{
            print("\(error)")
        }
    }
    func bringNoteBack(note: Note){
        self.managedObjectContext.insert(note)
        self.notes.append(note)
        
        do{
            try managedObjectContext.save()
        }catch{print(error)}
        notesTable.reloadData()
    }
    
    @IBAction func viewDeletedNotes(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let deletedNotesVC = storyBoard.instantiateViewController(withIdentifier: "dN") as! deleteTableView
        navigationController?.pushViewController(deletedNotesVC, animated: true)
    }
    
}
extension notesTableView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesTable.rowHeight = 100
        return notes.count
       // return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! noteCell
        cell.titleLable.text = notes[indexPath.row].noteTitle
        
        cell.textLable.text = notes[indexPath.row].noteText
        cell.dateLable.text = "\(String(describing: notes[indexPath.row].createdDate))"
      
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal, title: "Edit")
        {(action, view, compeletionHandler) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let editVC = storyBoard.instantiateViewController(withIdentifier: "editOrAddNote") as! NotesViewController
            editVC.loadView()
            editVC.save.tag = 0
            editVC.index = indexPath
            editVC.noteTitle.text = self.notes[indexPath.row].noteTitle
            editVC.descriptionTitle.text = self.notes[indexPath.row].noteText
            editVC.delg = self
                        self.navigationController?.pushViewController(editVC, animated: true)
            
        }
        edit.backgroundColor = .systemBrown
        
        let delete = UIContextualAction(style: .normal, title: "Delete") {(action, view, compeletionHandler) in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let deletedNotsVC = storyBoard.instantiateViewController(withIdentifier: "dN") as! deleteTableView
            deletedNotsVC.loadView()
            let deletedNote = self.notes[indexPath.row]
            deletedNotsVC.addDeleted(note: deletedNote)
            self.managedObjectContext.delete(deletedNote)
            self.notes.remove(at: indexPath.row)
           
            do{
                try self.managedObjectContext.save()
                
            }catch{ print("\(error)")}
            tableView.reloadData()
            
            
        }
        delete.backgroundColor = .systemRed
        
        let swip = UISwipeActionsConfiguration(actions: [edit, delete])
        return swip
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
    func saveAdd(_ title: String, _ description: String) {
         let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: managedObjectContext) as! Note
         
         note.noteTitle = title
         note.noteText = description
        formatter.dateStyle = .short
        let date = Date()
        let DateString = formatter.string(from: date )
        note.createdDate = formatter.date(from: DateString)
           print("appenddddddd")
         managedObjectContext.insert(note)
         notes.append(note)
        notesTable.reloadData()
         do{
             try managedObjectContext.save()
             
         }catch{ print("\(error)")}
               //notesTable.reloadData()
         
        
           }
     
     func saveEdit(_ indexPath: NSIndexPath?, _ title: String, _ description: String) {
         if let ip = indexPath{
            
             let note = notes[ip.row]
             note.noteTitle = title
             note.noteText = description
             formatter.dateStyle = .short
             let date = Date()
             let DateString = formatter.string(from: Date())
             note.createdDate! = formatter.date(from: DateString)!
             print(note)
             
             do{
                 try managedObjectContext.save()
                 
             }catch{ print("\(error)")}
             self.notesTable.reloadData()
         }
         
     }
    
}


