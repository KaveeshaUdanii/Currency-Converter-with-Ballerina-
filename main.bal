import ballerina/http;

service /convert on new http:Listener(5501) {

    resource function get .(http:Caller caller, http:Request req) returns error? {
        string fromCurrency = req.getQueryParamValue("from") ?: "USD";
        string toCurrency = req.getQueryParamValue("to") ?: "LKR";
        string amountStr = req.getQueryParamValue("amount") ?: "0";

        // Convert string to float manually with error handling
        float amount = 0.0;
        if amountStr != "" {
            var parsed = checkpanic floatFromString(amountStr);
            amount = parsed;
        }

        float rate = getMockRate(fromCurrency, toCurrency);
        float convertedAmount = amount * rate;

        json response = {
            convertedAmount: convertedAmount
        };

        http:Response res = new;
        res.setPayload(response);
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.setHeader("Content-Type", "application/json");

        check caller->respond(res);
    }
}

function floatFromString(string s) returns float|error {
    decimal|error d = decimal:fromString(s);
    if (d is decimal) {
        return <float> d;
    } else {
        return d;
    }
}

function getMockRate(string fromCurrency, string toCurrency) returns float {
    if fromCurrency == "USD" && toCurrency == "LKR" {
        return 330.0;
    } else if fromCurrency == "LKR" && toCurrency == "USD" {
        return 1 / 330.0;
    } else if fromCurrency == "USD" && toCurrency == "EUR" {
        return 0.93;
    } else if fromCurrency == "EUR" && toCurrency == "USD" {
        return 1.08;
    } else if fromCurrency == "USD" && toCurrency == "GBP" {
        return 0.79;
    } else if fromCurrency == "GBP" && toCurrency == "USD" {
        return 1.26;
    } else if fromCurrency == toCurrency {
        return 1.0;
    } else {
        return 1.0;
    }
}
