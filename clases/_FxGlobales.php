<?php

class _FxGlobales {

    public static function AddHours($hora, $horasSumar) {

        $parts = explode(':', $hora);

        $minSum = $parts[0] * 60;
        $minSum += $parts[1];
        $minSum += ($horasSumar * 60); 

        $horasTotales = intdiv($minSum, 60);
        $minTotales = $minSum % 60;
        
        return $horasTotales . ':' . $minTotales;
    }

    public static function SubHours($hora, $horasSumar) {

        $parts = explode(':', $hora);

        $minSum = $parts[0] * 60;
        $minSum += $parts[1];
        $minSum -= ($horasSumar * 60); 

        $horasTotales = intdiv($minSum, 60);
        $minTotales = $minSum % 60;
        
        return $horasTotales . ':' . $minTotales;
    }
}