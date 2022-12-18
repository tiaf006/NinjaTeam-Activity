//
//  deleteTableView.swift
//  CRUDActivity
//
//  Created by maram  on 23/05/1444 AH.
//

import UIKit
import CoreData

class deleteTableView: UIViewController , UITableViewDataSource, UITableViewDelegate {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    @IBOutlet weak var deletedNoteTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: (UIImage(named: "bb")!))
        
        self.deletedNoteTable.backgroundColor = .clear
        print("Hi ninjas mmmmm ")
        deletedNoteTable.dataSource = self
        deletedNoteTable.delegate = self
        fechAllItems()
        deletedNoteTable.reloadData()
        // Do any additional setup after loading the view.
    }
    
    var deletedNotes = [Note]()

    func addDeleted(note: Note){
        print("tttttttttttt")
        self.managedObjectContext.insert(note)
        self.deletedNotes.append(note)
        
        do{
            try self.managedObjectContext.save()
        }catch {print(error)}
        self.deletedNoteTable.reloadData()
        
        
    }
    func fechAllItems(){
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do{
            let result = try managedObjectContext.fetch(request)
            deletedNotes = result as! [Note]
            print(result)
        }catch{
            print("\(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    
    let edit = UIContextualAction(style: .normal, title: "Bring Back") {(action, view, compeletionHandler) in
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let notesTableVC = storyBoard.instantiateViewController(withIdentifier: "note") as! notesTableView
        notesTableVC.loadView()
        let deletedNote = self.deletedNotes[indexPath.row]
        notesTableVC.bringNoteBack(note: deletedNote)
        self.managedObjectContext.delete(deletedNote)
        self.deletedNotes.remove(at: indexPath.row)
       
        do{
            try self.managedObjectContext.save()
            
        }catch{ print("\(error)")}
        tableView.reloadData()
    }
    edit.backgroundColor = .systemBrown
    
    let delete = UIContextualAction(style: .normal, title: "Delete") { [self](action, view, compeletionHandler) in
        self.managedObjectContext.delete(deletedNotes[indexPath.row])
        self.deletedNotes.remove(at: indexPath.row)
        
       
       // self.deletedNotes.remove(at: indexPath.row)
        do{
            try self.managedObjectContext.save()
            
        }catch{ print("\(error)")}
        tableView.reloadData()
        
    }
        delete.backgroundColor = .systemRed
        
    let swip = UISwipeActionsConfiguration(actions: [edit, delete])
    return swip
}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        deletedNoteTable.rowHeight = 100
        return deletedNotes.count
}

    func deleteTableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return deletedNotes.count
}

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as! noteCell
        cell.dateLable.text = "\(deletedNotes[indexPath.row].createdDate)"
        cell.textLable.text = deletedNotes[indexPath.row].noteText
        cell.titleLable.text = deletedNotes[indexPath.row].noteTitle
      
    return cell
    }
}
