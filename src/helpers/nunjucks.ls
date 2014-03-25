module.exports =
    filters:
      log: (arg) -> console.log(arg)

      wrapIf: (str, before, after, ifCond) ->
        if ifCond
          before + str + after
        else
          str

      add_br: (str) -> 
        if(str.length < 10)
          str
        else
          # Find the indices of the two spaces closest to the middle of the string. 
          # We'll add our break at the one closest to the middle.
          midIndex = Math.round(str.length/2)
          midSpaces = [str.substring(0, midIndex).lastIndexOf(' '), str.substring(midIndex).lastIndexOf(' ')]
          breakAt   = if (midIndex - midSpaces[0]) < (midSpaces[1] - midIndex) then midSpaces[0] else midSpaces[1]

          str.substring(0, breakAt) + '<br/>' + str.substring(breakAt)

      # try to determine if a string is titlecase 
      isTitleCase: (str) ->
        words = str.split(' ')
        upperLower = util.partition((-> it.charAt(0).toUpperCase() == it.charAt(0)), words)
        upperLower[0] >= upperLower[1]