//
//  Modal.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `Modal` element.
@Suite("Modal Tests")
@MainActor
struct ModalTests {
    @Test("Show Modals")
    func showModal() async throws {
        let element = Modal(id: "showModalId") {
            Text("Dismiss me by clicking on the backdrop.")
                .horizontalAlignment(.center)
                .font(.title3)
                .margin(.xLarge)
        }
        let output = element.render()

        #expect(output == """
        <div id="showModalId" tabindex="-1" class="modal fade" aria-labelledby="modalLabel" aria-hidden="true">\
        <div class="modal-dialog modal-dialog-centered">\
        <div class="modal-content"><div class="modal-body">\
        <h3 class="text-center m-5">Dismiss me by clicking on the backdrop.</h3>\
        </div></div></div></div>
        """)
    }

    @Test("Dismissing Modals")
    func dismissModal() async throws {
        let element = Modal(id: "dismissModalId") {
            Section {
                Button().role(.close).onClick {
                    DismissModal(id: "dismissModalId")
                }
            }
            .horizontalAlignment(.trailing)

            Text("Dismiss me by clicking on the close button.")
                .horizontalAlignment(.center)
                .font(.title3)
                .margin(.xLarge)
        }
        let output = element.render()

        #expect(output == """
        <div id="dismissModalId" tabindex="-1" class="modal fade" aria-labelledby="modalLabel" aria-hidden="true">\
        <div class="modal-dialog modal-dialog-centered"><div class="modal-content">\
        <div class="modal-body"><div class="text-end">\
        <button type="button" class="btn btn-close" label="Close" onclick="\
        const modal = document.getElementById('dismissModalId');
        const modalInstance = bootstrap.Modal.getInstance(modal);
        if (modalInstance) { modalInstance.hide(); }"></button></div>\
        <h3 class="text-center m-5">Dismiss me by clicking on the close button.</h3></div></div></div></div>
        """)
    }

    @Test("Modal Size",
          arguments: Modal.Size.allCases)
    func checkModalSizes(sizeOption: Modal.Size) async throws {
        let element = Modal(id: "ModalId") {
            Text(markdown: "Modal with size")
                .horizontalAlignment(.center)
                .font(.title3)
                .margin(.xLarge)
        }
        .size(sizeOption)
        let output = element.render()

        if let htmlClass = sizeOption.htmlClass {
            #expect(output.contains("""
            <div class="modal-dialog \(htmlClass) modal-dialog-centered">
            """))
        } else {
            #expect(output.contains("""
            <div class="modal-dialog modal-dialog-centered">
            """))
        }
    }

    @Test("Modal Position", arguments: Modal.Position.allCases)
    func checkModalPosition(positionOption: Modal.Position) async throws {
        let element = Modal(id: "topModalId") {
            Text(markdown: "Modal with `Position`")
                .horizontalAlignment(.center)
                .font(.title3)
                .margin(.xLarge)
        }
            .modalPosition(positionOption)

        let output = element.render()
        if let htmlName = positionOption.htmlName {
            #expect(output.contains("""
            <div class="modal-dialog \(htmlName)">
            """))
        } else {
            #expect(output.contains("""
            <div class="modal-dialog">
            """))
        }

    }

    @Test("Modal Headers")
    func modalHeaders() async throws {
        let element = Modal(id: "headerModalId") {
            Text("Body")
        } header: {
            Text("Header").font(.title5)

            Button().role(.close).onClick {
                DismissModal(id: "headerModalId")
            }
        }
        let output = element.render()

        #expect(output == """
        <div id="headerModalId" tabindex="-1" class="modal fade" aria-labelledby="modalLabel" aria-hidden="true">\
        <div class="modal-dialog modal-dialog-centered"><div class="modal-content">\
        <div class="modal-header"><h5>Header</h5>\
        <button type="button" class="btn btn-close" label="Close" onclick="\
        const modal = document.getElementById('headerModalId');
        const modalInstance = bootstrap.Modal.getInstance(modal);
        if (modalInstance) { modalInstance.hide(); }"></button></div>\
        <div class="modal-body"><p>Body</p></div></div></div></div>
        """)
    }

    @Test("Modal Footers")
    func modalFooters() async throws {
        let element = Modal(id: "footerModalId") {
            Text("Body")
        } footer: {
            Button("Close") {
                DismissModal(id: "footerModalId")
            }
            .role(.secondary)

            Button("Go") {
                // Do something
            }
            .role(.primary)
        }
        let output = element.render()

        #expect(output == """
        <div id="footerModalId" tabindex="-1" class="modal fade" aria-labelledby="modalLabel" aria-hidden="true">\
        <div class="modal-dialog modal-dialog-centered"><div class="modal-content">\
        <div class="modal-body"><p>Body</p></div><div class="modal-footer">\
        <button type="button" class="btn btn-secondary" onclick="\
        const modal = document.getElementById('footerModalId');
        const modalInstance = bootstrap.Modal.getInstance(modal);
        if (modalInstance) { modalInstance.hide(); }">\
        Close</button><button type="button" class="btn btn-primary">Go</button></div></div></div></div>
        """)
    }

    @Test("Modal Headers and Footers")
    func modalHeadersAndFooters() async throws {
        let element = Modal(id: "headerAndFooterModalId") {
            Text("Body")
        } header: {
            Text("Header").font(.title5)

            Button().role(.close).onClick {
                DismissModal(id: "headerAndFooterModalId")
            }
        } footer: {
            Button("Close") {
                DismissModal(id: "headerAndFooterModalId")
            }
            .role(.secondary)

            Button("Go") {
                // Do something
            }
            .role(.primary)
        }
        let output = element.render()

        #expect(output == """
        <div id="headerAndFooterModalId" tabindex="-1" class="modal fade" \
        aria-labelledby="modalLabel" aria-hidden="true">\
        <div class="modal-dialog modal-dialog-centered">\
        <div class="modal-content"><div class="modal-header"><h5>Header</h5>\
        <button type="button" class="btn btn-close" label="Close" onclick="\
        const modal = document.getElementById('headerAndFooterModalId');
        const modalInstance = bootstrap.Modal.getInstance(modal);
        if (modalInstance) { modalInstance.hide(); }"></button></div>\
        <div class="modal-body"><p>Body</p></div><div class="modal-footer">\
        <button type="button" class="btn btn-secondary" onclick="\
        const modal = document.getElementById('headerAndFooterModalId');
        const modalInstance = bootstrap.Modal.getInstance(modal);
        if (modalInstance) { modalInstance.hide(); }">Close</button>\
        <button type="button" class="btn btn-primary">Go</button></div></div></div></div>
        """)
    }

    @Test("Modal Scrollable Content")
    func modalScrollableContent() async throws {
        let element = Modal(id: "modal7") {
            Text(placeholderLength: 1000)
        } header: {
            Text("Long text")
                .font(.title5)
        }
        .size(.large)
        .scrollableContent(true)

        let output = element.render()
        #expect(output.contains("""
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
        """))
    }

    @Test("Modals Presentation Options", arguments: [
        ShowModal.Option.backdrop(dismissible: true), ShowModal.Option.backdrop(dismissible: false),
        ShowModal.Option.noBackdrop, ShowModal.Option.focus(true), ShowModal.Option.focus(false),
        ShowModal.Option.keyboard(true), ShowModal.Option.keyboard(false)])
    func checkModalPresentationOptions(option: ShowModal.Option) async throws {
        let element = Button("Show Modal") {
            ShowModal(id: "showModalId", options: [option])
        }
        let output = element.render()

        #expect(output.contains("""
        <button type="button" class="btn" onclick="const options = {
            \(option.htmlOption)
        };
        """))
    }

}
