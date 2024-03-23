<p align="center">
    <img src="images/logo.png" alt="Ignite logo" width="256" height="234" />
</p>

<p align="center">
    <img src="https://img.shields.io/badge/macOS-14.0+-2980b9.svg" />
    <img src="https://img.shields.io/badge/swift-5.9+-8e44ad.svg" />
    <a href="https://twitter.com/twostraws">
        <img src="https://img.shields.io/badge/Contact-@twostraws-95a5a6.svg?style=flat" alt="Twitter: @twostraws" />
    </a>
</p>

Ignite is a static site builder for Swift developers, offering an expressive, powerful API to build beautiful websites that work great on all devices.

Ignite doesn't try to convert SwiftUI code to HTML, or simply map HTML tags to Swift code. Instead, it aims to use SwiftUI-like syntax to help you build great websites even if you have no knowledge of HTML or CSS.


## Getting started

Ignite uses Swift Package Manager, so you can use Xcode to add a package dependency for <https://github.com/twostraws/Ignite>.

Once that completes, import Ignite into your Swift code wherever needed:

```swift
import Ignite
```

However, the easiest way to get started is to clone the [Ignite Starter Template](https://github.com/twostraws/IgniteStarter) repository here on GitHub. It comes preconfigured to build a simple site, which you can then adapt for your own needs.

Seriously, if you want to get started quickly, clone the starter template and use that – it's much easier than starting from scratch!


## See it in action

The [IgniteSamples](https://github.com/twostraws/IgniteSamples) repository contains lots of sample code for you to try out – you can see it running here: You can see all the output from this repository running here: <https://ignitesamples.hackingwithswift.com>.

Basic Ignite code looks similar to SwiftUI code:

```swift
Text("Swift rocks")
    .font(.title1)
    
Text(markdown: "Add *inline* Markdown")
    .foregroundStyle(.secondary)

Link("Swift", target: "https://www.swift.org")
    .linkStyle(.button)

Divider()

Image("logo.jpg")
    .accessibilityLabel("The Swift logo.")
    .padding()
```

But it also includes a range of more advanced controls such as dropdown buttons:

```swift
Dropdown("Click Me") {
    Link("Accordions", target: AccordionExamples())
    Link("Carousels", target: CarouselExamples())
    Divider()
    Text("Or you can just…")
    Link("Go back home", target: "/")
}
.role(.primary)
```

![A dropdown button showing links, a divider, and some text.](images/dropdown.png)

It includes accordions that show or hide items based on what is selected:

```swift
Accordion {
    Item("First", startsOpen: true) {
        Text("This item will start open by default.")
    }

    Item("Second") {
        Text("This is the second accordion item.")
    }

    Item("Third") {
        Text("This is the third accordion item.")
    }
}
.openMode(.individual)
```

![An accordion of three items, where the first one is open.](images/accordions.png)
 
It has automatic code syntax highlighting for a dozen languages:

```swift
CodeBlock(language: "swift", """
struct ContentView: View {
    var body: some View {
        Text("Hello, Swift!")
    }
}
""")
```

![Swift code with syntax highlighting.](images/code.png)

Plus carousels, badges, alerts, tables, and so much more.

There is a separate repository called [IgniteSamples](https://github.com/twostraws/IgniteSamples), which provides sample code for a wide variety of protocols, elements, and modifiers used by Ignite.

If you're looking for code to help you get started, that's the best place – you can build that site and run it locally, the copy and paste any code you want to try.


## Folder structure

Ignite sites are just Swift package, but they use a specific folder structure to help build your site effectively.

- **Assets**: This is where your custom site assets should be placed, using whatever subfolders you want.
- **Build**: This is created automatically by Ignite whenever you build your site. Do not place important information here, because it will be deleted on your next build.
- **Content:** This is where you want to place any Markdown files for posts you want, again using any subfolder structure you want. (Optional)
- **Includes:** This is where you place any custom HTML you've written that you want to include. (Optional)
- **Sources:** This is where you'll place all your Swift code for your site, using any subfolder structure that suits you.

This folder structure is already in place in the [Ignite Starter Template](https://github.com/twostraws/IgniteStarter) repository, and I recommend you start with that.


## Contributing

I welcome all contributions, whether that's adding new tests, fixing up existing code, adding comments, or improving this README – everyone is welcome!

- You must comment your code thoroughly, using documentation comments or regular comments as applicable.
- All code must be licensed under the MIT license so it can benefit the most people.
- If you create a new element, please consider adding it to the IgniteSamples repository, so folks can see it more easily.


## License

MIT License.

Copyright (c) 2024 Paul Hudson.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Ignite was made by [Paul Hudson](https://twitter.com/twostraws), who writes [free Swift tutorials over at Hacking with Swift](https://www.hackingwithswift.com). It’s available under the MIT license, which permits commercial use, modification, distribution, and private use.


<p align="center">
    <a href="https://www.hackingwithswift.com/plus">
    <img src="https://www.hackingwithswift.com/img/hws-plus-banner@2x.jpg" alt="Hacking with Swift+ logo" style="max-width: 100%;" /></a>
</p>

<p align="center">&nbsp;</p>

<p align="center">
    <a href="https://www.hackingwithswift.com"><img src="https://www.hackingwithswift.com/img/hws-button@2x.png" alt="Hacking with Swift logo" width="66" height="75" /></a><br />
    A Hacking with Swift Project
</p>
