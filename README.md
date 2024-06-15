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
https://github.com/preternatural-explore/NarratorBot/blob/main/286146979-29be0f4d-1673-4e74-af31-66f21b046008.mp4

## Key Concepts
The Narrator app is developed to demonstrate the the following key concepts:

- Working with OpenAI's Vision API 
- Using ElevenLabs for Audio Generation

## Preternatural Frameworks
The following Preternatural Frameworks were used in this project: 
- [AI](https://github.com/PreternaturalAI/AI): The definitive, open-source Swift framework for interfacing with generative AI.
- [Media](https://github.com/vmanot/Media): Media makes it stupid simple to work with media capture & playback in Swift.

## Acknowledgements

This app is the product of a fun night of hacking with my friend [Siddarth](https://twitter.com/siddarth_gandhi)!

## License

This package is licensed under the [MIT License](https://github.com/PreternaturalAI/AI/blob/main/LICENSE).
