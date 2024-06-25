import CoreData

final class GeoObjectPersistentService: GeoObjectServiceProtocol {
    private let coreDataStack: CoreDataStackProtocol
    
    init(coreDataStack: CoreDataStackProtocol) {
        self.coreDataStack = coreDataStack
    }
    
    @discardableResult
    func createGeoObject(title: String, subtitle: String, longitude: Decimal, latitude: Decimal) -> GeoObjectPersistent {
        let newGeoObject = GeoObjectPersistent(context: coreDataStack.context)
        newGeoObject.title = title
        newGeoObject.subtitle = subtitle
        newGeoObject.longitude = NSDecimalNumber(decimal: longitude)
        newGeoObject.latitude = NSDecimalNumber(decimal: latitude)
        coreDataStack.saveContext()
        return newGeoObject
    }
    
    func fetchGeoObjects() -> [GeoObjectPersistent] {
        let request = GeoObjectPersistent.fetchRequest()
        do {
            return try coreDataStack.context.fetch(request)
        } catch {
            print("Fetch failed")
            return []
        }
    }
    
    func deleteGeoObject(with name: String, subtitle: String) {
        let request = GeoObjectPersistent.fetchRequest()
        let titleCondition = NSPredicate(format: "title == %@", name)
        let subtitileCondidtion = NSPredicate(format: "subtitle == %@", subtitle)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [titleCondition, subtitileCondidtion])
        
        do {
            let geoObjectsToDelete = try coreDataStack.context.fetch(request)
            for geoObjectToDelete in geoObjectsToDelete {
                coreDataStack.context.delete(geoObjectToDelete)
                coreDataStack.saveContext()
            }
        } catch {
            print("Fetch failed")
        }
    }
}
