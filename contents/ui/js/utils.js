const NET_DATA_SOURCE =
"awk -v OFS=, 'NR > 2 { print substr($1, 1, length($1)-1), $2, $10 }' /proc/net/dev";

function parseTransferData(data) {
    const transferData = {};

    // Separamos los datos por líneas
    const lines = data.trim().split("\n");

    // Recorremos cada línea de los datos
    for (const line of lines) {
        // Dividimos la línea por coma
        const [name, rx, tx] = line.split(",");

        // Ignoramos la interfaz 'lo'
        if (name === "lo") {
            continue;
        }

        // Añadimos los datos al objeto transferData
        transferData[name] = { rx: parseInt(rx), tx: parseInt(tx) };
    }

    return transferData;
}

function calcSpeedData(prevTransferData, nextTransferData, duration) {
    const speedData = {};

    for (const key in nextTransferData) {
        if (prevTransferData && key in prevTransferData) {
            const prev = prevTransferData[key];
            const next = nextTransferData[key];
            speedData[key] = {
                down: ((next.rx - prev.rx) * 1000) / duration,
                up: ((next.tx - prev.tx) * 1000) / duration,
                downTotal: nextTransferData[key].rx,
                upTotal: nextTransferData[key].tx,
            };
        }
    }

    return speedData;
}

function createArray(list) {
    let array = [], n_arrays = 0;

    function added(element) {
        array[n_arrays] = array[n_arrays] || [];
        var elementt = element.includes("[") ? element.replace("[", '') : element
        array[n_arrays].push(parseInt(elementt.replace(/^\s+|\s+$/g, '')));
    }

    list.forEach(item => {
        if (item[0] + item[1] === "[ ") {
            added(item.replace("[ [", ''));
        } else if (item[item.length - 1] === "]") {
            added(item.replace("]", ''));
            n_arrays++;
        } else if (item[0] === "[" || item[1] === "[") {
            added(item.replace("[", ''));
        } else if (item !== "]") {
            added(item);
        }
    });

    return array;
}

function added(list, element) {
    var newList = []
    newList = list
    newList.push("["+element[0])
    for (var i = 1; i < element.length; i++) {
        if (i === element.length -1) {
            newList.push(element[i] + "]")
        } else {
            newList.push(element[i])
        }
    }
    return createArray(newList)// Devuelve la lista modificada
}


