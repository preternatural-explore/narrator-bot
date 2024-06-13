//
// Copyright (c) Vatsal Manot
//

import AI
import SwiftUIX

struct LLMManager {
    private static let llm: any LLMRequestHandling = OpenAI.Client(apiKey: "YOUR_API_KEY")
    private static let llmModel = OpenAI.Model.gpt_4o
    private static let tokenLimit = 1000
    
    static func describeImage(image: AppKitOrUIKitImage) async throws -> String {
            let imagePrompt = try PromptLiteral(image: image)
            
            let messages: [AbstractLLM.ChatMessage] = [
                .system(TTSManager.narrator.prompt),
                .user {
                    .concatenate(separator: nil) {
                        PromptLiteral("Describe this image")
                        imagePrompt
                    }
                }
            ]
            
            let parameters = AbstractLLM.ChatCompletionParameters(
                tokenLimit: .fixed(tokenLimit))
            
            let imageDescription: String = try await llm.complete(
                    messages,
                    parameters: parameters,
                    model: llmModel,
                    as: .string)
            
            return imageDescription
    }
}
