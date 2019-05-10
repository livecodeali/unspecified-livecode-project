script "PuzzleToolsLib"

function toNumber pChar
   local tNum
   put chartonum(toUpper(pChar)) - 64 into tNum
   if tNum < 1 or tNum > 26 then
      throw "char not alphabetical"
   else
      return tNum
   end if
end toNumber

function fromNumber pNum
   local tNum
   put (pNum wrap 26) + 64 into tNum
   return numtochar(tNum)
end fromNumber

function caesarShift pTarget, pAmount
   local tOutput
   if pAmount is not a number then
      put toNumber(pAmount) - 1 into pAmount
   end if
   repeat for each char tChar in pTarget
      put fromNumber(toNumber(tChar) + pAmount) after tOutput
   end repeat
   return tOutput
end caesarShift

function vigenereShift pTarget, pCipher
   local tOutput, tCipherSize, tCount
   put the number of chars of pCipher into tCipherSize
   repeat for each char tChar in pTarget
      add 1 to tCount
      put caesarShift(tChar, char (((tCount - 1) mod tCipherSize)+1) of pCipher) after tOutput
   end repeat
   return tOutput
end vigenereShift

function caesarDecode pTarget, pAmount
   if pAmount is not a number then
      put toNumber(pAmount) - 1 into pAmount
   end if
   return caesarShift(pTarget, 26 - pAmount)
end caesarDecode

function vigenereDecode pTarget, pKey
   local tOutput, tKeySize, tCount
   put the number of chars of pKey into tKeySize
   repeat for each char tChar in pTarget
      add 1 to tCount
      put tOutput & caesarDecode(tChar, char (((tCount) mod tKeySize)+1) of pKey) into tOutput
   end repeat
   return tOutput
end vigenereDecode
