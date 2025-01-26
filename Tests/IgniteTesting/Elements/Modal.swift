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
    @Test("Show Modals Test")
    func showModal() async throws {
        let element = Modal(id: "showModalId") {
            Text("Dismiss me by clicking on the backdrop.")
                .horizontalAlignment(.center)
                .font(.title3)
                .margin(.xLarge)
        }
        let output = element.render()
        
        #expect(output == """
        <div id="showModalId" tabindex="-1" class="modal fade" aria-hidden="true" aria-labelledby="modalLabel"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-body"><h3 class="m-5 text-center">Dismiss me by clicking on the backdrop.</h3></div></div></div></div>
        """)
    }

    @Test("Dismissing Modals Test")
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
        <div id="dismissModalId" tabindex="-1" class="modal fade" aria-hidden="true" aria-labelledby="modalLabel"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-body"><div class="text-end"><button type="button" class="btn btn-close" label="Close" onclick="const modal = document.getElementById('dismissModalId');
        const modalInstance = bootstrap.Modal.getInstance(modal);
        if (modalInstance) { modalInstance.hide(); }"></button></div><h3 class="m-5 text-center">Dismiss me by clicking on the close button.</h3></div></div></div></div>
        """)
    }

    @Test("Modal Size Test")
    func checkModalSizes() async throws {
        let element = Modal(id: "ModalId") {
            Text(markdown: "Modal with size `.\(Modal.Size.small)`")
                .horizontalAlignment(.center)
                .font(.title3)
                .margin(.xLarge)
        }
        guard let small = Modal.Size.small.htmlClass else { return }
        #expect(element.size(.small).render().contains("\(small)"))

        guard let medium = Modal.Size.medium.htmlClass else { return }
        #expect(element.size(.medium).render().contains("\(medium)"))

        guard let large = Modal.Size.large.htmlClass else { return }
        #expect(element.size(.large).render().contains("\(large)"))

        guard let xLarge = Modal.Size.xLarge.htmlClass else { return }
        #expect(element.size(.xLarge).render().contains("\(xLarge)"))

        guard let fullscreen = Modal.Size.fullscreen.htmlClass else { return }
        #expect(element.size(.fullscreen).render().contains("\(fullscreen)"))
    }

    @Test("Modal Position Test")
    func checkModalPosition() async throws {
        let element = Modal(id: "topModalId") {
            Text(markdown: "Modal with `Position`")
                .horizontalAlignment(.center)
                .font(.title3)
                .margin(.xLarge)
        }
        guard let top = Modal.Position.top.htmlName else { return }
        #expect(element.modalPosition(.top).render().contains("\(top)"))

        guard let center = Modal.Position.center.htmlName else { return }
        #expect(element.modalPosition(.center).render().contains("\(center)"))
    }

    @Test("Modal Headers Test")
    func modalHeaders() async throws {
        let element = Modal(id: "headerModalId") {
            Text("Body")
        } header: {
            Text("Header").font(.title5)
            
            Button().role(.close).onClick{
                DismissModal(id: "headerModalId")
            }
        }
        let output = element.render()

        #expect(output == """
                <div id="headerModalId" tabindex="-1" class="modal fade" aria-hidden="true" aria-labelledby="modalLabel"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-header"><h5>Header</h5><button type="button" class="btn btn-close" label="Close" onclick="const modal = document.getElementById('headerModalId');
                const modalInstance = bootstrap.Modal.getInstance(modal);
                if (modalInstance) { modalInstance.hide(); }"></button></div><div class="modal-body"><p>Body</p></div></div></div></div>
                """)
    }

    @Test("Modal Footers Test")
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
                <div id="footerModalId" tabindex="-1" class="modal fade" aria-hidden="true" aria-labelledby="modalLabel"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-body"><p>Body</p></div><div class="modal-footer"><button type="button" class="btn btn-secondary" onclick="const modal = document.getElementById('footerModalId');
                const modalInstance = bootstrap.Modal.getInstance(modal);
                if (modalInstance) { modalInstance.hide(); }">Close</button><button type="button" class="btn btn-primary">Go</button></div></div></div></div>
                """)
    }

    @Test("Modal Headers and Footers Test")
    func modalHeadersAndFooters() async throws {
        let element = Modal(id: "headerAndFooterModalId") {
            Text("Body")
        } header: {
            Text("Header").font(.title5)

            Button().role(.close).onClick{
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
                <div id="headerAndFooterModalId" tabindex="-1" class="modal fade" aria-hidden="true" aria-labelledby="modalLabel"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-header"><h5>Header</h5><button type="button" class="btn btn-close" label="Close" onclick="const modal = document.getElementById('headerAndFooterModalId');
                const modalInstance = bootstrap.Modal.getInstance(modal);
                if (modalInstance) { modalInstance.hide(); }"></button></div><div class="modal-body"><p>Body</p></div><div class="modal-footer"><button type="button" class="btn btn-secondary" onclick="const modal = document.getElementById('headerAndFooterModalId');
                const modalInstance = bootstrap.Modal.getInstance(modal);
                if (modalInstance) { modalInstance.hide(); }">Close</button><button type="button" class="btn btn-primary">Go</button></div></div></div></div>
                """)
    }

    @Test("Modal Scrollable Content Test")
    func modalScrollableContent() async throws {
        let element = Modal(id: "modal7") {
            Text("""
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. pariatur laboris labore magna culpa laboris, tempor ea ut magna consequat minim. Occaecat dolore eu labore pariatur, ea exercitation id. Culpa ullamco in labore et, aliquip id consequat excepteur aute, eu in, culpa sed. Reprehenderit voluptate eiusmod mollit exercitation sunt, anim irure cupidatat officia. Do excepteur proident veniam fugiat deserunt mollit dolor. Laboris cillum. Aute ad officia. Eu mollit deserunt voluptate dolore labore do, reprehenderit. Nostrud. Consequat. Qui, eiusmod laboris qui et exercitation aliquip exercitation laborum mollit sint aute magna, veniam labore quis mollit consequat quis nostrud id laboris veniam commodo dolore quis eu aliqua aute, reprehenderit. Dolor occaecat reprehenderit ex occaecat. Dolore reprehenderit. Anim ad ut eiusmod commodo, sunt laboris id culpa. Proident, sunt commodo in nulla sed eiusmod, deserunt occaecat fugiat reprehenderit. Velit veniam tempor nulla irure qui ut minim aliqua, irure sunt commodo aute, occaecat sed eu ut sed labore cillum sed duis aliquip. Tempor dolore do duis eiusmod culpa minim aliquip. Sed. Excepteur, incididunt velit ad occaecat tempor est aute labore. Commodo, cillum sint culpa, aute excepteur dolore aliqua enim proident. Anim ad mollit, dolore pariatur. Laboris ullamco nulla aliquip dolor id id ullamco exercitation excepteur reprehenderit culpa. Culpa, ullamco et aliquip incididunt voluptate quis aliquip ut sunt tempor culpa et. Nisi aliquip sed et minim sunt. Aute. Non culpa commodo. Officia nulla aliquip. Commodo minim tempor laboris anim veniam eiusmod duis sunt eiusmod duis. Eu laborum. Eiusmod. Sunt do consequat enim consequat aliqua excepteur nostrud, do qui. Aliqua nulla quis cupidatat veniam cupidatat duis nulla nisi id. Occaecat cillum veniam deserunt nulla cupidatat, magna aliquip et minim enim voluptate. Aliquip do voluptate enim quis eiusmod nulla, sed sint, nostrud cillum, cupidatat est. Est et voluptate irure occaecat ea incididunt magna aute. Deserunt. Tempor eiusmod consequat ad minim, deserunt nostrud sunt cupidatat. Excepteur. Consequat occaecat esse cupidatat. Nostrud minim laborum, mollit reprehenderit ullamco fugiat. Tempor laboris id aliquip tempor esse aliqua consequat cillum culpa. Fugiat eu exercitation consequat excepteur, sunt ut ex aute, cillum sint aliquip labore, ex officia voluptate do deserunt sed irure magna deserunt, magna. Ullamco. Et. Tempor in nisi, fugiat laborum eu fugiat deserunt incididunt. Mollit. Deserunt non, eu magna anim tempor id voluptate cillum officia. Laborum aute in dolor. Nostrud aute, qui officia reprehenderit consequat do ullamco aute. Qui in culpa tempor pariatur nulla excepteur excepteur reprehenderit anim dolore culpa reprehenderit nostrud ullamco fugiat eu, nisi minim proident. Id commodo ad officia veniam id nulla. Nisi eiusmod, qui irure laborum. Ea nisi sint nulla, sed esse anim nisi magna deserunt officia pariatur ea. Nostrud in veniam. Pariatur, qui nisi minim anim. Occaecat sint. Deserunt. Nulla cupidatat commodo enim sed duis labore laborum in, nostrud do incididunt consequat id, ullamco non ut ad sint. Occaecat nostrud deserunt. Excepteur reprehenderit labore cillum cillum anim aliquip, proident fugiat aliqua proident occaecat pariatur. Duis ut enim tempor. Commodo minim eiusmod ex in reprehenderit velit ea in quis sed in ex in non qui enim esse duis. Mollit. Nisi duis velit et do. Labore occaecat fugiat sint, duis non qui duis commodo nostrud eu esse dolor in. Do, do. Sed ex, est nisi excepteur do commodo. Est voluptate non cillum. Ad eiusmod nostrud consequat mollit sed excepteur minim aute esse. Sed deserunt veniam non do ex, pariatur ullamco pariatur fugiat. Ut minim est nisi. Ex quis. Irure, aliqua. Qui, aute velit aliqua labore ex laboris. Commodo tempor do irure. Nostrud. Anim, culpa dolor dolor laborum laborum ex irure incididunt eiusmod veniam aliquip do ullamco. Eiusmod. Minim dolor mollit occaecat. Sunt nisi labore, laborum. Qui et cupidatat mollit et mollit minim proident consequat non aliqua ullamco cillum duis dolor sint enim sunt magna esse culpa, non, velit, incididunt, commodo sed. Cupidatat eu eu esse reprehenderit proident minim pariatur magna, nisi sed cillum exercitation eu exercitation officia ex. Officia dolor nulla consequat exercitation et id magna ea nisi qui deserunt occaecat anim officia sint ea sed non anim fugiat in tempor minim pariatur, aliqua et occaecat laboris ea quis veniam non do cillum. Ut. Ea. Proident enim deserunt tempor magna minim, irure ad deserunt cillum officia pariatur nostrud. Ullamco veniam officia voluptate in aliquip commodo. Ad, non qui, pariatur deserunt. Mollit magna officia fugiat, tempor minim. Et ex laboris, tempor nisi consequat occaecat, labore laborum nulla deserunt laborum id. Eiusmod aute veniam, est enim, proident aliquip reprehenderit. Duis occaecat ut aute commodo, tempor exercitation et consequat culpa veniam voluptate commodo. Eiusmod in, exercitation exercitation in anim tempor pariatur deserunt dolore anim non eiusmod nulla enim nostrud duis id velit cupidatat, esse sint velit id ad eu irure do ad voluptate, cillum, consequat cillum do laboris. Est, labore aute. Aliquip excepteur tempor consequat, incididunt commodo irure occaecat ut veniam esse laborum in non dolore sed laborum aliqua excepteur sed sed nisi eiusmod in sint commodo ex nostrud velit, culpa laboris est excepteur veniam, cupidatat consequat culpa. Esse laboris officia labore id, velit laboris consequat proident pariatur dolor sint laboris dolore tempor ullamco pariatur officia nostrud laborum. Quis ullamco non pariatur pariatur ea ex velit sed incididunt irure labore, exercitation in minim velit. Sunt irure. Nostrud nulla sunt, do labore. Enim eiusmod officia. Incididunt tempor ad mollit commodo dolore fugiat pariatur veniam incididunt sunt tempor magna, ad, mollit voluptate quis labore, est. Mollit, nostrud. Fugiat incididunt ad eiusmod. Laborum. Quis, cillum ullamco reprehenderit incididunt, reprehenderit sint est deserunt cillum nostrud, dolor veniam deserunt et id fugiat, enim cillum. Non tempor voluptate ex do anim pariatur pariatur veniam nulla dolore voluptate aliquip laboris cupidatat est culpa sint eiusmod dolore eiusmod cillum aliqua. Labore ad, excepteur id et ex nulla ex, aute deserunt nisi. Enim magna velit. Fugiat, exercitation, reprehenderit et aute proident laborum occaecat mollit magna in do ullamco commodo dolor, sunt ea id consequat eiusmod non ea cillum quis eiusmod. Incididunt, irure. Cillum nulla do. Pariatur reprehenderit exercitation sunt eu cillum fugiat enim enim non in minim sint ut dolore ad, velit, nulla culpa. Dolor, cillum mollit culpa fugiat. Dolore ut, deserunt, cillum.
            """)
        } header: {
            Text("Long text")
                .font(.title5)
        }
        .size(.large)
        .scrollableContent(true)

        let output = element.render()
        #expect(output == """
                <div id="modal7" tabindex="-1" class="modal fade" aria-hidden="true" aria-labelledby="modalLabel"><div class="modal-dialog modal-dialog-centered modal-dialog-scrollable modal-lg"><div class="modal-content"><div class="modal-header"><h5>Long text</h5></div><div class="modal-body"><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. pariatur laboris labore magna culpa laboris, tempor ea ut magna consequat minim. Occaecat dolore eu labore pariatur, ea exercitation id. Culpa ullamco in labore et, aliquip id consequat excepteur aute, eu in, culpa sed. Reprehenderit voluptate eiusmod mollit exercitation sunt, anim irure cupidatat officia. Do excepteur proident veniam fugiat deserunt mollit dolor. Laboris cillum. Aute ad officia. Eu mollit deserunt voluptate dolore labore do, reprehenderit. Nostrud. Consequat. Qui, eiusmod laboris qui et exercitation aliquip exercitation laborum mollit sint aute magna, veniam labore quis mollit consequat quis nostrud id laboris veniam commodo dolore quis eu aliqua aute, reprehenderit. Dolor occaecat reprehenderit ex occaecat. Dolore reprehenderit. Anim ad ut eiusmod commodo, sunt laboris id culpa. Proident, sunt commodo in nulla sed eiusmod, deserunt occaecat fugiat reprehenderit. Velit veniam tempor nulla irure qui ut minim aliqua, irure sunt commodo aute, occaecat sed eu ut sed labore cillum sed duis aliquip. Tempor dolore do duis eiusmod culpa minim aliquip. Sed. Excepteur, incididunt velit ad occaecat tempor est aute labore. Commodo, cillum sint culpa, aute excepteur dolore aliqua enim proident. Anim ad mollit, dolore pariatur. Laboris ullamco nulla aliquip dolor id id ullamco exercitation excepteur reprehenderit culpa. Culpa, ullamco et aliquip incididunt voluptate quis aliquip ut sunt tempor culpa et. Nisi aliquip sed et minim sunt. Aute. Non culpa commodo. Officia nulla aliquip. Commodo minim tempor laboris anim veniam eiusmod duis sunt eiusmod duis. Eu laborum. Eiusmod. Sunt do consequat enim consequat aliqua excepteur nostrud, do qui. Aliqua nulla quis cupidatat veniam cupidatat duis nulla nisi id. Occaecat cillum veniam deserunt nulla cupidatat, magna aliquip et minim enim voluptate. Aliquip do voluptate enim quis eiusmod nulla, sed sint, nostrud cillum, cupidatat est. Est et voluptate irure occaecat ea incididunt magna aute. Deserunt. Tempor eiusmod consequat ad minim, deserunt nostrud sunt cupidatat. Excepteur. Consequat occaecat esse cupidatat. Nostrud minim laborum, mollit reprehenderit ullamco fugiat. Tempor laboris id aliquip tempor esse aliqua consequat cillum culpa. Fugiat eu exercitation consequat excepteur, sunt ut ex aute, cillum sint aliquip labore, ex officia voluptate do deserunt sed irure magna deserunt, magna. Ullamco. Et. Tempor in nisi, fugiat laborum eu fugiat deserunt incididunt. Mollit. Deserunt non, eu magna anim tempor id voluptate cillum officia. Laborum aute in dolor. Nostrud aute, qui officia reprehenderit consequat do ullamco aute. Qui in culpa tempor pariatur nulla excepteur excepteur reprehenderit anim dolore culpa reprehenderit nostrud ullamco fugiat eu, nisi minim proident. Id commodo ad officia veniam id nulla. Nisi eiusmod, qui irure laborum. Ea nisi sint nulla, sed esse anim nisi magna deserunt officia pariatur ea. Nostrud in veniam. Pariatur, qui nisi minim anim. Occaecat sint. Deserunt. Nulla cupidatat commodo enim sed duis labore laborum in, nostrud do incididunt consequat id, ullamco non ut ad sint. Occaecat nostrud deserunt. Excepteur reprehenderit labore cillum cillum anim aliquip, proident fugiat aliqua proident occaecat pariatur. Duis ut enim tempor. Commodo minim eiusmod ex in reprehenderit velit ea in quis sed in ex in non qui enim esse duis. Mollit. Nisi duis velit et do. Labore occaecat fugiat sint, duis non qui duis commodo nostrud eu esse dolor in. Do, do. Sed ex, est nisi excepteur do commodo. Est voluptate non cillum. Ad eiusmod nostrud consequat mollit sed excepteur minim aute esse. Sed deserunt veniam non do ex, pariatur ullamco pariatur fugiat. Ut minim est nisi. Ex quis. Irure, aliqua. Qui, aute velit aliqua labore ex laboris. Commodo tempor do irure. Nostrud. Anim, culpa dolor dolor laborum laborum ex irure incididunt eiusmod veniam aliquip do ullamco. Eiusmod. Minim dolor mollit occaecat. Sunt nisi labore, laborum. Qui et cupidatat mollit et mollit minim proident consequat non aliqua ullamco cillum duis dolor sint enim sunt magna esse culpa, non, velit, incididunt, commodo sed. Cupidatat eu eu esse reprehenderit proident minim pariatur magna, nisi sed cillum exercitation eu exercitation officia ex. Officia dolor nulla consequat exercitation et id magna ea nisi qui deserunt occaecat anim officia sint ea sed non anim fugiat in tempor minim pariatur, aliqua et occaecat laboris ea quis veniam non do cillum. Ut. Ea. Proident enim deserunt tempor magna minim, irure ad deserunt cillum officia pariatur nostrud. Ullamco veniam officia voluptate in aliquip commodo. Ad, non qui, pariatur deserunt. Mollit magna officia fugiat, tempor minim. Et ex laboris, tempor nisi consequat occaecat, labore laborum nulla deserunt laborum id. Eiusmod aute veniam, est enim, proident aliquip reprehenderit. Duis occaecat ut aute commodo, tempor exercitation et consequat culpa veniam voluptate commodo. Eiusmod in, exercitation exercitation in anim tempor pariatur deserunt dolore anim non eiusmod nulla enim nostrud duis id velit cupidatat, esse sint velit id ad eu irure do ad voluptate, cillum, consequat cillum do laboris. Est, labore aute. Aliquip excepteur tempor consequat, incididunt commodo irure occaecat ut veniam esse laborum in non dolore sed laborum aliqua excepteur sed sed nisi eiusmod in sint commodo ex nostrud velit, culpa laboris est excepteur veniam, cupidatat consequat culpa. Esse laboris officia labore id, velit laboris consequat proident pariatur dolor sint laboris dolore tempor ullamco pariatur officia nostrud laborum. Quis ullamco non pariatur pariatur ea ex velit sed incididunt irure labore, exercitation in minim velit. Sunt irure. Nostrud nulla sunt, do labore. Enim eiusmod officia. Incididunt tempor ad mollit commodo dolore fugiat pariatur veniam incididunt sunt tempor magna, ad, mollit voluptate quis labore, est. Mollit, nostrud. Fugiat incididunt ad eiusmod. Laborum. Quis, cillum ullamco reprehenderit incididunt, reprehenderit sint est deserunt cillum nostrud, dolor veniam deserunt et id fugiat, enim cillum. Non tempor voluptate ex do anim pariatur pariatur veniam nulla dolore voluptate aliquip laboris cupidatat est culpa sint eiusmod dolore eiusmod cillum aliqua. Labore ad, excepteur id et ex nulla ex, aute deserunt nisi. Enim magna velit. Fugiat, exercitation, reprehenderit et aute proident laborum occaecat mollit magna in do ullamco commodo dolor, sunt ea id consequat eiusmod non ea cillum quis eiusmod. Incididunt, irure. Cillum nulla do. Pariatur reprehenderit exercitation sunt eu cillum fugiat enim enim non in minim sint ut dolore ad, velit, nulla culpa. Dolor, cillum mollit culpa fugiat. Dolore ut, deserunt, cillum.</p></div></div></div></div>
                """)
    }

    @Test("Modals Presentation Options Test", arguments: [ShowModal.Option.backdrop(dismissible: true), ShowModal.Option.backdrop(dismissible: false), ShowModal.Option.noBackdrop, ShowModal.Option.focus(true), ShowModal.Option.focus(false), ShowModal.Option.keyboard(true), ShowModal.Option.keyboard(false)])
    func checkModalPresentationOptions(option: ShowModal.Option) async throws {
        let element = Button("Show Modal") {
            ShowModal(id: "showModalId", options: [option])
        }
        let output = element.render()
        
        #expect(output == """
        <button type="button" class="btn" onclick="const options = {
            \(option.htmlOption)
        };
        const modal = new bootstrap.Modal(document.getElementById('showModalId'), options);
        modal.show();">Show Modal</button>
        """)
    }

}
