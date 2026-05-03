//
//  caprinceWidgetLiveActivity.swift
//  caprinceWidget
//
//  Created by Maula Izza Azizi on 24/04/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct caprinceWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }
    
    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct caprinceWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: caprinceWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension caprinceWidgetAttributes {
    fileprivate static var preview: caprinceWidgetAttributes {
        caprinceWidgetAttributes(name: "World")
    }
}

extension caprinceWidgetAttributes.ContentState {
    fileprivate static var smiley: caprinceWidgetAttributes.ContentState {
        caprinceWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: caprinceWidgetAttributes.ContentState {
         caprinceWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: caprinceWidgetAttributes.preview) {
   caprinceWidgetLiveActivity()
} contentStates: {
    caprinceWidgetAttributes.ContentState.smiley
    caprinceWidgetAttributes.ContentState.starEyes
}
