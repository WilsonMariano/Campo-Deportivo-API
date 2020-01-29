<?php

require_once __DIR__ . '/../RangoEdad.php';
require_once __DIR__ . '/../Valores.php';

class ValoresApi {

    public static function GetValor($request, $response) {

        $params = $request->getQueryParams();

        $rangoEdad = RangoEdad::getRangoWithAge($params['edad']);

        $valor = Valores::GetValor($params['codPrestacion'], $rangoEdad->codEdad, $params['codDia'], $params['codTipoSocio'], $params['codParentesco']);

        if($valor != false) {

            return $response->withJson([
                'ok'    => true,
                'data' => $valor
            ], 200);
        
        } else
            return $response->withJson([
                'ok'    => false,
                'msg'   => 'No hay resultados'
            ], 404);
        
    
    }
}
