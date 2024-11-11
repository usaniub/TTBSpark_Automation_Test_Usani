def simpleCipher(txt:str, offset:int):

    offset=offset%26

    letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    cipher_txt = []

    if offset < 0 :
        shifted_letters = letters[abs(offset):] + letters[abs(offset)]
    elif offset > 0 :
        shifted_letters = letters[-offset:] + letters[:-offset]
    else :
        shifted_letters = letters

    for text in txt:
        if text.isalpha():
            for i in range(26):
                if text == letters[i]: cipher_txt.append(shifted_letters[i])
        else: cipher_txt.append(text)

    # print(cipher_text)
    for item in cipher_txt: print(item, end="")

    return cipher_txt


# Call function simpleCipher 
encrypted = "VTAOG"
k=2
simpleCipher(encrypted,k)