import CoreData

protocol CoreDataStackProtocol {
    var context: NSManagedObjectContext { get }
    func saveContext()
}
