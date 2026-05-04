import SwiftUI

struct MainMapView: View {
    @StateObject private var viewModel = RunTrackerViewModel()
    
    var body: some View {
//        Group {
            if viewModel.sessionState == .finished {
                FinishRunView(viewModel: viewModel)
            } else {
                ActiveRunView(viewModel: viewModel)
            }
//        }
//        .foregroundStyle(.black) 
    }
}
