const Units = {
    Celsius: 0,
    Fahrenheit: 1,
    Kelvin: 2
}

function convertUnit(value, from, to) {
    if (value == undefined || value == NaN) {
        return undefined;
    }

    if (from === to) {
        return value;
    }

    switch (from) {
        case Units.Celsius:
            switch (to) {
                case Units.Fahrenheit:
                    return (value * 1.8) + 32;
                case Units.Kelvin:
                    return value + 273.15;
                default:
                    return undefined;
            }
            break;
        case Units.Fahrenheit:
            switch (to) {
                case Units.Celsius:
                    return (value - 32) / 1.8;
                case Units.Kelvin:
                    return ((value - 32) / 1.8) + 273.15;
                default:
                    return undefined;
            }
            break;
        case Units.Kelvin:
            switch (to) {
                case Units.Celsius:
                    return value - 273.15;
                case Units.Fahrenheit:
                    return ((value - 273.15) * 1.8) + 32;
                default:
                    return undefined;
            }
            break;
        default:
            return undefined;
    }

    return undefined;
}

function roundedTemperature(value) {
    return Math.round(value);
}

function unitString(unit, includeSpace = true) {
    let text = "";

    if (includeSpace) {
        text += "\u2009";
    }

    switch (unit) {
        case Units.Celsius:
        default:
            return text + "°C";
        case Units.Fahrenheit:
            return text + "°F";
        case Units.Kelvin:
            return text + "K";
    }
}

function formatTemperature(value, unit, showUnit = true) {
    if (value === undefined) {
        return "—";
    }

    return roundedTemperature(value) + (showUnit ? unitString(unit) : "");
}
