import CoreData

extension NSManagedObjectModel {
    convenience init?(with modelName: String, bundle: Bundle = Bundle.main) {
        let modelUrl = bundle.url(forResource: modelName, withExtension: "momd")
        self.init(contentsOf: modelUrl!)
    }
}
