
import SwiftUI
import CoreData
import MarkdownUI

struct DeviceUpdateDetails: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var device: Device
    
    var version : Version? {
        let fetchRequest = Version.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tagName == %@", device.latestUpdateVersionTagAvailable ?? "")

        
        do {
            return try viewContext.fetch(fetchRequest).first
        } catch {
            print("Unexpected error when loading version: \(error)")
            return nil
        }
        
    }
    
    
    var body: some View {
        VStack {
            ScrollView {
                Markdown(version?.versionDescription ?? "[Unknown Error]")
                    .padding()
            }
        }
        .navigationTitle("Version \(version?.tagName ?? "")")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Skip This Version") {
                    skipVersion()
                }
                
                Spacer()

                Button("Install") {
                    installVersion()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    func skipVersion() {
        device.skipUpdateTag = device.latestUpdateVersionTagAvailable
        device.latestUpdateVersionTagAvailable = ""
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        dismiss()
    }
    
    func installVersion() {
        // TODO: Actually install version
    }
    
    
}

struct DeviceUpdateDetails_Previews: PreviewProvider {
    static let device = Device(context: PersistenceController.preview.container.viewContext)
    
    static var previews: some View {
        device.tag = UUID()
        device.version = "0.13.0"
        device.latestUpdateVersionTagAvailable = "v0.14.0"
        
        
        return NavigationView{
            DeviceUpdateDetails()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .environmentObject(device)
        }
    }
}
