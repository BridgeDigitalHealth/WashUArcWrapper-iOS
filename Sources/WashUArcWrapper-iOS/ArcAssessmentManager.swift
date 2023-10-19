//
//  ArcAssessmentManager.swift
//

import SwiftUI
import AssessmentModelUI
import BridgeClient
import BridgeClientExtension
import BridgeClientUI
import Arc

public final class ArcAssessmentManager {
    public static let shared: ArcAssessmentManager = .init()

    private init() {
    }
    
    public func hasAssessment(with assessmentId: String) -> Bool {
        ARCIdentifier(rawValue: assessmentId) != nil
    }
    
    /// **Required**
    /// Call on app launch to set up the assessments.
    public func onLaunch() {
        // Configure Arc Assessment library
        Arc.configureWithEnvironment(environment: ARCCognitiveEnvironment())
    }
}

public enum ARCIdentifier: String, CaseIterable {
    case symbols = "symbol_test",
         prices = "price_test",
         grids = "grid_test"
    
    func appState() -> ARCCognitiveState {
        switch self {
        case .symbols:
            return ARCCognitiveState.symbolsTest
        case .prices:
            return ARCCognitiveState.priceTest
        case .grids:
            return ARCCognitiveState.gridTest
        }
    }
    
    func jsonSchemaUrl() -> URL {
        switch self {
        case .symbols:
            return URL(string: "https://github.com/CTRLab-WashU/ArcAssessmentsiOS/blob/0076b71cf018547c8c5f09946a3e050dbe41aecb/Arc/Resources/example_schema_symbols.json")!
        case .prices:
            return URL(string: "https://github.com/CTRLab-WashU/ArcAssessmentsiOS/blob/0076b71cf018547c8c5f09946a3e050dbe41aecb/Arc/Resources/example_schema_prices.json")!
        case .grids:
            return URL(string: "https://github.com/CTRLab-WashU/ArcAssessmentsiOS/blob/0076b71cf018547c8c5f09946a3e050dbe41aecb/Arc/Resources/example_schema_grids.json")!
        }
    }
}

extension ARCIdentifier : AssessmentInfoExtension {
    
    public var assessmentIdentifier: String { self.rawValue }
    
    public func title() -> SwiftUI.Text {
        switch self {
        case .grids:
            return Text("Grids")
        case .prices:
            return Text("Prices")
        case .symbols:
            return Text("Symbols")
        }
    }
    
    public func icon() -> ContentImage {
        .init(self.rawValue, bundle: .module)
    }
    
    public func color() -> Color {
        .accentColor
    }
}
