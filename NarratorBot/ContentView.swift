//
// Copyright (c) Vatsal Manot
//

import Media
import SwiftUIX
import Merge

struct ContentView: View {
    @State var tasks: [NarrationTask] = []
    @State var isInspectorPresented: Bool = true
    
    var body: some View {
        NavigationStack {
            CameraViewReader { (cameraProxy: CameraViewProxy) in
                VStack {
                    CameraView(camera: .front, mirrored: false)
                        .padding(.small)
                }
                .safeAreaInset(edge: .bottom) {
                    VStack {
                        Text("Capture a photo to start NarratorBot!")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        CaptureButton(camera: cameraProxy) { image in
                            self.tasks.insert(NarrationTask(image: image))
                        }
                    }
                    .padding(.large)
                }
            }
            .modify { content in
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    content.inspector(isPresented: $isInspectorPresented) {
                        inspector
                            .frame(minWidth: 256)
                    }
                } else {
#if os(macOS)
                    HSplitView {
                        content
                        inspector
                            .frame(minWidth: 256)
                    }
#endif
                }
                
            }
            .toolbar {
                ToolbarItemGroup {
                    sidebarToggle
                }
            }
            .modify(if: .mac) {
                $0.frame(minWidth: 1024, minHeight: 512 * 1.25)
            }
        }
    }
    
    struct CaptureButton: View {
        let camera: CameraViewProxy
        let onCapture: (AppKitOrUIKitImage) -> Void
        
        var body: some View {
            /// Take a screenshot using the camera, and queue up a `NarrationTask`.
            TaskButton {
                let image: AppKitOrUIKitImage = try! await camera.capturePhoto()
                
                onCapture(image)
            } label: {
                Label {
                    Text("Capture Photo")
                } icon: {
                    Image(systemName: .cameraFill)
                }
                .font(.title3)
                .controlSize(.large)
                .padding(.small)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    
    private var inspector: some View {
        List {
            if tasks.isEmpty {
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    ContentUnavailableView {
                        Text("No Items")
                    }
                }
            } else {
                ForEach(tasks) { task in
                    TaskCell(task: task)
                }
            }
        }
        .frame(minWidth: 256)
    }
    
    private var sidebarToggle: some View {
        Button {
            withAnimation {
                isInspectorPresented.toggle()
            }
        } label: {
            Label {
                Text("Narrations")
                    .foregroundStyle(.primary)
            } icon: {
                Image(systemName: .theatermasksFill)
                    .fixedSize()
                    .padding(.horizontal, .extraSmall)
                    .foregroundStyle(.orange)
            }
            .font(.title3)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Auxiliary

extension ContentView {
    /// The cell that represents a narration task.
    private struct TaskCell: View {
        @ObservedObject var task: NarrationTask
        
        var body: some View {
            HStack(spacing: 4) {
                Image(image: task.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 64)
                    .padding(.extraSmall)
                    .border(Color.secondary)
                
                activityDisclosureView
            }
        }
        
        @ViewBuilder
        private var activityDisclosureView: some View {
            switch task.state {
                case .queued:
                    Text("Queued")
                        .font(.body.italic())
                        .foregroundStyle(.secondary)
                case .inProgress:
                    ActivityIndicator()
                        .controlSize(.mini)
                case .complete:
                    Text("Narration Complete")
                        .font(.body)
                        .foregroundStyle(.primary)
                case .failed:
                    Image(systemName: .exclamationmarkTriangleFill)
                        .font(.body)
                        .foregroundStyle(.red)
                    
            }
        }
    }
}

// MARK: - Internal

/// To silence the the `Sendable` warning.
extension AppKitOrUIKitImage: @unchecked Sendable {
    
}
