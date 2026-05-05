import Foundation
import Observation
import Combine
import AudioToolbox
import AVFoundation

@Observable
class WorkoutTimerManager {
    var workoutSteps: [WorkoutStep]
    var currentStepIndex: Int = 0
    var timeRemaining: Int = 0
    var isRunning: Bool = false
    var isFinished: Bool = false
    
    private var timer: Timer?
    private let speechSynthesizer = AVSpeechSynthesizer()
    private var hasAnnouncedFirstStep = false
    
    var currentStep: WorkoutStep? {
        guard currentStepIndex < workoutSteps.count else { return nil }
        return workoutSteps[currentStepIndex]
    }
    
    var progress: Double {
        guard let currentStep = currentStep else { return 1.0 }
        let total = Double(currentStep.durationInSeconds)
        let remaining = Double(timeRemaining)
        return total > 0 ? (total - remaining) / total : 1.0
    }
    
    init(steps: [WorkoutStep] = []) {
        self.workoutSteps = steps
        if let firstStep = steps.first {
            self.timeRemaining = firstStep.durationInSeconds
        }
    }
    
    func loadSteps(_ steps: [WorkoutStep]) {
        self.workoutSteps = steps
        self.currentStepIndex = 0
        self.isFinished = false
        self.isRunning = false
        self.hasAnnouncedFirstStep = false
        if let firstStep = steps.first {
            self.timeRemaining = firstStep.durationInSeconds
        }
    }
    
    func start() {
        guard !isFinished, !workoutSteps.isEmpty else { return }
        isRunning = true
        if !hasAnnouncedFirstStep {
            announceCurrentStep()
            hasAnnouncedFirstStep = true
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }
    
    func pause() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }
    
    func stop() {
        pause()
        isFinished = true
    }
    
    private func tick() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            nextStep()
        }
    }
    
    private func nextStep() {
        playHapticFeedback()
        currentStepIndex += 1
        
        if currentStepIndex < workoutSteps.count {
            timeRemaining = workoutSteps[currentStepIndex].durationInSeconds
            announceCurrentStep()
        } else {
            // Workout complete
            announce("Workout Complete")
            stop()
        }
    }
    
    private func announceCurrentStep() {
        guard let step = currentStep else { return }
        let text = "Start \(step.activity.rawValue)"
        announce(text)
    }
    
    private func announce(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.37
        speechSynthesizer.speak(utterance)
    }
    
    private func playHapticFeedback() {
        // Vibrate and ding
        AudioServicesPlaySystemSound(SystemSoundID(1013)) // kSystemSoundID_Vibrate
        AudioServicesPlaySystemSound(1005) // Short ding
    }
    
    // Formatting time for UI
    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
