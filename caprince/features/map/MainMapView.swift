import SwiftUI

struct MainMapView: View {
    @StateObject private var viewModel: RunTrackerViewModel
    var onRunComplete: () -> Void
    
    init(week: TrainingWeek? = nil, day: TrainingDay? = nil, onRunComplete: @escaping () -> Void) {
        let vm = RunTrackerViewModel()
        vm.currentWeek = week
        vm.currentDay = day
        _viewModel = StateObject(wrappedValue: vm)
        self.onRunComplete = onRunComplete
    }
    
    var body: some View {
//        Group {
            if viewModel.sessionState == .finished {
                FinishRunView(viewModel: viewModel, onRunComplete: onRunComplete)
            } else {
                ActiveRunView(viewModel: viewModel, trainingDay: viewModel.currentDay)
            }
//        }
//        .foregroundStyle(.black)
    }
}
