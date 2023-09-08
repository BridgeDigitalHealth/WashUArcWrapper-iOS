//
//  ARCAssessmentView.swift
//

import SwiftUI

#if canImport(UIKit)

import UIKit
import BridgeClientExtension
import JsonModel
import Arc

public final class ARCAssessmentViewDelegate : ARCCognitiveHomeViewControllerDelegate, ArcAssessmentDelegate, ArcAssessmentNavigationDelegate {
    
    let viewController: UIViewController
    let viewModel: ScheduledAssessmentHandler
    let assessmentInfo: AssessmentScheduleInfo
    let arcIdentifier: ARCIdentifier
    
    var arcNavigation: ARCCognitiveNavigationController {
        return Arc.shared.appNavigation as! ARCCognitiveNavigationController
    }

    public func homeViewController() -> UIViewController {
        return viewController
    }
    
    init(_ info: AssessmentScheduleInfo, _ assessmentManager: ScheduledAssessmentHandler) {
        self.viewModel = assessmentManager
        self.assessmentInfo = info
        self.arcIdentifier = ARCIdentifier(rawValue: info.assessmentInfo.identifier)!
        
        // This can be any sequence of states, to add more screens to the assessment,
        // you can send in something like this [.signatureStart, .symbolsTest, .signatureEnd]
        let stateList = [self.arcIdentifier.appState()]
                
        let arcInfo = ArcAssessmentSupplementalInfo(
            sessionID: abs(Int64(info.session.hashValue)), // TODO: mdephillips 3/23/23
            // this should be the index of the session within all of the sessions in the
            // schedule.  It's fine for now as hash, as it only controls randomizing
            // the price test set of prices shown to the user.
            sessionAvailableDate: info.session.scheduledOn,
            weekInStudy: 0, // This is only applicable to study bursts
            dayInWeek: 0, // This is only applicable to study bursts
            sessionInDay: 0) // This is only applicable to study bursts
        
        self.viewController = (Arc.shared.appNavigation as! ARCCognitiveNavigationController)
            .startTest(stateList: stateList, info: arcInfo)!
        
        self.arcNavigation.vcDelegate = self
        Arc.shared.delegate = self
        Arc.shared.navigationDelegate = self
    }
    
    @MainActor
    public func onAssessmentSkipRequested() {
        viewModel.updateAssessmentStatus(assessmentInfo, status: .declined(Date()))
        self.arcNavigation.endTest()
    }
    
    @MainActor
    public func onAssessmentCancelRequested() {
        viewModel.updateAssessmentStatus(assessmentInfo, status: .restartLater)
        self.arcNavigation.endTest()
    }
    
    @MainActor
    public func assessmentComplete(result: ArcAssessmentResult?) {
        guard let jsonData = result?.fullTestSession?.encode(outputFormatting: .none) else {
            assertionFailure("Error uploading ARC data, could not encode to JSON")
            return
        }
        let archiveBuilder = JsonResultArchiveBuilder(
            json: jsonData,
            filename: "data.json",
            schema: self.arcIdentifier.jsonSchemaUrl(),
            schedule: assessmentInfo)!
        viewModel.updateAssessmentStatus(assessmentInfo, status: .saveAndFinish(archiveBuilder))
        self.arcNavigation.endTest()
    }
}

public struct ARCAssessmentView : UIViewControllerRepresentable {
    
    let assessmentManager: ScheduledAssessmentHandler
    let info: AssessmentScheduleInfo
    
    public init(_ info: AssessmentScheduleInfo, handler assessmentManager: ScheduledAssessmentHandler) {
        self.info = info
        self.assessmentManager = assessmentManager
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator.homeViewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // no-op
    }
    
    public func makeCoordinator() -> ARCAssessmentViewDelegate {
        ARCAssessmentViewDelegate(info, assessmentManager)
    }
}

#endif
