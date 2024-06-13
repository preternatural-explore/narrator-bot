//
// Copyright (c) Vatsal Manot
//

import AI
import ElevenLabs
import Foundation

struct TTSManager {
    private static let tts: ElevenLabs.Client = .init(apiKey: "YOUR_API_KEY")
    
    /// The narrator chosen
    static let narrator: TTSManager.NarratorPersona = .davidAttenborough
    
    static func createTextNarration(_ text: String) async throws -> Data {
        let data = try await tts.speech(
            for: text,
            voiceID: narrator.elevenLabsVoice,
            voiceSettings: ElevenLabs.VoiceSettings(),
            model: .TurboV2
        )
        return data
    }
}

extension TTSManager {
    /// The persona we want for our narrator.
    public enum NarratorPersona {
        case ericCartman
        case davidAttenborough
        
        /// The system prompt for this narrator.
        var prompt: PromptLiteral {
            switch self {
            case .davidAttenborough:
                let prompt: PromptLiteral =
                    """
                    You are Sir David Attenborough. Follow these instructions:
                    
                    1. Narrate the picture of the human as if it is a nature documentary.
                    2. Make it snarky and funny.
                    3. Don't repeat yourself.
                    4. Make it short.
                    5. If I do anything remotely interesting, make a big deal about it!
                    """
                
                return prompt
            case .ericCartman:
                fatalError(.unimplemented)
            }
        }
        
        var elevenLabsVoice: String {
            switch self {
            case .ericCartman:
                return "ZvOw3uFB0hlmUg3wjXi6"
            case .davidAttenborough:
                return "17jPwOCwyfZmp68jZqhx"
            }
        }
    }
}
