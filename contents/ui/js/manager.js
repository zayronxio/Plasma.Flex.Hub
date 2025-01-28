function findClosest(series, target) {
    let closest = series[0];
    let value = 0
    let minDifference = Math.abs(target - closest);

    for (let i = 1; i < series.length; i++) {
        let difference = Math.abs(target - series[i]);
        if (difference < minDifference) {
            value = i;
            minDifference = difference;
        }
    }

    return value;
}

function determinateX(list, row, index, model) {
    var valX = 0
    for (var j = 0; j < list.length; j++ ){
        var ix = parseInt(list[j].split(" ")[1])
        var currentR = parseInt(list[j].split(" ")[0])
        if (currentR === row) {

            if (ix === index) {
                return valX
            } else {
                valX = valX + parseInt(model.get(ix).w)
            }
        }
    }
}


function isSpaceAvailable(x, y, w, h) {
    if ((x + w) <= 4) {
        for (var z = 0; z < h; z++) {
            for (var i = 0; i < w; i++) {
                var cell = (y + z) + " " + (x + i);
                if (gridsFilled.indexOf(cell) !== -1) {
                    return false; // La celda está ocupada
                }
            }
        }
        return true; // Todas las celdas están disponibles
    } else {
        return false;
    }
}

function addedGridsFilled(x, y, h, w){
    for (var z = 0; z < h; z++) {
        for (var i = 0; i < w; i++) {
            var value = (y+z) + " " + (x+i)
            gridsFilled.push(value)
        }
    }
}

function findHighestY(gridsFilled) {
    let highestY = -Infinity;

    for (let i = 0; i < gridsFilled.length; i++) {
        let [y] = gridsFilled[i].split(" ").map(Number);
        if (y > highestY) {
            highestY = y;
        }
    }

    return highestY;
}

function getHighestSecondValue(array) {
    let maxValue = -Infinity;

    for (let i = 0; i < array.length; i++) {
        let parts = array[i].split(" ");
        if (parts.length === 2) {
            let secondValue = Number(parts[1]);
            if (!isNaN(secondValue)) {
                maxValue = Math.max(maxValue, secondValue);
            }
        }
    }

    return maxValue === -Infinity ? null : maxValue; // Retorna null si no se encontraron números válidos
}


function autoOrganizer(model) {
    var gridWidth = 4; // Número máximo de columnas (X: 0, 1, 2, 3)
    var occupiedSpaces = []; // Array bidimensional para registrar casillas ocupadas
    var elementsOrganizer = []; // Almacena las coordenadas y referencias de elementos

    function isSpaceAvailable(x, y, w, h) {
        // Verifica si las casillas necesarias están libres
        for (var i = 0; i < w; i++) {
            for (var j = 0; j < h; j++) {
                if (occupiedSpaces[y + j]?.[x + i]) {
                    return false; // Espacio ocupado
                }
            }
        }
        return true;
    }

    function markSpaceOccupied(x, y, w, h) {
        // Marca las casillas ocupadas por un elemento
        for (var i = 0; i < w; i++) {
            for (var j = 0; j < h; j++) {
                if (!occupiedSpaces[y + j]) {
                    occupiedSpaces[y + j] = [];
                }
                occupiedSpaces[y + j][x + i] = true;
            }
        }
    }

    function findNextAvailableSpace(w, h) {
        // Busca el primer espacio disponible que pueda acomodar el elemento
        for (var y = 0; y < occupiedSpaces.length + 1; y++) {
            for (var x = 0; x <= gridWidth - w; x++) {
                if (isSpaceAvailable(x, y, w, h)) {
                    return { x, y };
                }
            }
        }
        return null; // No se encontró espacio (no debería ocurrir si la lógica es correcta)
    }

    for (var u = 0; u < model.count; u++) {
        var element = model.get(u);
        var w = element.w;
        var h = element.h;

        var space = findNextAvailableSpace(w, h);
        if (space) {
            // Posicionar el elemento
            markSpaceOccupied(space.x, space.y, w, h);
            elementsOrganizer.push({
                index: u,
                x: space.x,
                y: space.y,
                w: w,
                h: h
            });
        }
    }

    // Generar modelo con las coordenadas calculadas
    for (var v = 0; v < elementsOrganizer.length; v++) {
        var org = elementsOrganizer[v];
        readyModel.append({
            w: model.get(org.index).w,
                          h: model.get(org.index).h,
                          source: model.get(org.index).source,
                          elementId: model.get(org.index).elementId,
                          indexOrigin: org.index,
                          x: org.x,
                          y: org.y,
                          isCustomControl: model.get(org.index).isCustomControl
        });
    }
}
