import SwiftUI

struct MainMapView: View {
    @StateObject private var viewModel = RunTrackerViewModel()
    var trainingDay: TrainingDay?
    var onRunComplete: () -> Void
    
    var body: some View {
//        Group {
            if viewModel.sessionState == .finished {
                FinishRunView(viewModel: viewModel, onRunComplete: onRunComplete)
            } else {
                ActiveRunView(viewModel: viewModel, trainingDay: trainingDay)
            }
//        }
//        .foregroundStyle(.black)
    }
}
