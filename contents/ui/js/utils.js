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
