// View

module.exports.jsonParsing = function(code, message, data, json) { 
    var jsonString = {
        "code"     : code,
        "message"  : message,
        "data"     : data
    }

    json(jsonString);
};

