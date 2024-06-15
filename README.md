> [!IMPORTANT]
> Created by [Preternatural AI](https://preternatural.ai/), an exhaustive client-side AI infrastructure for Swift.<br/>
> This project and the frameworks used are presently in alpha stage of development.

# NarratorBot: Transform Image into Audio 

A bot that narrates what it sees in front of it, in the style of a BBC nature documentary with the voice of Sir David Attenborough. Uses GPT-4o for image understanding and ElevenLabs for Audio Generation.
<br/><br/>
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/PreternaturalAI/AI/blob/main/LICENSE)

## Table of Contents
- [Usage](#usage)
- [Key Concepts](#key-concepts)
- [Preternatural Frameworks](#preternatural-frameworks)
- [Technical Specifications](#technical-specifications)
  - [Image-to-Text (Vision) Implementation](#image-to-text-vision-implementation)
  - [Text-to-Speech (TTS) Implementation](#text-to-speech-tts-implementation)
- [Acknowledgements](#acknowledgements)
- [License](#license)

## Usage
#### Supported Platforms
<!-- macOS-->
<p align="left">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos.svg">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos-active.svg">
  <img alt="macos" src="https://raw.githubusercontent.com/PreternaturalAI/AI/main/Images/macos-active.svg" height="24">
</picture>&nbsp;
</p>

1. Download [Xcode](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjnldW19OWCAxW4AjQIHbxQBqUQFnoECBYQAQ&url=https%3A%2F%2Fapps.apple.com%2Fus%2Fapp%2Fxcode%2Fid497799835%3Fmt%3D12&usg=AOvVaw2fEvMbfRtGhB4SPHYB54NX&opi=89978449) from the App Store.
2. Open `NarratorBot.xcodeproj` and wait for it to resolve packages.
3. Add your OpenAI API Key in the `LLMManager` file:
```swift
// LLMManager
private static let llm: any LLMRequestHandling = OpenAI.Client(apiKey: "YOUR_API_KEY")
```
*You can get the OpenAI API key on the [OpenAI developer website](https://platform.openai.com/). Note that you have to set up billing and add a small amount of money for the API calls to work (this will cost you less than 1 dollar).* <br/>

4. Add your ElevenLabs API Key in `TTSManager`: 
```swift
// TTSManager
private static let tts: ElevenLabs.Client = .init(apiKey: "YOUR_API_KEY")
```
*[ElevenLabs](https://elevenlabs.io/) is a “Text-to-Speech” (TTS) service which is used in the NarratorBot app to generate the audio of the image description. You can get your ElevenLabs API Key on the ElevenLabs website. The API key is located in your user profile:*

<img width="256" alt="elevenlabskey" src="https://github.com/preternatural-explore/NarratorBot/assets/1157147/162d3462-21f9-45fa-9ad1-ffc5312386e2">

5. Click run. You will be prompted to trust macros from `CorePersistence` and `SwiftUIZ`. Click trust.
6. Click run again.

Upon successful installation, enjoy the app!<br/>

https://github.com/preternatural-explore/narrator-bot/blob/main/286146979-29be0f4d-1673-4e74-af31-66f21b046008.mp4

## Key Concepts
The Narrator app is developed to demonstrate the the following key concepts:

- Working with OpenAI's Vision API 
- Using ElevenLabs for Audio Generation

## Preternatural Frameworks
The following Preternatural Frameworks were used in this project: 
- [AI](https://github.com/PreternaturalAI/AI): The definitive, open-source Swift framework for interfacing with generative AI.
- [Media](https://github.com/vmanot/Media): Media makes it stupid simple to work with media capture & playback in Swift.

## Technical Specifications
Large Language Models (LLMs) are rapidly evolving and expanding into multimodal capabilities - the ability to process inputs in multiple modes, such as text, images, and audio. Multi-modal LLMs are now starting to be referred to as Large Multimodal Models, or LMMs. As Apple Developers, we are in the perfect position for these multimodal AI models as we are making applications for devices that consumers literally use with built-in cameras and voice recorders. With the Vision capabilities of LLMs, it is easier than ever to process images that the user captures in novel ways, such as in this example of NarratorBot. 

### Image-to-Text (Vision) Implementation
When a user opens NarratorBot, they are prompted via a camera view to capture a photo of themselves. The first step is to send the photo to an LLM and instruct it to describe what is in the photo. This is done in a few simple steps using [Preternatural's AI framework](https://github.com/PreternaturalAI/AI): 

1. Import the AI Framework: 
```swift
// LLMManager
import AI
```
2. Specify the LLM client. Currently only OpenAI GPT 4+ models are able to process images (Anthropic will be added as well in the near future). 
```swift
private static let llm: any LLMRequestHandling = OpenAI.Client(apiKey: "YOUR_API_KEY")
```
3. Specify the LLM Model. Currently only OpenAI's GPT 4+ models support Vision requests:
```swift
static let model: OpenAI.Model = .gpt_4o // .gpt_4
```
4. The image will be a prompt input for the LLM model. Converting the image (`UIKit` and `NSImage` supported) to an `PromptLiteral` is simple:
```swift
let imagePrompt = try PromptLiteral(image: image)
```
5. Specify the System Prompt to give the LLM model general instructions.
```swift
// TTSManager.narrator.prompt
let prompt: PromptLiteral =
  """
  You are Sir David Attenborough. Follow these instructions:
  
  1. Narrate the picture of the human as if it is a nature documentary.
  2. Make it snarky and funny.
  3. Don't repeat yourself.
  4. Make it short.
  5. If I do anything remotely interesting, make a big deal about it!
  """
```
6. Include the System Prompt, User Prompt, and ImagePrompt as Messages for the LLM:
```swift
// LLMManager
let messages: [AbstractLLM.ChatMessage] = [
    .system(TTSManager.narrator.prompt),
    .user {
        .concatenate(separator: nil) {
            PromptLiteral("Describe this image") // the user prompt
            imagePrompt
        }
    }
]
```
7. Add any Parameters, such as a Token Limit:
```swift
let tokenLimit = 1000
let parameters = AbstractLLM.ChatCompletionParameters(
                tokenLimit: .fixed(tokenLimit))
```
8. Make the LLM completion request to get the image description in Sir David Attenborough's nature documentary style:
```swift
let imageDescription: String = try await llm.complete(
        messages,
        parameters: parameters,
        model: llmModel,
        as: .string)

return imageDescription
```

You can view the full implementation in `LLMManager`.

### Text-to-Speech (TTS) Implementation
Now that we have the text of what Sir David Attenborough would say if he was a picture of a human, we can generate the audio in Sir David Attenborough's voice that [ElevenLabs](https://elevenlabs.io/) provides in their VoiceLab. To do this, we first have to specify the Sir David Attenborough's voice id: 

```swift
//TTSManager
var elevenLabsVoice: String {
    switch self {
    // future voice implementation
    case .ericCartman:
        return "ZvOw3uFB0hlmUg3wjXi6"
    // ElevenLabs has many voices in the style of David Attenborough
    // Voices can also be easily cloned
    // (if you do clone and make a commercial product, make sure you have the concent of the voice actor)
    case .davidAttenborough:
        return "17jPwOCwyfZmp68jZqhx"
    }
}
```

To make a speech generation call to the ElevenLabs client using the AI framework, we need to import the `AI` and `ElevenLabs` modules: 
```swift
// TTSManager
import AI
import ElevenLabs
```

Next, we specify the client: 
```swift
private static let tts: ElevenLabs.Client = .init(apiKey: "YOUR_API_KEY")
```

Now, simply provide the text to be converted to audio (the image description of the user generated by OpenAI's Vision API) and the audio data will be returned: 
```swift
static func createTextNarration(_ text: String) async throws -> Data {
    let data = try await tts.speech(
        for: text,
        voiceID: narrator.elevenLabsVoice,
        voiceSettings: ElevenLabs.VoiceSettings(),
        model: .TurboV2
    )
    return data
}
```

You can view the full implementation in `TTSManager`.

### Conclusion
While LLMs initially gained popularity in chat mode, they are evolving to offer much more, including the ability to analyze images (and even videos). When combined with powerful models like ElevenLabs' voice generation API, this creates a powerful and versatile toolset for us as developers. The NarratorBot example demonstrates the potential of this technology by combining OpenAI's Image-to-Text (Vision) capabilities with ElevenLabs' Text-to-Speech (voice generation) API to create a dynamic, entertaining narration based on user-captured photos. 

## Acknowledgements

This app is the product of a fun night of hacking with my friend [Siddarth](https://twitter.com/siddarth_gandhi)!

## License

This package is licensed under the [MIT License](https://github.com/PreternaturalAI/AI/blob/main/LICENSE).
