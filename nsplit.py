
# This function breaks long text lines into lines which will fit on a screen or page
# It breaks lines on whitespace
# If a single 'word' is longer than the requested line length it will be placed in its own line but will still exceed the line length

def nsplit(s,n):
    output = []
    words = s.split()
    while (words):
        line = words.pop(0)
        while (words and len(line)+len(words[0]) < n):
            line += " " + words.pop(0)
        output.append(line)
    return output
