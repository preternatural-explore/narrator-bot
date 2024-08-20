//
// Copyright (c) Vatsal Manot
//

import SwiftUIX
import Merge
import AVFoundation
import CorePersistence

class NarrationTask: Identifiable, ObservableObject {
    /// The serial queue in which all narration tasks are performed.
    private static let queue = TaskQueue()
    
    /// The state of this task.
    public enum State: Codable, Hashable, Sendable {
        case queued
        case inProgress
        case complete
        case failed(String)
    }

    public var id: UUID = UUID()

    /// The image to create a narration for.
    let image: _AnyImage
    /// The state of the task.
    @Published private(set) var state: State = .queued
    
    private var audioPlayer: AVPlayer?
    
    init(image: _AnyImage) {
        self.image = image
        
        Self.queue.addTask { @MainActor in
            self.state = .inProgress
            
            do {
                try await _warnOnThrow {
                    try await self.perform()
                }
                
                self.state = .complete
            } catch {
                self.state = .failed(String(describing: error))
            }
        }
    }
    
    @MainActor
    private func perform() async throws {
        let imageDescription = try await LLMManager.describeImage(image: image)
        let narrationData = try await TTSManager.createTextNarration(imageDescription)
        
        
        let speechFile = try URL.temporaryFile(name: "\(UUID().uuidString).mpg", data: narrationData)
        
        audioPlayer = AVPlayer(playerItem: AVPlayerItem(url: speechFile))
        audioPlayer?.play()
    }
}


