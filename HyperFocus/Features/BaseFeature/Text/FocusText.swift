//
//  FocusText.swift
//  HyperFocus
//
//  Created by 김영건 on 12/28/25.
//


struct FocusText {
    static let goalPlaceholder = "What's your one thing?\n(Optional)"
    static let readingBook = "Reading Book"
    static let homework = "HomeWork"
    static let running = "Running"
    static let add = "Add"
    
    struct WrapUpAlert {
        static let title = "Wrapping up early?"
        static let description = "You focused for 21m!\nWant to save this progress?"
        static let save = "Save & Complete"
        static let resume = "Resume Timer"
        static let delete = "Delete"
    }
    
    struct EarlyWrapUpAlert {
        static let title = "Just warming up?"
        static let description = "It's been under 3 mins.\nKeep going or discard?"
        static let keep = "Keep Focusing"
        static let delete = "Delete"
    }
    
    struct CompletedBottomSheet {
        static let title = "Dopamine Shower! \nFeels good, right? 🚿"
        static let hyperFocus = "🔥 (Hyperfocus!)"
        static let good = "🙂 (Good)"
        static let distracted = "🤯 (Distracted)"
        static let finishSession = "Finish Session"
        static let fiveMinBreak = "Take a 5m Break"
    }
    
    struct FailReationBottomSheet {
        static let title = "What broke the flow?"
    }
    
    struct RestCompletion {
        static let title = "Rest Complete!\n\nContinue focusing on\n\"%@\"?"
        static let resumeFlow = "Resume Flow"
        static let startNextTask = "Start Next Task"
        static let fiveMinuteBreak = "☕️ 5m more break"
    }
}
