module.exports = {
  filters: {
    log: function(arg){
      return console.log(arg);
    },

    wrapIf: function(str, before, after, ifCond){
      return ifCond ? (before + str + after) : str;
    },

    toAnchor: function(heading){
      return heading.toLowerCase().replace(/\s/g, "-");
    },

    add_br: function(str){
      if (str.length < 10) {
        return str;
      }

      // special case this because no algorithm is perfect
      else if (str === "Improve Your Skills") {
        return "Improve <br/>Your Skills";
      }

      else {
        // Find the indices of the two spaces closest to the middle of
        // the string. We'll add our break at the one closest to the middle.
        var midIndex = Math.round(str.length / 2);
        var midSpaces = [
          str.substring(0, midIndex).lastIndexOf(' '),
          str.substring(midIndex).indexOf(' ')
        ];

        if (midSpaces[0] === -1 || midIndex - midSpaces[0] > midSpaces[1]) {
          breakAt = midSpaces[1] + midIndex;
        }
        else {
          breakAt = midSpaces[0];
        }

        return str.substring(0, breakAt) + '<br/>' + str.substring(breakAt);
      }
    },

    contains: function(str, toFind){
      return str.indexOf(toFind) !== -1;
    },

    isTitleCase: function(str){
      var words = str.split(' ');
      var upperLower = util.partition(function(it){
        return it.charAt(0).toUpperCase() === it.charAt(0);
      }, words);
      return upperLower[0] >= upperLower[1];
    }
  }
};
