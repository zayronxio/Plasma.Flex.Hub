function obtenerDatosClimaticos(latitud, longitud, fechaInicio, fechaFin, hours, callback) {
    let url = `https://api.open-meteo.com/v1/forecast?latitude=${latitud}&longitude=${longitud}&hourly=temperature_2m,weather_code&current=temperature_2m,is_day,weather_code,wind_speed_10m&hourly=uv_index&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&start_date=${fechaInicio}&end_date=${(fechaFin)}`;

    const now = new Date();
    const hoursC = now.getHours(); // Horas (0-23)
    const minutes = now.getMinutes(); // Minutos (0-59)
    const currentTime =  minutes > 44 ? hoursC + 2 : hoursC + 1;


    let req = new XMLHttpRequest();
    req.open("GET", url, true);

    req.onreadystatechange = function () {
        if (req.readyState === 4) {
            if (req.status === 200) {
                let datos = JSON.parse(req.responseText);
                let currents = datos.current;
                let isday = currents.is_day;

                let temperaturaActual = currents.temperature_2m;
                let windSpeed = currents.wind_speed_10m;
                let codeCurrentWeather = currents.weather_code;

                let datosDiarios = datos.daily;
                let propabilityPrecipitationCurrent = datosDiarios.precipitation_probability_max[0];

                let hourly = datos.hourly
                let propabilityUVindex = hourly.uv_index[hours];

                let tempForecastHorylOne = hourly.temperature_2m[currentTime];
                let tempForecastHorylTwo = hourly.temperature_2m[currentTime + 1];
                let tempForecastHorylThree = hourly.temperature_2m[currentTime + 2];
                let tempForecastHorylFour = hourly.temperature_2m[currentTime + 3];
                let tempForecastHorylFive = hourly.temperature_2m[currentTime + 4];

                let hoursWether = tempForecastHorylOne + " " + tempForecastHorylTwo + " " + tempForecastHorylThree + " " + tempForecastHorylFour + " " + tempForecastHorylFive

                let codeForecastHorylOne = hourly.weather_code[currentTime];
                let codeForecastHorylTwo = hourly.weather_code[currentTime + 1];
                let codeForecastHorylThree = hourly.weather_code[currentTime + 2];
                let codeForecastHorylFour = hourly.weather_code[currentTime + 3];
                let codeForecastHorylFive = hourly.weather_code[currentTime + 4];

                let weather_codeWether = codeForecastHorylOne + " " + codeForecastHorylTwo + " " + codeForecastHorylThree + " " + codeForecastHorylFour + " " + codeForecastHorylFive

                let tempMin = datosDiarios.temperature_2m_min[0];
                let tempMax = datosDiarios.temperature_2m_max[0];

                let full = temperaturaActual + " " + tempMin + " " + tempMax + " " + codeCurrentWeather + " " + propabilityPrecipitationCurrent + " " + windSpeed + " " + propabilityUVindex + " " + isday + " " + hoursWether + " " + weather_codeWether
                console.log(`${full}`);
                callback(full);
                console.log(`https://api.open-meteo.com/v1/forecast?latitude=${latitud}&longitude=${longitud}&hourly=temperature_2m,weather_code&current=temperature_2m,is_day,weather_code,wind_speed_10m&hourly=uv_index&daily=temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&start_date=${fechaInicio}&end_date=${fechaInicio}`)
            } else {
                console.error(`Error en la solicitud: weathergeneral ${req.status}`);
                //callback(`failed ${req.status}`)
            }
        }
    };

    req.send();
}
