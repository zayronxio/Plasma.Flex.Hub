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

function autoOrganizer(model) {
    var elementsExcludes = []
    var elementsInRow = 0
    var elementsOrganizer = []
    var currentRow = 0
    var widthElements = 0
    var maxHeights = []
    var valuesX = []
    for (var u = 0; u < model.count; u++) {
        maxHeights.push(0)
        if (model.get(u).w === 4) {
            if (elementsInRow === 0) {
                elementsOrganizer.push(currentRow + " " + u)

                maxHeights[currentRow] = maxHeights[currentRow] < model.get(u).h ? model.get(u).h : maxHeights[currentRow]
                currentRow = currentRow + 1
            } else {
                currentRow = currentRow + 1
                elementsOrganizer.push(currentRow + " " + u)

                maxHeights[currentRow] = maxHeights[currentRow] < model.get(u).h ? model.get(u).h : maxHeights[currentRow]
                currentRow = currentRow + 1
            }
        } else {
            if (model.get(u).w === 2) {
                if (elementsInRow <= 2) {

                    elementsOrganizer.push(currentRow + " " + u)

                    maxHeights[currentRow] = maxHeights[currentRow] < model.get(u).h ? model.get(u).h : maxHeights[currentRow]
                    elementsInRow = elementsInRow + model.get(u).w
                    if (elementsInRow === 4) {
                        currentRow = currentRow + 1
                        elementsInRow = 0
                    }
                } else {
                    elementsExcludes.push(u)
                }
            } else {
                if (model.get(u).w === 1) {
                    elementsOrganizer.push(currentRow + " " + u)

                    maxHeights[currentRow] = maxHeights[currentRow] < model.get(u).h ? model.get(u).h : maxHeights[currentRow]
                    elementsInRow = elementsInRow + model.get(u).w
                    if (elementsInRow === 4) {
                        currentRow = currentRow + 1
                        elementsInRow = 0
                    }
                }
            }

        }

    }
    for (var o = 0; o < elementsExcludes.length; o++) {
        if ((elementsInRow + elementsExcludes[o]) <= 4) {
            elementsOrganizer.push(currentRow + " " + elementsExcludes[o])

            maxHeights[currentRow] = maxHeights[currentRow] < model.get(u).h ? model.get(u).h : maxHeights[currentRow]
            elementsInRow = elementsInRow + model.get(elementsExcludes[o]).w
            if (elementsInRow === 4) {
                currentRow = currentRow + 1
                elementsInRow = 0
            }
        }

    }
    for (var i = 1; i < maxHeights.length; i++){

        maxHeights[i] = maxHeights[i] + maxHeights[(i - 1)]
    }

    for (var v = 0; v < elementsOrganizer.length; v++){
        var index = parseInt(elementsOrganizer[v].split(" ")[1])
        var row = parseInt(elementsOrganizer[v].split(" ")[0])
        var valueY = row === 0 ? 0 : maxHeights[row - 1]
        var valueX = determinateX(elementsOrganizer, row, index, model)
        readyModel.append({
            w: model.get(index).w,
                          h: model.get(index).h,
                          source: model.get(index).source,
                          elementId: model.get(index).elementId,
                          indexOrigin: index,
                          elements: 0,
                          x: determinateX(elementsOrganizer, row, index, model),
                          y: valueY
        });

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
