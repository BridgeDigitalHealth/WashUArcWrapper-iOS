// Created 10/19/23
// swift-tools-version:5.0

import SwiftUI
import BridgeClient
import BridgeClientExtension
import BridgeClientUI
import WashUArcWrapper_iOS

let kAssessmentInfoMap: AssessmentInfoMap = .init(extensions: ARCIdentifier.allCases)

struct ContentView: View {
    @State var assessments: [TodayTimelineAssessment] = previewAssessments
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(assessments) {
                    AssessmentTimelineCardView($0)
                }
            }
        }
        .padding()
        .assessmentInfoMap(kAssessmentInfoMap)
    }
}

#Preview {
    ContentView()
}

let previewAssessments: [TodayTimelineAssessment] = ARCIdentifier.allCases.map {
    TodayTimelineAssessment(.init(identifier: $0.rawValue, label: $0.rawValue.replacing("_", with: " ").capitalized))
}

extension NativeScheduledAssessment {
    fileprivate convenience init(identifier: String, label: String? = nil) {
        self.init(instanceGuid: UUID().uuidString,
                  assessmentInfo: AssessmentInfo(identifier: identifier, label: label),
                  isCompleted: false,
                  isDeclined: false,
                  adherenceRecords: nil)
    }
}

extension AssessmentInfo {
    fileprivate convenience init(identifier: String, label: String? = nil, background: String? = nil) {
        let colorScheme: BridgeClient.ColorScheme? = background.map {
            .init(foreground: $0, background: $0, activated: nil, inactivated: nil, type: nil)
        }
        self.init(key: identifier,
                  guid: UUID().uuidString,
                  appId: kPreviewStudyId,
                  identifier: identifier,
                  revision: nil,
                  label: label ?? identifier,
                  minutesToComplete: 3,
                  colorScheme: colorScheme,
                  configUrl: "nil",
                  imageResource: nil,
                  type: "AssessmentInfo")
    }
}
