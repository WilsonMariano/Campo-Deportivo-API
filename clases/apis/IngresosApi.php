<?php

require_once __DIR__ . '/../Ingresos.php';

class IngresosApi {

    public static function GetBetweenDates($request, $response, $args) {

        $params = $request->getQueryParams();

        $res = Ingresos::GetBetweenDates($params['fechaDesde'],  $params['fechaHasta']);

        if(sizeof($res) > 0)
            return $response->withJson([
                'ok'    => true,
                'data'  => $res
            ], 200);

        else
        return $response->withJson([
            'ok'    => false,
            'msg'   => 'No existen datos'
        ], 400);
        
    } 

}