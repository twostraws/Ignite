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
        Instance(input: "", expected: "nO100"),
        Instance(input: "hello world", expected: "xWt36"),
        Instance(input: "12345", expected: "cgbtG"),
        Instance(input: "#&$?!", expected: "8VtjG"),
        Instance(input: "\t", expected: "Wmr20"),
        Instance(input: "\n", expected: "Xmr20")
    ])
    func from_common_strings(instance: Instance) async throws {
        #expect(instance.input.truncatedHash == instance.expected)
    }

    @Test("Precalculated Values from Public Domain Poetry", arguments: [
        Instance(input: "And whether pigs have wings.'", expected: "9poQN"),
        Instance(input: "After we've brought them out so far,", expected: "NOk1H"),
        Instance(input: "\"The sun was shining on the sea,", expected: "SpUil"),
        Instance(input: "Their shoes were clean and neat —", expected: "6xjLC"),
        Instance(input: "O Oysters, come and walk with us!'", expected: "VwCxv"),
        Instance(input: "The billows smooth and bright —", expected: "DTg6L"),
        Instance(input: "And you are very nice!'", expected: "mb9j9"),
        Instance(input: "No cloud was in the sky:", expected: "HTAPf"),
        Instance(input: "It was so kind of you to come!", expected: "zfeX9"),
        Instance(input: "The sea was wet as wet could be,", expected: "EnJIj"),
        Instance(input: "Pepper and vinegar besides", expected: "N7b3m"),
        Instance(input: "Along the briny beach:", expected: "Snek6"),
        Instance(input: "So rested he by the Tumtum tree", expected: "z3Dij"),
        Instance(input: "The Jabberwock, with eyes of flame,", expected: "IktYb"),
        Instance(input: "If seven maids with seven mops", expected: "3v1KZ"),
        Instance(input: "The jaws that bite, the claws that catch!", expected: "gVj9q"),
        Instance(input: "The eldest Oyster looked at him,", expected: "YNtKo"),
        Instance(input: "Before we have our chat;", expected: "jQBN0"),
        Instance(input: "Walked on a mile or so,", expected: "54DK2"),
        Instance(input: "BY LEWIS CARROLL", expected: "TYHr0"),
        Instance(input: "But four young Oysters hurried up,", expected: "prqGL"),
        Instance(input: "To play them such a trick,", expected: "jEC12"),
        Instance(input: "They said, it would be grand!'", expected: "noyLh"),
        Instance(input: "Of shoes — and ships — and sealing-wax —", expected: "jgI4f"),
        Instance(input: "The Carpenter said nothing but", expected: "tovXc"),
        Instance(input: "The night is fine,' the Walrus said.", expected: "r1gPk"),
        Instance(input: "And made them trot so quick!'", expected: "JPt9t"),
        Instance(input: "With sobs and tears he sorted out", expected: "Ybkto"),
        Instance(input: "And this was odd, because, you know,", expected: "Y0BQW"),
        Instance(input: "The vorpal blade went snicker-snack!", expected: "XLYlz"),
        Instance(input: "And then they rested on a rock", expected: "vXRRJ"),
        Instance(input: "Had got no business to be there", expected: "xrPLx"),
        Instance(input: "Those of the largest size,", expected: "hc8tk"),
        Instance(input: "And the mome raths outgrabe.", expected: "0RiGz"),
        Instance(input: "And shook his heavy head —", expected: "nC9BB"),
        Instance(input: "To leave the oyster-bed.", expected: "i7VSX"),
        Instance(input: "The sands were dry as dry.", expected: "A6rU4"),
        Instance(input: "Cut us another slice:", expected: "CU3vh"),
        Instance(input: "They thanked him much for that.", expected: "FaXmr"),
        Instance(input: "O Oysters,' said the Carpenter,", expected: "OzS13"),
        Instance(input: "And why the sea is boiling hot —", expected: "d9Caa"),
        Instance(input: "To talk of many things:", expected: "7TRer"),
        Instance(input: "They wept like anything to see", expected: "ssDeC"),
        Instance(input: "He took his vorpal sword in hand;", expected: "vao0i"),
        Instance(input: "Conveniently low:", expected: "PM2eM"),
        Instance(input: "He went galumphing back.", expected: "NJZd5"),
        Instance(input: "\"It's very rude of him,\" she said,", expected: "e1Z7N"),
        Instance(input: "Is what we chiefly need:", expected: "fb8Cv"),
        Instance(input: "It seems a shame,' the Walrus said,", expected: "fP8gj"),
        Instance(input: "Holding his pocket-handkerchief", expected: "VAggA"),
        Instance(input: "And yet another four;", expected: "ajAuO"),
        Instance(input: "A dismal thing to do!'", expected: "WbHbi"),
        Instance(input: "And thick and fast they came at last,", expected: "NNrL1"),
        Instance(input: "The butter's spread too thick!'", expected: "MYKhM"),
        Instance(input: "You've had a pleasant run!", expected: "c6sIB"),
        Instance(input: "Come to my arms, my beamish boy!", expected: "RLaJg"),
        Instance(input: "Are very good indeed —", expected: "b4GTB"),
        Instance(input: "Such quantities of sand:", expected: "2Zl9A"),
        Instance(input: "There were no birds to fly.", expected: "nw3Sd"),
        Instance(input: "And waited in a row.", expected: "63wbD"),
        Instance(input: "And stood awhile in thought.", expected: "n70hg"),
        Instance(input: "And burbled as it came!", expected: "QkueY"),
        Instance(input: "And all the little Oysters stood", expected: "qkqTR"),
        Instance(input: "And this was scarcely odd, because", expected: "CaBDK"),
        Instance(input: "I doubt it,' said the Carpenter,", expected: "SoRJF"),
        Instance(input: "The time has come,' the Walrus said,", expected: "aOKjq"),
        Instance(input: "Do you suppose,' the Walrus said,", expected: "9Zhvx"),
        Instance(input: "For some of us are out of breath,", expected: "uF4SU"),
        Instance(input: "And scrambling to the shore.", expected: "3dkwB"),
        Instance(input: "He chortled in his joy.", expected: "8Ku4M"),
        Instance(input: "The frumious Bandersnatch!\"", expected: "01rfT"),
        Instance(input: "Of cabbages — and kings —", expected: "f03ED"),
        Instance(input: "Meaning to say he did not choose", expected: "cCksk"),
        Instance(input: "All hopping through the frothy waves,", expected: "hBK3z"),
        Instance(input: "But not on us!' the Oysters cried,", expected: "zltdN"),
        Instance(input: "O frabjous day! Callooh! Callay!\"", expected: "JIe49"),
        Instance(input: "That they could get it clear?'", expected: "pLnwV"),
        Instance(input: "All mimsy were the borogoves,", expected: "DRdDx"),
        Instance(input: "I deeply sympathize.'", expected: "WK3pY"),
        Instance(input: "But never a word he said:", expected: "htsDW"),
        Instance(input: "If this were only cleared away,'", expected: "87PNX"),
        Instance(input: "Swept it for half a year,", expected: "fnKvC"),
        Instance(input: "Because she thought the sun", expected: "VyoPs"),
        Instance(input: "And this was odd, because it was", expected: "IYC1l"),
        Instance(input: "No hurry!' said the Carpenter.", expected: "6vnJn"),
        Instance(input: "After such kindness, that would be", expected: "i0rZJ"),
        Instance(input: "And, as in uffish thought he stood,", expected: "1mGQV"),
        Instance(input: "He left it dead, and with its head", expected: "New9V"),
        Instance(input: "And shed a bitter tear.", expected: "Bl4qg"),
        Instance(input: "We cannot do with more than four,", expected: "DklcY"),
        Instance(input: "'Twas brillig, and the slithy toves", expected: "EZu0d"),
        Instance(input: "The Walrus and the Carpenter", expected: "AaxfY"),
        Instance(input: "Turning a little blue.", expected: "z4ZHb"),
        Instance(input: "He did his very best to make", expected: "Kq28w"),
        Instance(input: "I've had to ask you twice!'", expected: "ea5OZ"),
        Instance(input: "Beware the Jubjub bird, and shun", expected: "MsO85"),
        Instance(input: "They hadn't any feet.", expected: "BGLW5"),
        Instance(input: "But wait a bit,' the Oysters cried,", expected: "3dQFs"),
        Instance(input: "We can begin to feed.'", expected: "O42GV"),
        Instance(input: "Play Audio", expected: "ZOXPI"),
        Instance(input: "Do you admire the view?", expected: "mhrmk"),
        Instance(input: "All eager for the treat:", expected: "4numL"),
        Instance(input: "And more, and more, and more —", expected: "X0Jq1"),
        Instance(input: "I wish you were not quite so deaf —", expected: "CoIHC"),
        Instance(input: "Before his streaming eyes.", expected: "ox0DT"),
        Instance(input: "Four other Oysters followed them,", expected: "2Ga5I"),
        Instance(input: "And all of us are fat!'", expected: "RvDUi"),
        Instance(input: "Shining with all his might:", expected: "P2oa5"),
        Instance(input: "A pleasant walk, a pleasant talk,", expected: "O2DIi"),
        Instance(input: "The middle of the night.", expected: "nZrjm"),
        Instance(input: "You could not see a cloud, because", expected: "HheCO"),
        Instance(input: "Beware the Jabberwock, my son!", expected: "DWVvo"),
        Instance(input: "I weep for you,' the Walrus said:", expected: "gm7KL"),
        Instance(input: "Long time the manxome foe he sought—", expected: "hYgde"),
        Instance(input: "But answer came there none —", expected: "aLdIF"),
        Instance(input: "Their coats were brushed, their faces washed,", expected: "VvZA9"),
        Instance(input: "Shall we be trotting home again?'", expected: "Y2l3X"),
        Instance(input: "Came whiffling through the tulgey wood,", expected: "MhYFs"),
        Instance(input: "And hast thou slain the Jabberwock?", expected: "JWAoq"),
        Instance(input: "\"To come and spoil the fun.\"", expected: "OiVGY"),
        Instance(input: "No birds were flying overhead —", expected: "yKcEK"),
        Instance(input: "The eldest Oyster winked his eye,", expected: "kqyGc"),
        Instance(input: "One, two! One, two! And through and through", expected: "dDpZn"),
        Instance(input: "A loaf of bread,' the Walrus said,", expected: "kUCSC"),
        Instance(input: "To give a hand to each.'", expected: "QROnu"),
        Instance(input: "They'd eaten every one.\"", expected: "MrvST"),
        Instance(input: "Were walking close at hand;", expected: "SgcbX"),
        Instance(input: "The Walrus did beseech.", expected: "2h7KH"),
        Instance(input: "Did gyre and gimble in the wabe:", expected: "ZbVWc"),
        Instance(input: "After the day was done —", expected: "PBg4s"),
        Instance(input: "Now if you're ready, Oysters dear,", expected: "bb3JC"),
        Instance(input: "The moon was shining sulkily,", expected: "v0Gz6")

    ])
    func from_precalculated_values(instance: Instance) async throws {
        #expect(instance.input.truncatedHash == instance.expected)
    }
}
