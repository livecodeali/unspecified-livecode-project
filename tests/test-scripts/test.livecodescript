script "TestCiphers"

on TestSetup
    local tSourceFile
    put the filename of me into tSourceFile
    set the itemdelimiter to slash
    put "src/PuzzleTools.livecodescript" into item -3 to -1 of tSourceFile
    start using stack tSourceFile
end TestSetup

private command TestAssertUserThrows pDesc, pHandler, pError
    local tError
    try
        dispatch pHandler to me
    catch tError
    end try

    TestAssert pDesc, tError is pError

    if tError is not pError then
        TestDiagnostic "Expected error:" && pError
        TestDiagnostic "Actual error:" && tError
    end if
end TestAssertUserThrows

on LetterToNumberThrow
    get toNumber("'")
end LetterToNumberThrow

on TestLetterToNumber
    local tIndex
    put 0 into tIndex
    repeat for each char tChar in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        add 1 to tIndex
        TestAssert "uppercase letter" && tChar && "to number correct", \
                toNumber(tChar) is tIndex
    end repeat

    put 0 into tIndex
    repeat for each char tChar in "abcdefghijklmnopqrstuvwxyz"
        add 1 to tIndex
        TestAssert "lowercase letter" && tChar && "to number correct", \
                toNumber(tChar) is tIndex
    end repeat

    TestAssertUserThrows "non alphabetic input to toNumber function throws", \
            "LetterToNumberThrow", "char not in the range A to Z"
end TestLetterToNumber

on TestLetterFromNumber
    local tIndex
    put 0 into tIndex
    repeat for each char tChar in "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        add 1 to tIndex
        TestAssert "uppercase letter" && tChar && "from number correct", \
                fromNumber(tIndex) is tChar
    end repeat

    put 0 into tIndex
    repeat for each char tChar in "abcdefghijklmnopqrstuvwxyz"
        add 1 to tIndex
        TestAssert "lowercase letter" && tChar && "from number correct", \
                fromNumber(tIndex) is tChar
    end repeat
end TestLetterFromNumber

command _TestCaesarCipher pDesc, pSource, pShift, pExpected
    local tResult, tSuccess
    put caesarShift(pSource, pShift) into tResult
    put tResult is pExpected into tSuccess
    TestAssert pDesc, tSuccess

    // If the test failed then log the actual output of caesarShift
    if not tSuccess then
        TestDiagnostic pDesc && "failed"
        TestDiagnostic "Expected result:" && pExpected
        TestDiagnostic "Actual result:" && tResult
    end if
end _TestCaesarCipher

on TestCaesarCipher
    _TestCaesarCipher "abjurer <-> nowhere (13)", "abjurer", 13, "nowhere"
    _TestCaesarCipher "inkier <-> purply (7)", "inkier", 7, "purply"
    _TestCaesarCipher "fusion <-> layout (6)", "fusion", 6, "layout"
    _TestCaesarCipher "manful <-> thumbs (7)", "manful", 7, "thumbs"
    _TestCaesarCipher "primero <-> sulphur (3)", "primero", 3, "sulphur"
    _TestCaesarCipher "steeds <-> tuffet (1)", "steeds", 1, "tuffet"
end TestCaesarCipher

on TestVigenereCipher
    TestAssert "LIVECODE encoded using vigenere cipher with key TEST is EMNXVSVX", \
            vigenereShift("LIVECODE","TEST") is "EMNXVSVX"
end TestVigenereCipher

