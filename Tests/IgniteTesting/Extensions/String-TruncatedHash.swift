//
//  String-TruncatedHash.swift
//  Ignite
//  https://www.github.com/twostraws/Ignite
//  See LICENSE for license information.
//

import Foundation
import Testing

@testable import Ignite

/// Tests for the `String-TruncatedHash` extension.
@Suite("String-TruncatedHash Tests")
@MainActor
struct StringTruncatedHashTests {

    struct Instance {
        let input: String
        let expected: String
    }

    @Test("Precalculated Values from some common strings", arguments: [
        Instance(input: "", expected: "nO10"),
        Instance(input: "hello world", expected: "xWt3"),
        Instance(input: "12345", expected: "cgbt"),
        Instance(input: "#&$?!", expected: "8Vtj"),
        Instance(input: "\t", expected: "Wmr2"),
        Instance(input: "\n", expected: "Xmr2")
    ])
    func from_common_strings(instance: Instance) async throws {
        #expect(instance.input.truncatedHash == instance.expected)
    }

    @Test("Precalculated Values from Public Domain Poetry", arguments: [
        Instance(input: "And whether pigs have wings.'", expected: "9poQ"),
        Instance(input: "After we've brought them out so far,", expected: "NOk1"),
        Instance(input: "\"The sun was shining on the sea,", expected: "SpUi"),
        Instance(input: "Their shoes were clean and neat —", expected: "6xjL"),
        Instance(input: "O Oysters, come and walk with us!'", expected: "VwCx"),
        Instance(input: "The billows smooth and bright —", expected: "DTg6"),
        Instance(input: "And you are very nice!'", expected: "mb9j"),
        Instance(input: "No cloud was in the sky:", expected: "HTAP"),
        Instance(input: "It was so kind of you to come!", expected: "zfeX"),
        Instance(input: "The sea was wet as wet could be,", expected: "EnJI"),
        Instance(input: "Pepper and vinegar besides", expected: "N7b3"),
        Instance(input: "Along the briny beach:", expected: "Snek"),
        Instance(input: "So rested he by the Tumtum tree", expected: "z3Di"),
        Instance(input: "The Jabberwock, with eyes of flame,", expected: "IktY"),
        Instance(input: "If seven maids with seven mops", expected: "3v1K"),
        Instance(input: "The jaws that bite, the claws that catch!", expected: "gVj9"),
        Instance(input: "The eldest Oyster looked at him,", expected: "YNtK"),
        Instance(input: "Before we have our chat;", expected: "jQBN"),
        Instance(input: "Walked on a mile or so,", expected: "54DK"),
        Instance(input: "BY LEWIS CARROLL", expected: "TYHr"),
        Instance(input: "But four young Oysters hurried up,", expected: "prqG"),
        Instance(input: "To play them such a trick,", expected: "jEC1"),
        Instance(input: "They said, it would be grand!'", expected: "noyL"),
        Instance(input: "Of shoes — and ships — and sealing-wax —", expected: "jgI4"),
        Instance(input: "The Carpenter said nothing but", expected: "tovX"),
        Instance(input: "The night is fine,' the Walrus said.", expected: "r1gP"),
        Instance(input: "And made them trot so quick!'", expected: "JPt9"),
        Instance(input: "With sobs and tears he sorted out", expected: "Ybkt"),
        Instance(input: "And this was odd, because, you know,", expected: "Y0BQ"),
        Instance(input: "The vorpal blade went snicker-snack!", expected: "XLYl"),
        Instance(input: "And then they rested on a rock", expected: "vXRR"),
        Instance(input: "Had got no business to be there", expected: "xrPL"),
        Instance(input: "Those of the largest size,", expected: "hc8t"),
        Instance(input: "And the mome raths outgrabe.", expected: "0RiG"),
        Instance(input: "And shook his heavy head —", expected: "nC9B"),
        Instance(input: "To leave the oyster-bed.", expected: "i7VS"),
        Instance(input: "The sands were dry as dry.", expected: "A6rU"),
        Instance(input: "Cut us another slice:", expected: "CU3v"),
        Instance(input: "They thanked him much for that.", expected: "FaXm"),
        Instance(input: "O Oysters,' said the Carpenter,", expected: "OzS1"),
        Instance(input: "And why the sea is boiling hot —", expected: "d9Ca"),
        Instance(input: "To talk of many things:", expected: "7TRe"),
        Instance(input: "They wept like anything to see", expected: "ssDe"),
        Instance(input: "He took his vorpal sword in hand;", expected: "vao0"),
        Instance(input: "Conveniently low:", expected: "PM2e"),
        Instance(input: "He went galumphing back.", expected: "NJZd"),
        Instance(input: "\"It's very rude of him,\" she said,", expected: "e1Z7"),
        Instance(input: "Is what we chiefly need:", expected: "fb8C"),
        Instance(input: "It seems a shame,' the Walrus said,", expected: "fP8g"),
        Instance(input: "Holding his pocket-handkerchief", expected: "VAgg"),
        Instance(input: "And yet another four;", expected: "ajAu"),
        Instance(input: "A dismal thing to do!'", expected: "WbHb"),
        Instance(input: "And thick and fast they came at last,", expected: "NNrL"),
        Instance(input: "The butter's spread too thick!'", expected: "MYKh"),
        Instance(input: "You've had a pleasant run!", expected: "c6sI"),
        Instance(input: "Come to my arms, my beamish boy!", expected: "RLaJ"),
        Instance(input: "Are very good indeed —", expected: "b4GT"),
        Instance(input: "Such quantities of sand:", expected: "2Zl9"),
        Instance(input: "There were no birds to fly.", expected: "nw3S"),
        Instance(input: "And waited in a row.", expected: "63wb"),
        Instance(input: "And stood awhile in thought.", expected: "n70h"),
        Instance(input: "And burbled as it came!", expected: "Qkue"),
        Instance(input: "And all the little Oysters stood", expected: "qkqT"),
        Instance(input: "And this was scarcely odd, because", expected: "CaBD"),
        Instance(input: "I doubt it,' said the Carpenter,", expected: "SoRJ"),
        Instance(input: "The time has come,' the Walrus said,", expected: "aOKj"),
        Instance(input: "Do you suppose,' the Walrus said,", expected: "9Zhv"),
        Instance(input: "For some of us are out of breath,", expected: "uF4S"),
        Instance(input: "And scrambling to the shore.", expected: "3dkw"),
        Instance(input: "He chortled in his joy.", expected: "8Ku4"),
        Instance(input: "The frumious Bandersnatch!”", expected: "PBh1"),
        Instance(input: "Of cabbages — and kings —", expected: "f03E"),
        Instance(input: "Meaning to say he did not choose", expected: "cCks"),
        Instance(input: "All hopping through the frothy waves,", expected: "hBK3"),
        Instance(input: "But not on us!' the Oysters cried,", expected: "zltd"),
        Instance(input: "O frabjous day! Callooh! Callay!”", expected: "eK3a"),
        Instance(input: "That they could get it clear?'", expected: "pLnw"),
        Instance(input: "All mimsy were the borogoves,", expected: "DRdD"),
        Instance(input: "I deeply sympathize.'", expected: "WK3p"),
        Instance(input: "But never a word he said:", expected: "htsD"),
        Instance(input: "If this were only cleared away,'", expected: "87PN"),
        Instance(input: "Swept it for half a year,", expected: "fnKv"),
        Instance(input: "Because she thought the sun", expected: "VyoP"),
        Instance(input: "And this was odd, because it was", expected: "IYC1"),
        Instance(input: "No hurry!' said the Carpenter.", expected: "6vnJ"),
        Instance(input: "After such kindness, that would be", expected: "i0rZ"),
        Instance(input: "And, as in uffish thought he stood,", expected: "1mGQ"),
        Instance(input: "He left it dead, and with its head", expected: "New9"),
        Instance(input: "And shed a bitter tear.", expected: "Bl4q"),
        Instance(input: "We cannot do with more than four,", expected: "Dklc"),
        Instance(input: "’Twas brillig, and the slithy toves", expected: "q0Mw"),
        Instance(input: "The Walrus and the Carpenter", expected: "Aaxf"),
        Instance(input: "Turning a little blue.", expected: "z4ZH"),
        Instance(input: "He did his very best to make", expected: "Kq28"),
        Instance(input: "I've had to ask you twice!'", expected: "ea5O"),
        Instance(input: "Beware the Jubjub bird, and shun", expected: "MsO8"),
        Instance(input: "They hadn't any feet.", expected: "BGLW"),
        Instance(input: "But wait a bit,' the Oysters cried,", expected: "3dQF"),
        Instance(input: "We can begin to feed.'", expected: "O42G"),
        Instance(input: "Play Audio", expected: "ZOXP"),
        Instance(input: "Do you admire the view?", expected: "mhrm"),
        Instance(input: "All eager for the treat:", expected: "4num"),
        Instance(input: "And more, and more, and more —", expected: "X0Jq"),
        Instance(input: "I wish you were not quite so deaf —", expected: "CoIH"),
        Instance(input: "Before his streaming eyes.", expected: "ox0D"),
        Instance(input: "Four other Oysters followed them,", expected: "2Ga5"),
        Instance(input: "And all of us are fat!'", expected: "RvDU"),
        Instance(input: "Shining with all his might:", expected: "P2oa"),
        Instance(input: "A pleasant walk, a pleasant talk,", expected: "O2DI"),
        Instance(input: "The middle of the night.", expected: "nZrj"),
        Instance(input: "You could not see a cloud, because", expected: "HheC"),
        Instance(input: "“Beware the Jabberwock, my son!", expected: "F58A"),
        Instance(input: "I weep for you,' the Walrus said:", expected: "gm7K"),
        Instance(input: "Long time the manxome foe he sought—", expected: "hYgd"),
        Instance(input: "But answer came there none —", expected: "aLdI"),
        Instance(input: "Their coats were brushed, their faces washed,", expected: "VvZA"),
        Instance(input: "Shall we be trotting home again?'", expected: "Y2l3"),
        Instance(input: "Came whiffling through the tulgey wood,", expected: "MhYF"),
        Instance(input: "“And hast thou slain the Jabberwock?", expected: "VCUb"),
        Instance(input: "\"To come and spoil the fun.\"", expected: "OiVG"),
        Instance(input: "No birds were flying overhead —", expected: "yKcE"),
        Instance(input: "The eldest Oyster winked his eye,", expected: "kqyG"),
        Instance(input: "One, two! One, two! And through and through", expected: "dDpZ"),
        Instance(input: "A loaf of bread,' the Walrus said,", expected: "kUCS"),
        Instance(input: "To give a hand to each.'", expected: "QROn"),
        Instance(input: "They'd eaten every one.\"", expected: "MrvS"),
        Instance(input: "Were walking close at hand;", expected: "Sgcb"),
        Instance(input: "The Walrus did beseech.", expected: "2h7K"),
        Instance(input: "Did gyre and gimble in the wabe:", expected: "ZbVW"),
        Instance(input: "After the day was done —", expected: "PBg4"),
        Instance(input: "Now if you're ready, Oysters dear,", expected: "bb3J"),
        Instance(input: "The moon was shining sulkily,", expected: "v0Gz")

    ])
    func from_precalculated_values(instance: Instance) async throws {
        #expect(instance.input.truncatedHash == instance.expected)
    }
}
